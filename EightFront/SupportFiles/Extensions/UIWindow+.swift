//
//  UIWindow.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/20.
//

import UIKit

extension UIWindow {
    // rootVC
    var visibleViewController: UIViewController? {
        return self.visibleViewControllerFrom()
    }
    
    // rootVC를 가져오는 메서드
    private func visibleViewControllerFrom(viewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationViewController = viewController as? UINavigationController {
            return self.visibleViewControllerFrom(viewController: navigationViewController.visibleViewController)
        } else if let tabBarViewController = viewController as? UITabBarController {
            return self.visibleViewControllerFrom(viewController: tabBarViewController.selectedViewController)
        } else {
            if let pvc = viewController?.presentedViewController {
                return self.visibleViewControllerFrom(viewController: pvc)
            } else {
                return viewController
            }
        }
    }
}
