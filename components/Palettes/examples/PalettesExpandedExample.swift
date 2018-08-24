//
//  PalettesGeneratedExampleViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

import GTKitComponents.GTPalettes

private func randomFloat() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

private func generateRandomPalettes(_ count: Int) -> [(name: String, palette: GTCPalette)] {
    var palettes = [(name: String, palette: GTCPalette)]()
    for _ in 1...count {
        let rgb = [randomFloat(), randomFloat(), randomFloat()]
        let name = String(format: "Generated from #%2X%2X%2X",
                          Int(rgb[0] * 255),
                          Int(rgb[1] * 255),
                          Int(rgb[2] * 255))
        let color = UIColor.init(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
        palettes.append((name, GTCPalette.init(generatedFrom: color)))
    }
    return palettes
}

class PalettesGeneratedExampleViewController: PalettesExampleViewController {

    fileprivate let numPalettes = 10

    convenience init() {
        self.init(style: .grouped)
        self.palettes = generateRandomPalettes(numPalettes)
    }
}

// MARK: - Catalog by convention
extension PalettesGeneratedExampleViewController {
    @objc class func catalogBreadcrumbs() -> [String] {
        return ["Palettes", "Generated Palettes"]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }

    @objc class func catalogIsPresentable() -> Bool {
        return false
    }
}
