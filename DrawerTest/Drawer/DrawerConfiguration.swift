//
//  DrawerConfiguration.swift
//  DrawerTest
//
//  Created by Andre Navarro on 3/9/20.
//  Copyright © 2020 Shortcut. All rights reserved.
//

import UIKit

struct DrawerConfiguration {
    var snapPoints: [DrawerSnapPoint] = [.middle, .dismiss]
    var defaultSnapPoint: DrawerSnapPoint? = .middle

    var drawerWidth: CGFloat?
    
    var shouldAllowTouchPassthrough: Bool = false
}
