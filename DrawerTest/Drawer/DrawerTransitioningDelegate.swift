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

class DrawerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var configuration: DrawerConfiguration = DrawerConfiguration()

    var animationBlock: ((CGFloat) -> Void)?

    override init() {
        super.init()
    }

    init(configuration: DrawerConfiguration) {
        self.configuration = configuration
        super.init()
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        guard let drawerVC = presented as? DrawerViewController else {
            return nil
        }
        return DrawerPresentationController(presentedViewController: drawerVC,
                                            presenting: presenting,
                                            configuration: configuration)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let drawerVC = dismissed as? DrawerViewController,
            let delegate = drawerVC.delegate
        else {
            return nil
        }

        let dismiss = DrawerAnimatedTransitioning.Dismission()
        dismiss.drawerDelegate = delegate
        return dismiss
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let drawerVC = presented as? DrawerViewController,
            let delegate = drawerVC.delegate
        else {
            return nil
        }

        let dismiss = DrawerAnimatedTransitioning.Presentation()
        dismiss.initialY = drawerVC.configuration.defaultSnapPoint.topMargin(containerHeight: presenting.view.frame.size.height)
        dismiss.drawerDelegate = delegate
        return dismiss
    }
}
