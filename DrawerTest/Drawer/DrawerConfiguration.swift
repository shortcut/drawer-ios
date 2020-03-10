//
//  DrawerConfiguration.swift
//  DrawerTest
//
//  Created by Andre Navarro on 3/9/20.
//  Copyright © 2020 Shortcut. All rights reserved.
//

import Foundation

struct DrawerConfiguration {
    var snapPoints: [DrawerSnapPoint] = []
    var defaultSnapPoint: DrawerSnapPoint?

    var shouldAllowTouchPassthrough: Bool = false
}
