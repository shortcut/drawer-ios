//
//  SnapshotTestsTests.swift
//  SnapshotTestsTests
//
//  Created by Denis Dzyubenko on 17/03/2020.
//  Copyright © 2020 Shortcut. All rights reserved.
//

import XCTest
@testable import SnapshotTests
import SnapshotTesting
import Drawer

class SnapshotTestsTests: XCTestCase {
    let staticVC = StaticDrawerContentViewController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaults() {
        let hostVC = HostViewController()

        let config = DrawerConfiguration()

        let drawerVC = DrawerViewController(viewController: staticVC, configuration: config)

        assertSnapshot(matching: hostVC, as: Snapshotting.windowsImageWithAction {
            hostVC.present(drawerVC, animated: false)
        })
    }

    func testDefaultAt50Procent() {
        let hostVC = HostViewController()

        let config = DrawerConfiguration(
            snapPoints: [
            ],
            defaultSnapPoint: .fraction(value: 0.5))

        let drawerVC = DrawerViewController(viewController: staticVC, configuration: config)

        assertSnapshot(matching: hostVC, as: Snapshotting.windowsImageWithAction {
            hostVC.present(drawerVC, animated: false)
        })
    }

    func testDefaultRegardlessOfSnapPoints() {
        let hostVC = HostViewController()

        let config = DrawerConfiguration(
            snapPoints: [
                .fraction(value: 0.9),
                .fraction(value: 0.1),
            ],
            defaultSnapPoint: .fraction(value: 0.5))

        let drawerVC = DrawerViewController(viewController: staticVC, configuration: config)

        assertSnapshot(matching: hostVC, as: Snapshotting.windowsImageWithAction {
            hostVC.present(drawerVC, animated: false)
        })
    }

    func testDefaultFixed() {
        let hostVC = HostViewController()

        let config = DrawerConfiguration(
            snapPoints: [
            ],
            defaultSnapPoint: .fixed(value: 100))

        let drawerVC = DrawerViewController(viewController: staticVC, configuration: config)

        assertSnapshot(matching: hostVC, as: Snapshotting.windowsImageWithAction {
            hostVC.present(drawerVC, animated: false)
        })
    }

    func testDrawerWidth() {
        let hostVC = HostViewController()

        let config = DrawerConfiguration(
            snapPoints: [
            ],
            defaultSnapPoint: .fixed(value: 100),
            drawerWidth: 150)

        let drawerVC = DrawerViewController(viewController: staticVC, configuration: config)

        assertSnapshot(matching: hostVC, as: Snapshotting.windowsImageWithAction {
            hostVC.present(drawerVC, animated: false)
        })
    }
}
