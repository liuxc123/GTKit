//
//  HeaderView.swift
//  Catalog
//
//  Created by liuxc on 2018/8/23.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet var containerView: HeaderView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(containerView)
        self.backgroundColor = .clear
        containerView.backgroundColor = .clear
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.textColor = UIColor(white: 1, alpha: 1)
        title.font = UIFont.systemFont(ofSize: 20)
        let image = GTCDrawDragons.image(with: GTCDrawDragons.drawDragon,
                                         size: CGSize(width: 40,
                                                      height: 40),
                                         fillColor: .white)
        imageView.image = image

        // To make the search icon tinted white we have to reach the internal UITextField of the UISearchBar
        if let searchBarTextField = self.searchBar.value(forKey: "_searchField") as? UITextField,
            let glassIconView = searchBarTextField.leftView as? UIImageView {
            searchBarTextField.tintColor = .white
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
        }
        searchBar.scopeBarBackgroundImage = UIImage()
    }

}
