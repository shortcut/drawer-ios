//
//  DrawerTransitioningDelegate.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class DrawerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var snapPoints: [DrawerSnapPoint] = []
    var defaultSnapPoint: DrawerSnapPoint?

    override init() {
        super.init()
    }

    init(snapPoints: [DrawerSnapPoint], defaultSnapPoint: DrawerSnapPoint? = nil) {
        self.snapPoints = snapPoints
        self.defaultSnapPoint = defaultSnapPoint
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
                                            snapPoints: snapPoints,
                                            defaultSnapPoint: defaultSnapPoint)
    }
}
