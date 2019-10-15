//
//  DrawerTransitioningDelegate.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class DrawerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController) -> UIPresentationController? {
    return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
  }
}
