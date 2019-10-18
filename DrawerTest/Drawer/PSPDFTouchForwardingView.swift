//
//  PSPDFTouchForwardingView.swift
//  Sats-MemberApp
//
//  Created by Denis Dzyubenko on 17/10/2019.
//  Copyright © 2019 Vikram. All rights reserved.
//

import UIKit

// Inspired by https://pspdfkit.com/blog/2015/presentation-controllers/
class PSPDFTouchForwardingView: UIView {
    var passthroughViews: [UIView] = []

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let target = super.hitTest(point, with: event) else {
            return nil
        }

        guard target == self else {
            return target
        }

        for view in passthroughViews {
            let pt = self.convert(point, to: view)
            if let target = view.hitTest(pt, with: event) {
                return target
            }
        }

        return self
    }
}
