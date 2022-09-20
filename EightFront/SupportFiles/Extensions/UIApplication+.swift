//
//  UIApplication+.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/20.
//

import UIKit

extension UIApplication {
    /// deprecated된 keyWindow를 정의
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
}
