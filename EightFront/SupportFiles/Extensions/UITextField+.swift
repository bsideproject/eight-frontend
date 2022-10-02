//
//  UITextField+.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/02.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
