//
//  ViewController.swift
//  DrawerTest
//
//  Created by Denis Dzyubenko on 15/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  let drawerWithStaticView: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Drawer", for: .normal)
    return button
  }()
  let drawerWithNavBar: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Drawer with Navigation Bar", for: .normal)
    return button
  }()
  let drawerWithScrollView: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Drawer with Scroll View inside", for: .normal)
    return button
  }()
 
    let trackingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red
        return view
    }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let buttons = [
      drawerWithStaticView,
      drawerWithNavBar,
      drawerWithScrollView,
    ]

    buttons.forEach(stackView.addArrangedSubview)

    view.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    NSLayoutConstraint.activate(buttons.map {
      $0.heightAnchor.constraint(equalToConstant: 40)
    })
    
    drawerWithStaticView.addTarget(self, action: #selector(makeDrawerWithStaticView), for: .touchUpInside)
    drawerWithNavBar.addTarget(self, action: #selector(makeDrawerWithNavBar), for: .touchUpInside)
    drawerWithScrollView.addTarget(self, action: #selector(makeDrawerWithScrollView), for: .touchUpInside)
    
    trackingView.frame.origin.y = self.view.frame.size.height - 120
    self.view.addSubview(trackingView)
  }

  @objc func makeDrawerWithStaticView() {
    let config = DrawerConfiguration(snapPoints: [.top,
                                                  .fraction(value: 0.7),
                                                  .fraction(value: 0.2),
                                                  .dismiss],
                                     defaultSnapPoint: .fraction(value: 0.7), shouldAllowTouchPassthrough: true)
    
    let drawerVC = DrawerViewController(viewController: TableViewController(),
                                        configuration: config)
    drawerVC.delegate = self
    present(drawerVC, animated: true)
  }

  @objc func makeDrawerWithNavBar() {
    let t1 = StaticViewController()
    t1.view.backgroundColor = .purple
    t1.navigationItem.title = "First"
    
    let t2 = StaticViewController()
    t2.view.backgroundColor = .lightGray
    t2.navigationItem.title = "Second"
    
    let navigationVC = UINavigationController(rootViewController: t1)
    navigationVC.pushViewController(t2, animated: false)
    let config = DrawerConfiguration(snapPoints: [.top,
                                                  .fraction(value: 0.7),
                                                  .fraction(value: 0.2),
                                                  .dismiss],
                                     defaultSnapPoint: .fraction(value: 0.7), shouldAllowTouchPassthrough: true)
    

    let drawerVC = DrawerViewController(viewController: navigationVC, configuration: config)
    present(drawerVC, animated: true)
  }

  @objc func makeDrawerWithScrollView() {
    let t1 = TableViewController()
    t1.navigationItem.title = "First"
    
//    let t2 = TableViewController()
//    t2.navigationItem.title = "Second"
    
    let navigationVC = UINavigationController(rootViewController: t1)
//    navigationVC.pushViewController(t2, animated: false)

    let config = DrawerConfiguration(snapPoints: [.top,
                                                  .fraction(value: 0.7),
                                                  .fraction(value: 0.2),
                                                  .dismiss],
                                     defaultSnapPoint: .fraction(value: 0.7), shouldAllowTouchPassthrough: true)

    let drawerVC = DrawerViewController(viewController: navigationVC, configuration: config)
    drawerVC.delegate = self
    present(drawerVC, animated: true)
  }
}

extension ViewController: DrawerViewControllerDelegate {
    func drawerViewController(_ viewController: DrawerViewController, didScrollTopTo yPoint: CGFloat) {
        trackingView.frame.origin.y = yPoint - 120
        print(yPoint)
    }
    
    func drawerViewController(_ viewController: DrawerViewController, didSnapTo point: DrawerSnapPoint) {
        print(point)
    }
    
    // not implemented yet
    func drawerViewControllerWillShow(_ viewController: DrawerViewController) {
        
    }
    
    func drawerViewControllerDidShow(_ viewController: DrawerViewController) {
        
    }
    
    func drawerViewControllerWillDismiss(_ viewController: DrawerViewController) {
        
    }
    
    func drawerViewControllerDidDismiss(_ viewController: DrawerViewController) {
        
    }
}
