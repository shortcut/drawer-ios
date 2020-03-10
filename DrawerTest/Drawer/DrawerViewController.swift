//
//  DrawerViewController.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

protocol DrawerViewControllerDelegate: class {
    func drawerViewController(_ viewController: DrawerViewController, didScrollTopTo yPoint: CGFloat)
    func drawerViewController(_ viewController: DrawerViewController, didSnapTo point: DrawerSnapPoint)
    
    func drawerViewControllerWillShow(_ viewController: DrawerViewController)
    func drawerViewControllerDidShow(_ viewController: DrawerViewController)
    func drawerViewControllerWillDismiss(_ viewController: DrawerViewController)
    func drawerViewControllerDidDismiss(_ viewController: DrawerViewController)
}

class DrawerViewController: UIViewController {
    let dragIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        return view
    }()
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {.custom }
        set { }
    }
    
    /// The view controller to be presented inside the drawer.
    private(set) var viewController: UIViewController?

    var drawerTransitioningDelegate: DrawerTransitioningDelegate?
    
    weak var delegate: DrawerViewControllerDelegate?
    
    /// Specifies whether touching outside of the drawer bounds should
    /// forward touch events to the view controller in the background.
    var shouldAllowTouchPassthrough: Bool = false

    init(viewController: UIViewController? = nil,
         configuration: DrawerConfiguration = DrawerConfiguration()) {
        
        self.viewController = viewController
        
        // need to keep a reference to the delegate
        self.drawerTransitioningDelegate = DrawerTransitioningDelegate(configuration: configuration)
        
        shouldAllowTouchPassthrough = configuration.shouldAllowTouchPassthrough
        
        super.init(nibName: nil, bundle: nil)
        self.transitioningDelegate = drawerTransitioningDelegate
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
