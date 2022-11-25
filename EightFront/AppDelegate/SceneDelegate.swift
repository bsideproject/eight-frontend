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
        
        // 앱  로그인 한 유저인지 확인
        let accessToken = KeyChainManager.shared.readAccessToken()
        if accessToken != "" {
            let jwt = try? JWTDecode.decode(jwt: accessToken)
            if let memeberId = jwt?.body["sub"] as? String {
                authProvider.request(.userInfo(memberId: memeberId)) { result in
                    switch result {
                    case .success(let response):
                        let data = try? JSONDecoder().decode(UserInfo.self, from: response.data)
                        UserInfoManager.shared.userInfo = UserInfo(accessToken: data?.accessToken,
                                                                   nickName: data?.nickName,
                                                                   email: data?.email,
                                                                   type: data?.type)
                    case .failure(let moyaError):
                        LogUtil.e(moyaError)
                    }
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

