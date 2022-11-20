//
//  UIColor+.swift
//  EightFront
//
//  Created by wargi on 2022/11/13.
//

import UIKit

extension UIColor {
    convenience init(colorSet: CGFloat) {
        self.init(red: colorSet/255, green: colorSet/255, blue: colorSet/255, alpha: 1.0)
    }
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}
