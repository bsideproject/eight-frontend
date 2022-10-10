//
//  UILayer+.swift
//  EightFront
//
//  Created by wargi on 2022/10/09.
//

import UIKit
import QuartzCore

extension CALayer {
    func applyFigmaShadow(x: CGFloat, y: CGFloat, color: UIColor, alpha: Float = 1.0, blur: CGFloat, spread: CGFloat) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
