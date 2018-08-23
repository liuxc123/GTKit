//
//  GTCDragonsTableViewCell.swift
//  Catalog
//
//  Created by liuxc on 2018/8/23.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import UIKit
import GTCatalog
import GTKitComponents.GTIcons_ic_arrow_back

class GTCDragonsTableViewCell: UITableViewCell {

    lazy var defaultButton: UIButton = {
        let image = GTCIcons.imageFor_ic_chevron_right()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(image, for: .normal)
        return button
    }()

    lazy var expandedButton: UIButton = {
        let image = GTCIcons.imageFor_ic_chevron_right()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(image, for: .normal)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        return button
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryView = self.defaultButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
