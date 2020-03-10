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
//            
//        func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//            
//            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.8) {
//
//                
//            }
//            animator.addCompletion { position in
//                transitionContext.completeTransition(.end == position)
//            }
//            
//            return animator
//            UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.8) {
//                self.drawerDelegate?.drawerViewController(self.drawerViewController,
//                                                          didScrollTopTo: snapTargetY)
//                topConstraint.constant = snapTargetY
//                containerView.layoutIfNeeded()
//            }
//        }
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.4
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            let containerView = transitionContext.containerView
            
            let animationDuration = transitionDuration(using: transitionContext)
            
            toViewController.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
            toViewController.view.layer.shadowColor = UIColor.black.cgColor
            toViewController.view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            toViewController.view.layer.shadowOpacity = 0.3
            toViewController.view.layer.cornerRadius = 4.0
            toViewController.view.clipsToBounds = true
            
            containerView.addSubview(toViewController.view)
                    
            UIView.animate(withDuration: animationDuration, animations: {
                toViewController.view.transform = CGAffineTransform.identity
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
            })

        }
    }
    
    class Dismission: NSObject, UIViewControllerAnimatedTransitioning {
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.4
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            let containerView = transitionContext.containerView
            
            let animationDuration = transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: animationDuration, animations: {
                fromViewController.view.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
