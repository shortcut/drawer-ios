//
//  DrawerTransitioningDelegate.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class DrawerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var configuration: DrawerConfiguration = DrawerConfiguration()

    var animationBlock: ((CGFloat) -> ())?
    
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
                                            snapPoints: configuration.snapPoints,
                                            defaultSnapPoint: configuration.defaultSnapPoint)
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
    
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return DrawerAnimatedTransitioning.Presentation()
//    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let drawerVC = presented as? DrawerViewController,
        let delegate = drawerVC.delegate
            else {
            return nil
        }

        let dismiss = DrawerAnimatedTransitioning.Presentation()
        dismiss.initialY = drawerVC.configuration.defaultSnapPoint?.topMargin(containerHeight: presenting.view.frame.size.height)
        dismiss.drawerDelegate = delegate
        return dismiss
    }
}
