//
//  PalettesStandardExample.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

import GTKitComponents.GTPalettes

class PalettesStandardExampleViewController: PalettesExampleViewController {

    convenience init() {
        self.init(style: .grouped)
        self.palettes = [
            ("Red", .red),
            ("Pink", .pink),
            ("Purple", .purple),
            ("Deep Purple", .deepPurple),
            ("Indigo", .indigo),
            ("Blue", .blue),
            ("Light Blue", .lightBlue),
            ("Cyan", .cyan),
            ("Teal", .teal),
            ("Green", .green),
            ("Light Green", .lightGreen),
            ("Lime", .lime),
            ("Yellow", .yellow),
            ("Amber", .amber),
            ("Orange", .orange),
            ("Deep Orange", .deepOrange),
            ("Brown", .brown),
            ("Grey", .grey),
            ("Blue Grey", .blueGrey)
        ]
    }
}

// MARK: - Catalog by convention
extension PalettesStandardExampleViewController {
    @objc class func catalogBreadcrumbs() -> [String] {
        return ["Palettes", "Standard Palettes"]
    }

    @objc class func catalogDescription() -> String {
        return "The Palettes component provides sets of reference colors that work well together."
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return true
    }

    @objc class func catalogIsPresentable() -> Bool {
        return true
    }
}

