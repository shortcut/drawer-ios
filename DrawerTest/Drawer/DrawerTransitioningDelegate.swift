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
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        DrawerAnimatedTransitioning.Dismission()
//    }
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        DrawerAnimatedTransitioning.Presentation()
//    }
}
