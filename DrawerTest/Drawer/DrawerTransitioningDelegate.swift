//
//  DrawerTransitioningDelegate.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class DrawerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let defaultSnapPoint: DrawerSnapPoint
    let disabledSnapPoints: Set<DrawerSnapPoint>

    override init() {
        self.defaultSnapPoint = .bottom
        self.disabledSnapPoints = []
        super.init()
    }

    init(snapPoint: DrawerSnapPoint, disabledSnapPoints: Set<DrawerSnapPoint> = []) {
        self.defaultSnapPoint = snapPoint
        self.disabledSnapPoints = disabledSnapPoints
        super.init()
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented,
                                            presenting: presenting,
                                            defaultSnapPoint: defaultSnapPoint,
                                            disabledSnapPoints: disabledSnapPoints)
    }
}
