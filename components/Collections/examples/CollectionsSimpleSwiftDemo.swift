//
//  CollectionsSimpleSwiftDemo.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

import UIKit

import GTKitComponents.GTCollections

class CollectionsSimpleSwiftDemo: GTCCollectionViewController {

    let reusableIdentifierItem = "itemCellIdentifier"
    let colors = [ "red", "blue", "green", "black", "yellow", "purple" ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell class.
        self.collectionView?.register(GTCCollectionViewTextCell.self,
                                      forCellWithReuseIdentifier: reusableIdentifierItem)

        // Customize collection view settings.
        self.styler.cellStyle = .card
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifierItem,
                                                      for: indexPath)
        if let cell = cell as? GTCCollectionViewTextCell {
            cell.textLabel?.text = colors[indexPath.item]
        }

        return cell
    }
}

// MARK: Catalog by convention
extension CollectionsSimpleSwiftDemo {
    @objc class func catalogBreadcrumbs() -> [String] {
        return [ "Collections", "Simple Swift Demo"]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }

    @objc class func catalogIsPresentable() -> Bool {
        return false
    }
}
