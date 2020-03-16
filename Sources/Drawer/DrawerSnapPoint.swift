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

public enum DrawerSnapPoint: Equatable {
    case top
    case middle
    case bottom
    /// Fraction of the container height
    /// E.g. value of 0.5 makes it snap to the middle
    case fraction(value: CGFloat)
    /// Snap to the specified vertical offset
    case fixed(value: CGFloat)
    /// Dragging the drawer to this snap point will
    /// cause it to be dismissed
    case dismiss

    /// The constant/length of the constraint between the top of the drawer view
    /// and the top of the container view safe area.
    func topMargin(containerHeight height: CGFloat) -> CGFloat {
        switch self {
        case .top:
            return 0
        case .middle:
            return height * 0.5
        case .bottom:
            return height - 140
        case .dismiss:
            return height
        case let .fraction(value):
            return height * value
        case let .fixed(value):
            return value
        }
    }

    /// The height of the drawer view
    func drawerHeight(containerHeight height: CGFloat) -> CGFloat {
        height - topMargin(containerHeight: height)
    }
}
