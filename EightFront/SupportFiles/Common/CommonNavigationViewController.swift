//
//  CommonNavigationViewController.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import UIKit

class CommonNavigationViewController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
