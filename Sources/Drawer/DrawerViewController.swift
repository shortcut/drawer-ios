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

public protocol DrawerViewControllerDelegate: class {
    func drawerViewController(_ viewController: DrawerViewController, didScrollTopTo yPoint: CGFloat)
    func drawerViewController(_ viewController: DrawerViewController, didSnapTo point: DrawerSnapPoint)

    // not implemented yet
    func drawerViewControllerWillShow(_ viewController: DrawerViewController)
    func drawerViewControllerDidShow(_ viewController: DrawerViewController)
    func drawerViewControllerWillDismiss(_ viewController: DrawerViewController)
    func drawerViewControllerDidDismiss(_ viewController: DrawerViewController)
}

public class DrawerViewController: UIViewController {
    let dragIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        return view
    }()

    override public var modalPresentationStyle: UIModalPresentationStyle {
        get {.custom }
        set { }
    }

    /// The view controller to be presented inside the drawer.
    private(set) var viewController: UIViewController?

    var drawerTransitioningDelegate: DrawerTransitioningDelegate?
    var drawerPresentationController: DrawerPresentationController? {
        self.presentationController as? DrawerPresentationController
    }
    
    public weak var delegate: DrawerViewControllerDelegate?

    public private(set) var configuration: DrawerConfiguration = DrawerConfiguration()

    public init(viewController: UIViewController? = nil,
                configuration: DrawerConfiguration = DrawerConfiguration()) {

        self.viewController = viewController
        self.configuration = configuration

        // need to keep a reference to the delegate
        self.drawerTransitioningDelegate = DrawerTransitioningDelegate(configuration: configuration)

        super.init(nibName: nil, bundle: nil)
        self.transitioningDelegate = drawerTransitioningDelegate
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public func moveToDrawerSnapPoint(_ snapPoint: DrawerSnapPoint, animated: Bool = true) {
        guard configuration.snapPoints.contains(snapPoint) else {
            return
        }
        
        drawerPresentationController?.moveToDrawerSnapPoint(snapPoint, animated: animated)
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
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 5)
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
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.bringSubviewToFront(dragIndicatorView)
    }
}
