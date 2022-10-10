//
//  UIButton+.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/01.
//

import UIKit

extension UIButton {
    func setImage(_ image: UIImage?) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
    }
    
    func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
    }
    
    func setTitleColor(_ color: UIColor?) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
    }
}
