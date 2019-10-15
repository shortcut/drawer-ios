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
  
  private let viewController: UIViewController
  
  init(viewController: UIViewController) {
    self.viewController = viewController
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  required init?(coder: NSCoder) {
    preconditionFailure()
  }
  
  func setup() {
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    
    addChild(viewController)

    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(viewController.view)
    view.addSubview(dragIndicatorView)

    NSLayoutConstraint.activate([
      viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    NSLayoutConstraint.activate([
      dragIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      dragIndicatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
      dragIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
      dragIndicatorView.heightAnchor.constraint(equalToConstant: 5),
    ])
  }
}
