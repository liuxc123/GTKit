//
//  DialogsAlertViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/10/11.
//

import UIKit
import GTKitComponents.GTDialogs

class DialogsAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DialogsAlertViewController {

    @objc class func catalogBreadcrumbs() -> [String] {
        return ["Dialogs", "AlertController"]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }
}
