//
//  StaticDrawerContentViewController.swift
//  SnapshotTestsTests
//
//  Created by Denis Dzyubenko on 17/03/2020.
//  Copyright © 2020 Shortcut. All rights reserved.
//

import UIKit

/// A simple view controller that is displayed inside a drawer.
/// This is a simple static view controller with just a background color set.
class StaticDrawerContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
    }
}
