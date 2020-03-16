//
//  DrawerPresentationController.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class DrawerPresentationController: UIPresentationController {
    let configuration: DrawerConfiguration
    var currentSnapPoint: DrawerSnapPoint

    var drawerDismissalTapGR: UITapGestureRecognizer?
    let touchForwardingView = PSPDFTouchForwardingView()
    var startingLocation: CGPoint = .zero
    var startingFrame: CGRect = .zero
    var drawerY: CGFloat {
        set { presentedView?.frame.origin.y = newValue }
        get { presentedView?.frame.origin.y ?? CGFloat.greatestFiniteMagnitude }
    }

    var scrollView: UIScrollView?
    var currentAnimator: UIViewPropertyAnimator?

    var drawerViewController: DrawerViewController
    var drawerDelegate: DrawerViewControllerDelegate? { drawerViewController.delegate }

    /// Whether we are locked to dragging a drawer
    var isDragging: Bool = false

    init(presentedViewController: DrawerViewController,
         presenting presentingViewController: UIViewController?,
         configuration: DrawerConfiguration) {
        self.drawerViewController = presentedViewController
        self.configuration = configuration
        self.currentSnapPoint = configuration.defaultSnapPoint

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned))
        panGesture.delegate = self
        presentedViewController.view.addGestureRecognizer(panGesture)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        guard
            let containerView = containerView,
            let presentedView = presentedView
            else {
                assertionFailure()
                return
        }

        presentedView.frame = containerView.bounds
        if let width = configuration.drawerWidth {
            presentedView.frame.size.width = width
        }
        drawerY = configuration.defaultSnapPoint
            .topMargin(containerHeight: containerView.bounds.height)
    }

    func adjustScrollViewContentOffset() {
        guard let scrollView = scrollView else { return }
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }

    @objc func panned(_ gesture: UIPanGestureRecognizer) {
        guard
            let containerView = containerView,
            let presentedView = presentedView
            else {
                assertionFailure()
                return
        }

        let location = gesture.location(in: containerView)

        switch gesture.state {
        case .began:
            currentAnimator?.stopAnimation(true)

            isDragging = false

            startingLocation = location
            startingFrame = presentedView.frame
            scrollView = {
                var view = containerView.hitTest(location, with: nil)

                repeat {
                    if let scrollView = view as? UIScrollView {
                        return scrollView
                    }
                    view = view?.superview
                } while (view != nil)

                return nil
            }()

        case .changed:

            let distance = location.y - startingLocation.y
            let locationY = max(0, startingFrame.origin.y + distance)

            let shouldBeginDragging: Bool = {
                guard let scrollView = scrollView else {
                    return true
                }

                if scrollView.contentOffset.y <= 0 {
                    return true
                }

                return false
            }()

            if !isDragging && shouldBeginDragging {
                isDragging = true

                adjustScrollViewContentOffset()

                // Tell UIScrollView to cancel its scrolling
                scrollView?.isScrollEnabled = false
                scrollView?.isScrollEnabled = true
            }

            if isDragging {
                self.drawerDelegate?.drawerViewController(self.drawerViewController,
                                                          didScrollTopTo: locationY)
                drawerY = locationY
                containerView.layoutIfNeeded()
            }
        case .ended:
            if isDragging {
                let verticalVelocity = gesture.velocity(in: containerView).y
                let snapPoint: DrawerSnapPoint

                if abs(verticalVelocity) > 400 {
                    let isFlickingUp = verticalVelocity < 0

                    // find the nearest snap point that is
                    //  a) vertically higher (when flicking up)
                    //  b) vertically lower (when flicking down)
                    // than the current position
                    let presentedViewMinY = presentedView.frame.minY
                    let snapLocations = configuration.snapPoints.map { $0.topMargin(containerHeight: containerView.bounds.height) }
                    let snapDistances = snapLocations
                        .enumerated()
                        .sorted { (a, b) -> Bool in
                            a.element < b.element
                    }

                    let maybeSnapIndex: Int? = {
                        if isFlickingUp {
                            return snapDistances
                                .filter { $0.element < presentedViewMinY }
                                .last?.offset
                        } else {
                            return snapDistances
                                .filter { $0.element > presentedViewMinY }
                                .first?.offset
                        }
                    }()

                    if let snapIndex = maybeSnapIndex {
                        snapPoint = configuration.snapPoints[snapIndex]
                    } else {
                        snapPoint = currentSnapPoint
                    }
                } else {
                    // find the closest snap point to the current position
                    let presentedViewMinY = presentedView.frame.minY
                    let snapLocations = configuration.snapPoints.map { $0.topMargin(containerHeight: containerView.bounds.height) }
                    let snapDistances = snapLocations.map { abs($0 - presentedViewMinY) }
                        .enumerated()
                        .sorted { (a, b) -> Bool in
                            a.element < b.element
                    }
                    let snapIndex = snapDistances.first?.offset ?? 0
                    snapPoint = configuration.snapPoints[snapIndex]
                }

                moveToDrawerSnapPoint(snapPoint, animated: true)
            }

        case .cancelled, .failed, .possible:
            break

        @unknown default:
            assertionFailure()
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        let containerRect = containerView.bounds
        let height = configuration.defaultSnapPoint.drawerHeight(containerHeight: containerRect.height)
        return CGRect(x: 0, y: containerRect.maxY - height,
                      width: containerRect.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView else {
            assertionFailure()
            return
        }

        touchForwardingView.frame = containerView.bounds
        containerView.insertSubview(touchForwardingView, at: 0)

        let drawerViewController = presentedViewController as? DrawerViewController
        if drawerViewController?.configuration.shouldAllowTouchPassthrough ?? false {
            touchForwardingView.passthroughViews = [presentingViewController.view]
        }

        setupDrawerDismissalTapRecogniser()
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
          return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.drawerDelegate?.drawerViewController(self.drawerViewController, didScrollTopTo: self.drawerY)
        })
    }

    func setupDrawerDismissalTapRecogniser() {
        guard drawerDismissalTapGR == nil else { return }
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleDrawerDismissalTap))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        tapGesture.delaysTouchesBegan = false
        tapGesture.delaysTouchesEnded = false
        tapGesture.delegate = self
        presentingViewController.view.addGestureRecognizer(tapGesture)
        drawerDismissalTapGR = tapGesture
    }

    @objc func handleDrawerDismissalTap() {
        self.drawerDelegate?.drawerViewControllerWillDismiss(self.drawerViewController)
        self.presentedViewController.dismiss(animated: true, completion: nil)
        self.drawerDelegate?.drawerViewControllerDidDismiss(self.drawerViewController)
    }
    
    public func moveToDrawerSnapPoint(_ snapPoint: DrawerSnapPoint, animated: Bool) {
        guard let containerView = containerView else {
                return
        }
        
        self.currentSnapPoint = snapPoint
        let snapTargetY = snapPoint.topMargin(containerHeight: containerView.bounds.height)

        currentAnimator?.stopAnimation(true)
        currentAnimator = UIViewPropertyAnimator(duration: configuration.animationDuration, dampingRatio: 0.8) {
            self.drawerDelegate?.drawerViewController(self.drawerViewController,
                                                      didScrollTopTo: snapTargetY)
            self.drawerY = snapTargetY
            containerView.layoutIfNeeded()
        }
        currentAnimator?.addCompletion { _ in
            self.drawerDelegate?.drawerViewController(self.drawerViewController,
                                                      didSnapTo: self.currentSnapPoint)
            if case .dismiss = snapPoint {
                self.drawerDelegate?.drawerViewControllerWillDismiss(self.drawerViewController)
                self.presentedViewController.dismiss(animated: false, completion: nil)
                self.drawerDelegate?.drawerViewControllerDidDismiss(self.drawerViewController)
            }
        }
        currentAnimator?.startAnimation()
    }
}

extension DrawerPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer {
            return true
        }
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer,
           let view = gestureRecognizer.view,
           view.isDescendant(of: presentedView!),
           let subview = view.hitTest(touch.location(in: view), with: nil) {
            return !(subview is UIControl)
        } else {
            return true
        }
    }
}
