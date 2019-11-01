//
//  DrawerViewController.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    let dragIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        return view
    }()

    /// The view controller to be presented inside the drawer.
    private(set) var viewController: UIViewController?

    /// Specifies whether touching outside of the drawer bounds should
    /// forward touch events to the view controller in the background.
    var shouldAllowTouchPassthrough: Bool = false

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        view.addSubview(dragIndicatorView)

        NSLayoutConstraint.activate([
            dragIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragIndicatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            dragIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 5),
        ])

        if let viewController = self.viewController {
            setViewController(viewController)
        }
    }

    /// Set the view controller that is presented inside the drawer.
    func setViewController(_ viewController: UIViewController) {
        self.viewController?.willMove(toParent: nil)
        self.viewController?.view.removeFromSuperview()
        self.viewController?.removeFromParent()
        self.viewController?.didMove(toParent: nil)

        self.viewController = viewController

        addChild(viewController)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)

        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        view.bringSubviewToFront(dragIndicatorView)
    }
}
