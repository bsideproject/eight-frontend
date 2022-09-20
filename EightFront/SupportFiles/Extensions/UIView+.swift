//
//  UIView+.swift
//  EightFront
//
//  Created by wargi on 2022/09/20.
//

import UIKit

extension UIView {
    enum VerticalLocation {
        case bottom
        case top
        case left
        case right
    }

    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.8, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 1), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -1), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -1, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 1, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func addShadow(views: [UIView], offset: CGSize = CGSize(width: 4, height: 4), color: UIColor = .black, opacity: Float = 0.4, radius: CGFloat = 5.0) {
        views.forEach { $0.addShadow(offset: offset, color: color, opacity: opacity, radius: radius) }
    }
    
    func asImage() -> UIImage {
        let render = UIGraphicsImageRenderer(bounds: bounds)
        return render.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
