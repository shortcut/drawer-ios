//
//  StaticViewController.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 01/11/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class StaticViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .gray

    let closeBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                         target: self, action: #selector(dismissMe))
    navigationItem.rightBarButtonItem = closeBarButton

    let closeButton = UIButton(type: .custom)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.setTitle("Dismiss", for: .normal)
    closeButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside)
    view.addSubview(closeButton)

    NSLayoutConstraint.activate([
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  @objc func dismissMe() {
    dismiss(animated: true)
  }
}
