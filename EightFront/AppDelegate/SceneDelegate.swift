//
//  SceneDelegate.swift
//  EightFront
//
//  Created by wargi on 2022/09/15.
//

import UIKit

import KakaoSDKAuth
import JWTDecode
import Moya

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let authProvider = MoyaProvider<AuthAPI>()
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let tabbar = MainTabbarController()
        let navi = CommonNavigationViewController(rootViewController: tabbar)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // background에서 foregrond로 앱 진입 시 위치 추적 시작
        LocationManager.shared.startUpdating()
        
        // 알림 권한 요청
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.alertSetting {
            case .enabled:
                LogUtil.d("알림 권한 켜짐")
            default:
                DispatchQueue.main.async {
                    let message = "알림을 위해 알림 권한이 필요합니다.\n설정에서 알림 권한을 허용해 주세요."
                    let alert = UIAlertController(title: "알림 권한 필요", message: message, preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                        if let bundle = Bundle.main.bundleIdentifier,
                           let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
                            if UIApplication.shared.canOpenURL(settings) {
                                UIApplication.shared.open(settings)
                            }
                        }
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    
                    alert.addAction(cancelAction)
                    alert.addAction(confirmAction)
                    
                    UIApplication.shared.keyWindow?.visibleViewController?.present(alert, animated: true)
                }
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // 앱 꺼지면 위치 추적 멈춤
        LocationManager.shared.stopUpdating()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        // 앱 백 그라운드로 진입시 위치 추적 멈춤
        LocationManager.shared.stopUpdating()
    }
    
    /// 카카오톡에서 서비스 앱으로 돌아왔을 때 카카오 로그인 처리를 정상적으로 완료하기 위한 메서드
    /// https://developers.kakao.com/docs/latest/ko/kakaologin/ios
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
}

