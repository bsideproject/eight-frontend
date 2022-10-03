//
//  HomeNavigationController.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import UIKit

class HomeNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
