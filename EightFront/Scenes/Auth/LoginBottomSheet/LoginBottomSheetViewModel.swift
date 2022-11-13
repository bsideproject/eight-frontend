//
//  LoginBottomSheetViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/01.
//

import UIKit
import Combine

import CombineCocoa
import Moya

import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth

class LoginBottomSheetViewModel {
    
    private let authProvider = MoyaProvider<AuthAPI>()
    var bag = Set<AnyCancellable>()
    
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    @Published var deviceID: String = ""
    
    lazy var isLoginButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($emailInput, $passwordInput)
        .map { $0 == "" || $1 == "" ? false : true }
        .eraseToAnyPublisher()
    
    func kakaoSocialLogin(oauthToken: OAuthToken?, error: Error?, completion: @escaping(_ content: Content) -> Void) {
        if let error = error {
            LogUtil.e("카카오 간편 로그인 실패 : \(error.localizedDescription)")
        }
        
        self.authProvider.request(.socialSignIn(
            param: SocialSignInRequest(
                accessToken: oauthToken?.accessToken ?? "",
                type: "",
                category: .kakao
            ))) { response in
                switch response {
                case .success(let result):
                    guard let data = try? result.map(SimpleSignInResponse.self).data else {
                        LogUtil.e("Response Decoding 실패")
                        return
                    }
                    
                    guard let content = data.content else {
                        LogUtil.e("data.content unWrapping 실패")
                        return
                    }
                    
                    if content.type == "sign-in" {
                        guard let accessToken = content.accessToken else { return }
                        if KeyChainManager.shared.createAccessToken(accessToken) {
                            UserDefaults.standard.set([
                                "email": content.email,
                                "nickName": content.nickName
                            ], forKey: "userInfo")
                        } else {
                            LogUtil.e("액세스 토큰을 키체인에 저장하지 못했습니다.")
                        }
                        print("로그인")
                    } else {
                        print("회원가입")
                    }
                    
//                    if type == "sign-in" {
//                        // 로그인
//                        self.dismiss(animated: false) {
//                            guard let accessToken = content.accessToken else { return }
//                            if KeyChainManager.shared.createAccessToken(accessToken) {
//                                UserDefaults.standard.set([
//                                    "email": content.email,
//                                    "nickName": content.nickName
//                                ], forKey: "userInfo")
//                            } else {
//                                LogUtil.e("액세스 토큰을 키체인에 저장하지 못했습니다.")
//                            }
//                        }
//                    } else if type == "sign-up" {
//                        // 회원가입
//                        self.dismiss(animated: false) {
//                            let termsVC = TermsVC()
//                            termsVC.type = signType.kakao.type
//                            UIWindow().visibleViewController?.navigationController?.pushViewController(termsVC, animated: true)
//                        }
//                    }
                    
                    completion(content)
                    
                case .failure(let error):
                    LogUtil.e("간편 로그인 실패 > \(error.localizedDescription)")
                }
            }
    }
    
}
