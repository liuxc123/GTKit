//
//  ButtonsTypicalUseSupplemental.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

import UIKit

import GTKitComponents.GTButtons

class ButtonsTypicalUseSupplemental: NSObject {

    static let floatingButtonPlusDimension = CGFloat(24)

    static func plusShapePath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 19, y: 13))
        bezierPath.addLine(to: CGPoint(x: 13, y: 13))
        bezierPath.addLine(to: CGPoint(x: 13, y: 19))
        bezierPath.addLine(to: CGPoint(x: 11, y: 19))
        bezierPath.addLine(to: CGPoint(x: 11, y: 13))
        bezierPath.addLine(to: CGPoint(x: 5, y: 13))
        bezierPath.addLine(to: CGPoint(x: 5, y: 11))
        bezierPath.addLine(to: CGPoint(x: 11, y: 11))
        bezierPath.addLine(to: CGPoint(x: 11, y: 5))
        bezierPath.addLine(to: CGPoint(x: 13, y: 5))
        bezierPath.addLine(to: CGPoint(x: 13, y: 11))
        bezierPath.addLine(to: CGPoint(x: 19, y: 11))
        bezierPath.addLine(to: CGPoint(x: 19, y: 13))
        bezierPath.close()
        return bezierPath
    }

    static func createPlusShapeLayer(_ floatingButton: GTCFloatingButton) -> CAShapeLayer {
        let plusShape = CAShapeLayer()
        plusShape.path = ButtonsTypicalUseSupplemental.plusShapePath().cgPath
        plusShape.fillColor = UIColor.white.cgColor
        plusShape.position =
            CGPoint(x: (floatingButton.frame.size.width - floatingButtonPlusDimension) / 2,
                    y: (floatingButton.frame.size.height - floatingButtonPlusDimension) / 2)
        return plusShape
    }

}
