//
//  Snapshotting+insideHostWindowWithAction.swift
//  SnapshotTestsTests
//
//  Created by Denis Dzyubenko on 17/03/2020.
//  Copyright © 2020 Shortcut. All rights reserved.
//

import SnapshotTesting

extension Snapshotting where Value: UIViewController, Format == UIImage {
    static func windowsImageWithAction(_ action: @escaping ()->Void) -> Snapshotting {
        return Snapshotting<UIImage, UIImage>.image.asyncPullback { vc in
            Async<UIImage> { callback in
                UIView.setAnimationsEnabled(false)
                let window = UIApplication.shared.windows[0]
                window.rootViewController = vc
                action()
                DispatchQueue.main.async {
                    let image = UIGraphicsImageRenderer(bounds: window.bounds).image { ctx in
                        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                    }
                    callback(image)
                    UIView.setAnimationsEnabled(true)
                }
            }
        }
    }
}
