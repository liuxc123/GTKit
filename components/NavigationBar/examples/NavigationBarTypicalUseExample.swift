//
//  NavigationBarTypicalUseExample.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

import UIKit
import GTKitComponents.GTNavigationBar_ColorThemer
import GTKitComponents.GTPalettes

open class NavigationBarTypicalUseSwiftExample: UIViewController {

    var navBar = GTCNavigationBar()
    var colorScheme = GTCSemanticColorScheme()
    var exampleView = ExampleInstructionsViewNavigationBarTypicalUseSwift()

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorScheme.backgroundColor

        title = "Navigation Bar (Swift)!!!"

        navBar = GTCNavigationBar()
        navBar.observe(navigationItem)

        let mutator = GTCNavigationBarTextColorAccessibilityMutator()
        mutator.mutate(navBar)

        GTCNavigationBarColorThemer.applySemanticColorScheme(colorScheme, to: navBar)

        view.addSubview(navBar)
//
//        navBar.translatesAutoresizingMaskIntoConstraints = false
//
//        #if swift(>=3.2)
//        if #available(iOS 11.0, *) {
//            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.navBar.topAnchor).isActive = true
//        } else {
//            NSLayoutConstraint(item: self.topLayoutGuide,
//                               attribute: .bottom,
//                               relatedBy: .equal,
//                               toItem: self.navBar,
//                               attribute: .top,
//                               multiplier: 1,
//                               constant: 0).isActive = true
//        }
//        #else
//        NSLayoutConstraint(item: self.topLayoutGuide,
//        attribute: .bottom,
//        relatedBy: .equal,
//        toItem: self.navBar,
//        attribute: .top,
//        multiplier: 1,
//        constant: 0).isActive = true
//        #endif
//
//        let viewBindings = ["navBar": navBar]
//
//        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[navBar]|",
//                                                                   options: [],
//                                                                   metrics: nil,
//                                                                   views: viewBindings))
//        self.setupExampleViews()
//    }
//
//    func setupExampleViews() {
//        /// Both self.viewDidLoad() and super.viewDidLoad() will add NavigationBars to the hierarchy.
//        /// We only want to keep one.
//
//        for subview in view.subviews {
//            if let navBarSubview = subview as? GTCNavigationBar, navBarSubview != self.navBar {
//                navBarSubview.removeFromSuperview()
//            }
//        }
//
//        exampleView.frame = self.view.bounds
//        self.view.insertSubview(exampleView, belowSubview: navBar)
//        exampleView.translatesAutoresizingMaskIntoConstraints = false
//        let viewBindings: [String : Any] = [ "exampleView" : exampleView, "navBar" : navBar ]
//        var constraintsArray: [NSLayoutConstraint] = []
//        constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "H:|[exampleView]|",
//                                                           options: [],
//                                                           metrics: nil,
//                                                           views: viewBindings)
//        constraintsArray += NSLayoutConstraint.constraints(withVisualFormat: "V:[navBar]-[exampleView]|",
//                                                           options: [],
//                                                           metrics: nil,
//                                                           views: viewBindings)
//        view.addConstraints(constraintsArray)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override open var prefersStatusBarHidden: Bool {
        return true
    }

//    open override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        exampleView.setNeedsDisplay()
//    }

}

class ExampleInstructionsViewNavigationBarTypicalUseSwift: UIView {
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIBezierPath(rect: rect).fill()
        let textSizeRect = textSize(forRect: rect)
        let rectForText = CGRect(x: rect.origin.x + rect.size.width / 2 - textSizeRect.width / 2,
                                 y: rect.origin.y + rect.size.height / 2 - textSizeRect.height / 2,
                                 width: textSizeRect.width,
                                 height: textSizeRect.height)
        instructionsString().draw(in: rectForText)
        drawArrow(withFrame: CGRect(x: rect.size.width / 2 - 12,
                                    y: rect.size.height / 2 - 58 - 12,
                                    width: 24,
                                    height: 24))
    }

    func textSize(forRect rect: CGRect) -> CGSize {
        return instructionsString()
            .boundingRect(with: rect.size,
                          options: NSStringDrawingOptions.usesLineFragmentOrigin,
                          context: nil).size
    }

    func instructionsString() -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        let instructionsDictionary1 = [
            NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .headline),
            NSAttributedStringKey.foregroundColor : GTCPalette.grey.tint600.withAlphaComponent(0.87),
            NSAttributedStringKey.paragraphStyle : style
        ]
        let instructionsDictionary2 = [
            NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .subheadline),
            NSAttributedStringKey.foregroundColor : GTCPalette.grey.tint600.withAlphaComponent(0.87),
            NSAttributedStringKey.paragraphStyle : style
        ]
        let instructionText = "SWIPE RIGHT\n\n\nfrom left edge to go back\n\n\n\n\n"
        let instructionsAttributedString = NSMutableAttributedString(string: instructionText)
        instructionsAttributedString.addAttributes(instructionsDictionary1,
                                                   range: NSMakeRange(0, 11))
        let endLength = instructionText.count - 11
        instructionsAttributedString.addAttributes(instructionsDictionary2,
                                                   range: NSMakeRange(11, endLength))
        return instructionsAttributedString
    }

    func drawArrow(withFrame frame: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.origin.x + 12, y: frame.origin.y + 4))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 10.59, y: frame.origin.y + 5.41))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 16.17, y: frame.origin.y + 11))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 4, y: frame.origin.y + 11))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 4, y: frame.origin.y + 13))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 16.17, y: frame.origin.y + 13))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 10.59, y: frame.origin.y + 18.59))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 12, y: frame.origin.y + 20))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 20, y: frame.origin.y + 12))
        bezierPath.addLine(to: CGPoint(x: frame.origin.x + 12, y: frame.origin.y + 4))
        bezierPath.close()
        bezierPath.miterLimit = 4
        GTCPalette.grey.tint600.withAlphaComponent(0.87).setFill()
        bezierPath.fill()
    }
}
