//
//  UIWindow.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/20.
//

import UIKit

extension UIWindow {
    
    /**
     rootVC
     */
    public var firstViewController: UIViewController? {
        return self.firstViewControllerFrom(viewController: self.rootViewController)
    }
    
    /**
     rootVC를 가져오는 메서드
     */
    public func firstViewControllerFrom(viewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationViewController = viewController as? UINavigationController {
            return self.firstViewControllerFrom(viewController: navigationViewController.visibleViewController)
        } else if let tabBarViewController = viewController as? UITabBarController {
            return self.firstViewControllerFrom(viewController: tabBarViewController.selectedViewController)
        } else {
            if let pvc = viewController?.presentedViewController {
                return self.firstViewControllerFrom(viewController: pvc)
            } else {
                return viewController
            }
        }
    }

}
