//
//  PalettesExampleViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

import GTKitComponents.GTPalettes
import GTFTextAccessibility

/**
 Returns a high-contrast color for text against @c backgroundColor. If no such color can be found,
 returns black.

 @params backgroundColor the background color to use for contrast calculations.

 @returns a color with sufficiently-high contrast against @c backgroundColor, else just returns
 black.
 */
func TextColorFor(backgroundColor: UIColor) -> UIColor {
    if let safeColor = GTFTextAccessibility.textColor(fromChoices: [.black, .white],
                                                      onBackgroundColor: backgroundColor,
                                                      options: [ .enhancedContrast, .preferDarker ]) {
        return safeColor
    } else if let safeColor = GTFTextAccessibility.textColor(fromChoices: [.black, .white],
                                                             onBackgroundColor: backgroundColor,
                                                             options: .preferDarker) {
        return safeColor
    }
    return .black
}

typealias ExampleTone = (name: String, tone: UIColor)

func ExampleTonesForPalette(_ palette: GTCPalette) -> [ExampleTone] {
    var tones: [ExampleTone] = [
        (GTCPaletteTint.tint100Name.rawValue, palette.tint100),
        (GTCPaletteTint.tint300Name.rawValue, palette.tint300),
        (GTCPaletteTint.tint500Name.rawValue, palette.tint500),
        (GTCPaletteTint.tint700Name.rawValue, palette.tint700)
    ]

    if let accent = palette.accent400 {
        tones.append((GTCPaletteAccent.accent400Name.rawValue, accent))
    }

    return tones
}

class PalettesExampleViewController: UITableViewController {
    var palettes : [(name: String, palette: GTCPalette)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return palettes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let palette = palettes[section].palette
        return ExampleTonesForPalette(palette).count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let paletteInfo = palettes[indexPath.section]
        let tones = ExampleTonesForPalette(paletteInfo.palette)
        cell!.textLabel!.text = tones[indexPath.row].name
        cell!.backgroundColor = tones[indexPath.row].tone
        cell!.textLabel!.textColor = TextColorFor(backgroundColor: cell!.backgroundColor!)
        cell!.selectionStyle = .none

        return cell!
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            if let backgroundColor = headerView.backgroundColor != nil ? headerView.backgroundColor
                : tableView.backgroundColor {
                headerView.textLabel?.textColor = TextColorFor(backgroundColor: backgroundColor)
            } else {
                headerView.textLabel?.textColor = .black
            }
        }
    }

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return palettes[section].name
    }

    convenience init() {
        self.init(style: .grouped)
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
