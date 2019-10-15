//
//  DrawerPresentationController.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class DrawerPresentationController: UIPresentationController {
  let snapFractions: [CGFloat] = [
    0,
    0.3,
    0.6,
  ]
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned))
    panGesture.delegate = self
    presentedViewController.view.addGestureRecognizer(panGesture)
  }
  
  var startingLocation: CGPoint = .zero
  var startingFrame: CGRect = .zero
  var scrollView: UIScrollView?

  /// Whether we are locked to dragging a drawer
  var isDragging: Bool = false
//    return scrollView?.contentOffset.y ?? 0 <= 0
  
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
        let rect = CGRect(
          x: 0, y: locationY,
          width: startingFrame.size.width, height: containerView.bounds.height - locationY)
        presentedView.frame = rect
      }

    case .ended:
      if isDragging {
        let presentedViewMinY = presentedView.frame.minY
        let snapLocations = snapFractions.map { containerView.bounds.height * $0 }
        let snapDistances = snapLocations.map { abs($0 - presentedViewMinY) }
          .enumerated()
          .sorted { (a, b) -> Bool in
            a.element < b.element
        }
        
        let snapIndex = snapDistances.first?.offset ?? 0
        let snapTargetY = snapFractions[snapIndex] * containerView.bounds.height
        let snapTargetFrame = CGRect(x: 0, y: snapTargetY, width: containerView.bounds.width, height: containerView.bounds.height - snapTargetY)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
          presentedView.frame = snapTargetFrame
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
    let height = containerRect.height * 2 / 3
    return CGRect(x: 0, y: containerRect.maxY - height,
                  width: containerRect.width, height: height)
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
