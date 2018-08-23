//
//  AppDelegate.swift
//  Catalog
//
//  Created by liuxc on 2018/8/16.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import UIKit
import GTCatalog
import GTKitComponents.GTAppBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GTCAppBarNavigationControllerDelegate {

    var window: UIWindow?

    let navigationController = GTCAppBarNavigationController()


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

        navigationController.delegate = self
        navigationController.pushViewController(rootNodeViewController, animated: false)
        navigationController.interactivePopGestureRecognizer?.delegate = navigationController

        self.configNotification()

        self.window?.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
        return true
    }

    func configNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeDidChange), name: AppTheme.didChangeGlobalThemeNotificationName, object: nil)
    }

    @objc func themeDidChange(notification: NSNotification) {
        guard let colorScheme = notification.userInfo?[AppTheme.globalThemeNotificationColorSchemeKey]
            as? GTCColorScheming else {
                return
        }
        for viewController in navigationController.childViewControllers {
            guard let appBar = navigationController.appBarViewController(for: viewController) else {
                continue
            }

//            GTCAppBarColorThemer.applySemanticColorScheme(colorScheme, to: appBar.ap)
        }
    }


    // MARK: GTCAppBarNavigationControllerInjectorDelegate

    func appBarNavigationController(_ navigationController: GTCAppBarNavigationController,
                                    willAdd appBarViewController: GTCAppBarViewController,
                                    asChildOf viewController: UIViewController) {
        GTCAppBarColorThemer.applyColorScheme(AppTheme.globalTheme.colorScheme,
                                              to: appBarViewController)
        GTCAppBarTypographyThemer.applyTypographyScheme(AppTheme.globalTheme.typographyScheme,
                                                        to: appBarViewController)

        if let injectee = viewController as? CatalogAppBarInjectee {
            injectee.appBarNavigationControllerInjector(willAdd: appBarViewController)
        }
    }


    func configShakeAction() {
        UIApplication.shared.applicationSupportsShakeToEdit = true
        self.becomeFirstResponder()
    }

    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        return
    }

    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        return
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake { // 判断是否是摇动结束
            print("摇动结束");
        }
        return
    }
}

protocol CatalogAppBarInjectee {
    func appBarNavigationControllerInjector(willAdd appBarViewController: GTCAppBarViewController)
}

extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

