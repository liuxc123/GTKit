//
//  ButtonsSimpleExampleSwiftViewController.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//
import Foundation
import UIKit

import GTKitComponents.GTButtons

class ButtonsSimpleExampleSwiftViewController: UIViewController {

    let floatingButtonPlusDimension = CGFloat(24)
    let kMinimumAccessibleButtonSize = CGSize(width: 64, height: 48)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        //let titleColor = UIColor.white
        let backgroundColor = UIColor(white: 0.1, alpha: 1.0)

        let containedButton = GTCButton()
        containedButton.setTitle("Tap Me Too", for: .normal)
        containedButton.sizeToFit()
        let containedButtonVerticalInset =
            min(0, -(kMinimumAccessibleButtonSize.height - containedButton.bounds.height) / 2);
        let containedButtonHorizontalInset =
            min(0, -(kMinimumAccessibleButtonSize.width - containedButton.bounds.width) / 2);
        containedButton.hitAreaInsets =
            UIEdgeInsetsMake(containedButtonVerticalInset, containedButtonHorizontalInset,
                             containedButtonVerticalInset, containedButtonHorizontalInset);
        containedButton.translatesAutoresizingMaskIntoConstraints = false
        containedButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(containedButton)

        let textButton = GTCButton()
        textButton.setTitle("Touch me", for: UIControlState())
        textButton.sizeToFit()
        let textButtonVerticalInset =
            min(0, -(kMinimumAccessibleButtonSize.height - textButton.bounds.height) / 2);
        let textButtonHorizontalInset =
            min(0, -(kMinimumAccessibleButtonSize.width - textButton.bounds.width) / 2);
        textButton.hitAreaInsets =
            UIEdgeInsetsMake(textButtonVerticalInset, textButtonHorizontalInset,
                             textButtonVerticalInset, textButtonHorizontalInset);
        textButton.translatesAutoresizingMaskIntoConstraints = false
        textButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(textButton)

        let floatingButton = GTCFloatingButton()
        floatingButton.backgroundColor = backgroundColor
        floatingButton.mode = .expanded
        floatingButton.sizeToFit()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)

//        let plusShapeLayer = ButtonsTypicalUseSupplemental.createPlusShapeLayer(floatingButton)
//        floatingButton.layer.addSublayer(plusShapeLayer)
        floatingButton.accessibilityLabel = "Create"

        view.addSubview(floatingButton)



        let views = [
            "contained": containedButton,
            "text": textButton,
            "floating": floatingButton
        ]

        centerView(view: textButton, onView: self.view)

        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:[contained]-40-[text]-40-[floating]",
                                           options: .alignAllCenterX,
                                           metrics: nil,
                                           views: views))

    }

    // MARK: Private

    private func centerView(view: UIView, onView: UIView) {
        onView.addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: onView,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0.0))

        onView.addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: onView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: -20.0))
    }


    @objc func tap(_ sender: Any) {
        print("\(type(of: sender)) was tapped.")
    }

}

extension ButtonsSimpleExampleSwiftViewController {
    @objc class func catalogBreadcrumbs() -> [String] {
        return ["Buttons", "Buttons (Swift)"]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }
}
