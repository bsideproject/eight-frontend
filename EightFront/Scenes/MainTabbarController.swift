//
//  MainTabbarController.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import UIKit

class MainTabbarController: UITabBarController {
    //MARK: - Initializer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }

    func makeUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemPurple
        tabBar.unselectedItemTintColor = .gray
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem.title = "홈"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let tradeVC = TradeViewController()
        tradeVC.tabBarItem.title = "중고거래"
        tradeVC.tabBarItem.image = UIImage(systemName: "person.3")
        tradeVC.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
        
        let noticeVC = NoticeViewController()
        noticeVC.tabBarItem.title = "알림"
        noticeVC.tabBarItem.image = UIImage(systemName: "bell")
        noticeVC.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
        
        let myPageVC = MyPageViewController()
        myPageVC.tabBarItem.title = "마이페이지"
        myPageVC.tabBarItem.image = UIImage(systemName: "person")
        myPageVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

        viewControllers = [homeVC, tradeVC, noticeVC, myPageVC]
    }
}
