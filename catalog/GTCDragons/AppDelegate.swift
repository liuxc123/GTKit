//
//  AppDelegate.swift
//  GTCDragons
//
//  Created by liuxc on 2018/8/28.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import UIKit
import GTCatalog
import GTKitComponents.GTAppBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UIApplication.shared.statusBarStyle = .lightContent

        let tree = GTFCreateNavigationTree()
        var rootNodeViewController: UIViewController

        /**
         To have your example show up as the initial view controller, you need it to implement
         the method `@objc class func catalogIsDebug() -> Bool` and have it return true.
         That way it will become the debugLeaf and be presented first.
         */
        if let debugLeaf = tree.debugLeaf {
            rootNodeViewController = debugLeaf.createExampleViewController()
        } else {
            rootNodeViewController = GTCDragonsController(node: tree)
        }

//        navigationController.delegate = self
        navigationController.pushViewController(rootNodeViewController, animated: false)
        navigationController.interactivePopGestureRecognizer?.delegate = navigationController

//        self.configNotification()

        self.window?.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
        return true
    }

}

extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

