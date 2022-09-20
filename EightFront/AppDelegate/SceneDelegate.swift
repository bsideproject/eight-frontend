//
//  SceneDelegate.swift
//  EightFront
//
//  Created by wargi on 2022/09/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MainTabbarController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // 앱 시작시 위치 추적 시작
        LocationManager.shared.startUpdating()
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
        // 앱 켜지면 위치 추적 시작
        LocationManager.shared.stopUpdating()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        // 앱 백 그라운드로 진입시 위치 추적 멈춤
        LocationManager.shared.stopUpdating()
    }
}

