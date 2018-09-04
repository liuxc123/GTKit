//
//  DragonCell.swift
//  Catalog
//
//  Created by liuxc on 2018/8/23.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import Foundation
import GTCatalog

class DragonCell: NSObject {
    var node: GTFNode
    var expanded: Bool = false

    init(node: GTFNode) {
        self.node = node
    }
}
