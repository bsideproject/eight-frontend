//
//  UIApplication+.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/20.
//

import UIKit

extension UIApplication {
    
    
    /**
     deprecated된 keyWindow를 정의
     */
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
             // Keep only active scenes, onscreen and visible to the user
             .filter { $0.activationState == .foregroundActive }
             // Keep only the first `UIWindowScene`
             .first(where: { $0 is UIWindowScene })
             // Get its associated windows
             .flatMap({ $0 as? UIWindowScene })?.windows
             // Finally, keep only the key window
             .first(where: \.isKeyWindow)
    }
}
