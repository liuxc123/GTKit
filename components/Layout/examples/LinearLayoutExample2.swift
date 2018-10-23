//
//  LinearLayoutExample2.swift
//  GTCatalog
//
//  Created by liuxc on 2018/9/11.
//

import UIKit


class LinearLayoutExample2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}


extension LinearLayoutExample2 {
    @objc class func catalogBreadcrumbs() -> [String] {
        return [ "Layout", "LinearLayout", "LinearLayout-Combine with UIScrollView"]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }

    @objc class func catalogIsPresentable() -> Bool {
        return false
    }
}
