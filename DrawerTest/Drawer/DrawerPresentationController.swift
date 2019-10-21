//
//  DrawerPresentationController.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class DrawerPresentationController: UIPresentationController {
    let defaultSnapPoint: DrawerSnapPoint
    let snapPoints: [DrawerSnapPoint]
    var currentSnapPoint: DrawerSnapPoint

    let touchForwardingView = PSPDFTouchForwardingView()
    var startingLocation: CGPoint = .zero
    var startingFrame: CGRect = .zero
    var topConstraint: NSLayoutConstraint?
    var scrollView: UIScrollView?

    /// Whether we are locked to dragging a drawer
    var isDragging: Bool = false

    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         defaultSnapPoint: DrawerSnapPoint,
         disabledSnapPoints: Set<DrawerSnapPoint>) {
        self.defaultSnapPoint = defaultSnapPoint
        if disabledSnapPoints.contains(defaultSnapPoint) {
            assertionFailure("The default snap point can't be a disabled snap point")
        }
        if disabledSnapPoints == Set(DrawerSnapPoint.allCases) {
            assertionFailure("You can't disable all snap points")
        }
        self.snapPoints = DrawerSnapPoint.allCases.filter { !disabledSnapPoints.contains($0) }
        self.currentSnapPoint = defaultSnapPoint
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned))
        panGesture.delegate = self
        presentedViewController.view.addGestureRecognizer(panGesture)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        guard topConstraint == nil else { return }

        guard
            let containerView = containerView,
            let presentedView = presentedView
            else {
                assertionFailure()
                return
        }

        presentedView.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = presentedView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor)
        topConstraint.constant = defaultSnapPoint.topMargin(containerHeight: containerView.bounds.height)

        let bottomConstraint = presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        bottomConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])

        self.topConstraint = topConstraint
    }

    func adjustScrollViewContentOffset() {
        guard let scrollView = scrollView else { return }
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }

    @objc func panned(_ gesture: UIPanGestureRecognizer) {
        guard
            let containerView = containerView,
            let presentedView = presentedView,
            let topConstraint = topConstraint
            else {
                assertionFailure()
                return
        }

        let location = gesture.location(in: containerView)

        switch gesture.state {
        case .began:
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
                topConstraint.constant = locationY
                containerView.layoutIfNeeded()
            }

        case .ended:
            if isDragging {
                let presentedViewMinY = presentedView.frame.minY
                let verticalVelocity = gesture.velocity(in: containerView).y
                let snapLocations = snapPoints.map { $0.topMargin(containerHeight: containerView.bounds.height) }

                let snapPoint: DrawerSnapPoint

                if abs(verticalVelocity) > 1000 {
                    if verticalVelocity < 0 {
                        // flicking upward
                        snapPoint = currentSnapPoint.up
                    } else {
                        // flicking downward
                        snapPoint = currentSnapPoint.down
                    }
                } else {
                    let snapDistances = snapLocations.map { abs($0 - presentedViewMinY) }
                        .enumerated()
                        .sorted { (a, b) -> Bool in
                            a.element < b.element
                    }
                    let snapIndex = snapDistances.first?.offset ?? 0
                    snapPoint = snapPoints[snapIndex]
                }

                let snapTargetY = snapPoint.topMargin(containerHeight: containerView.bounds.height)

                self.currentSnapPoint = snapPoint

                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseInOut,
                               animations: {
                    topConstraint.constant = snapTargetY
                    containerView.layoutIfNeeded()
                }, completion: { _ in
                    if case .dismiss = snapPoint {
                        self.presentedViewController.dismiss(animated: false, completion: nil)
                    }
                })
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
        let height = defaultSnapPoint.drawerHeight(containerHeight: containerRect.height)
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
        touchForwardingView.passthroughViews = [presentingViewController.view]
        containerView.insertSubview(touchForwardingView, at: 0)
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
}
