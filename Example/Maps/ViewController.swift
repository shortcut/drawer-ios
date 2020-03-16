import UIKit
import Drawer
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    lazy var searchDrawerVC: SearchDrawerViewController = {
        let vc = storyboard!.instantiateViewController(identifier: "SearchDrawer")
        return vc as! SearchDrawerViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let config = DrawerConfiguration(
            snapPoints: [
                .fixed(value: 60),
                .fraction(value: 0.6),
                .fixed(value: view.bounds.height - 100),
            ],
            defaultSnapPoint: .fraction(value: 0.6),
            shouldAllowTouchPassthrough: true)

        let drawerVC = DrawerViewController(viewController: searchDrawerVC, configuration: config)
        drawerVC.delegate = self
        present(drawerVC, animated: true)
    }
}

extension ViewController: DrawerViewControllerDelegate {
    func drawerViewController(_ viewController: DrawerViewController, didScrollTopTo yPoint: CGFloat) {
        searchDrawerVC.resignSearchFocus()
    }

    func drawerViewController(_ viewController: DrawerViewController, didSnapTo point: DrawerSnapPoint) {
    }

    func drawerViewControllerWillShow(_ viewController: DrawerViewController) {
        searchDrawerVC.resignSearchFocus()
    }

    func drawerViewControllerDidShow(_ viewController: DrawerViewController) {
    }

    func drawerViewControllerWillDismiss(_ viewController: DrawerViewController) {
    }

    func drawerViewControllerDidDismiss(_ viewController: DrawerViewController) {
    }
}
