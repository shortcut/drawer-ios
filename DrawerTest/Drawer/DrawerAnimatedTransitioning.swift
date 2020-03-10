//
//  DrawerAnimatedTransitioning.swift
//  DrawerTest
//
//  Created by Andre Navarro on 3/10/20.
//  Copyright © 2020 Shortcut. All rights reserved.
//

import UIKit

struct DrawerAnimatedTransitioning {
    
    class Presentation: NSObject, UIViewControllerAnimatedTransitioning {
        weak var drawerDelegate: DrawerViewControllerDelegate?
        var initialY: CGFloat?
    
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.4
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DrawerViewController
            let containerView = transitionContext.containerView

            let animationDuration = transitionDuration(using: transitionContext)

            toViewController.view.frame.origin.y = containerView.bounds.height
            containerView.addSubview(toViewController.view)

            UIView.animate(withDuration: animationDuration, animations: {
                toViewController.view.frame.origin.y = self.initialY ?? 0
                self.drawerDelegate?.drawerViewController(toViewController, didScrollTopTo: toViewController.view.frame.origin.y)
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
            })

        }
    }
    
    class Dismission: NSObject, UIViewControllerAnimatedTransitioning {
        weak var drawerDelegate: DrawerViewControllerDelegate?

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.4
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! DrawerViewController
            let containerView = transitionContext.containerView
            
            let animationDuration = transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.drawerDelegate?.drawerViewController(fromViewController, didScrollTopTo: fromViewController.view.frame.origin.y)
                fromViewController.view.frame.origin.y = containerView.bounds.height
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
