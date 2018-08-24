//
//  NavigationBarTypicalUseExampleSupplemental.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

import UIKit
import GTKitComponents.GTNavigationBar

extension NavigationBarTypicalUseSwiftExample {

    // (GTCatalog)

    @objc class func catalogBreadcrumbs() -> [String] {
        return [ "Navigation Bar", "Navigation Bar (Swift)" ]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }

    func catalogShouldHideNavigation() -> Bool {
        return true
    }

    @objc class func catalogIsPresentable() -> Bool {
        return false
    }

}
