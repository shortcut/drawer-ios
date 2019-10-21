//
//  DrawerSnapPoint.swift
//  DrawerTest
//
//  Created by Toni Sučić on 18/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

enum DrawerSnapPoint: CaseIterable {
    case top
    case middle
    case bottom
    /// Dragging the drawer to this snap point will
    /// cause it to be dismissed
    case dismiss

    /// The constant/length of the constraint between the top of the drawer view
    /// and the top of the container view safe area.
    func topMargin(containerHeight height: CGFloat) -> CGFloat {
        switch self {
        case .top:
            return 8
        case .middle:
            return height * 0.5
        case .bottom:
            return height - 140
        case .dismiss:
            return height
        }
    }

    /// The height of the drawer view
    func drawerHeight(containerHeight height: CGFloat) -> CGFloat {
        height - topMargin(containerHeight: height)
    }
}
