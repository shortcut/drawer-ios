//  Copyright (c) 2020 Shortcut AS
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

struct DrawerAnimatedTransitioning {

    class Presentation: NSObject, UIViewControllerAnimatedTransitioning {
        weak var drawerDelegate: DrawerViewControllerDelegate?
        var initialY: CGFloat?
        var width: CGFloat?
        var animationDuration: TimeInterval = 0.3
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return animationDuration
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DrawerViewController
            let containerView = transitionContext.containerView

            let animationDuration = transitionDuration(using: transitionContext)

            if let width = width {
                toViewController.view.frame.size.width = width
            }
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
        var animationDuration: TimeInterval = 0.3

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return animationDuration
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! DrawerViewController
            let containerView = transitionContext.containerView

            let animationDuration = transitionDuration(using: transitionContext)

            UIView.animate(withDuration: animationDuration, animations: {
                self.drawerDelegate?.drawerViewController(fromViewController, didScrollTopTo: fromViewController.view.frame.origin.y)
                fromViewController.view.frame.origin.y = containerView.bounds.height
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
