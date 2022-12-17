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
    
    enum SignInUp: String {
        case signIn = "sign-in"
        case signUp = "sign-up"
    }
    
    private let authProvider = MoyaProvider<AuthAPI>()
    var bag = Set<AnyCancellable>()
    
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    @Published var deviceID: String = ""
    
    @Published var identityToken: String = ""
    
    @Published var signInUp: SignInUp?
    @Published var content: Content?
    
    lazy var isLoginButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($emailInput, $passwordInput)
        .map { $0 == "" || $1 == "" ? false : true }
        .eraseToAnyPublisher()
    
    func kakaoLogin() {
        UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
            self?.authProvider.request(.socialSignIn(
                param: SocialSignInRequest(
                    accessToken: oauthToken?.accessToken ?? "",
                    social: "kakao"
                ))) { reponse in
                    switch reponse {
                    case .success(let result):
                        guard
                            let data = try? result.map(SimpleSignInResponse.self).data,
                            let content = data.content,
                            let type = content.type
                        else {
                            LogUtil.e("데이터 파싱 실패")
                            return
                        }
                        
                        guard let accessToken = content.accessToken else {
                            LogUtil.e("엑세스 토큰 없음")
                            return
                        }
                        
                        if type == "sign-in" {
                            // 로그인
                            if KeyChainManager.shared.create(accessToken, type: .accessToken) {
                                UserDefaults.standard.set(SignType.kakao.rawValue, forKey: "signType")
                                self?.signInUp = SignInUp(rawValue: type)
                            } else {
                                LogUtil.e("액세스 토큰을 키체인에 저장하지 못했습니다.")
                            }
                        } else if type == "sign-up" {
                            // 회원가입
                            KeyChainManager.shared.accessToken = accessToken
                            UserDefaults.standard.set(SignType.kakao.rawValue, forKey: "signType")
                            self?.signInUp = SignInUp(rawValue: type)
                        }
                    case .failure(let error):
                        LogUtil.e("간편 로그인 실패 > \(error.localizedDescription)")
                    }
                }
        }
    }
    
    func appleSignIn(identityToken: String, authorizationCode: String) {
        
        LogUtil.d(identityToken)
        LogUtil.d(authorizationCode)
        
        authProvider.requestPublisher(.appleSignIn(
            param: SocialSignInRequest(
                identityToken: identityToken
            )
        ))
        .sink { completion in
            switch completion {
            case .finished:
                LogUtil.d("애플 로그인 API 호출 완료")
            case .failure(let moyaError):
                LogUtil.e(moyaError)
            }
        } receiveValue: { [weak self] response in
            guard
                let data = try? response.map(SimpleSignInResponse.self).data,
                let content = data.content,
                let type = content.type
            else {
                assertionFailure("parsing 실패")
                return
            }
            
            if type == "sign-in" {
                // 로그인
                guard let accessToken = content.accessToken else {
                    assertionFailure("accessToken 없음")
                    return
                }
                _ = KeyChainManager.shared.create(accessToken, type: .accessToken)
                if KeyChainManager.shared.create(authorizationCode, type: .authorizationCode) {
                    UserDefaults.standard.set(SignType.apple.rawValue, forKey: "signType")
                    self?.signInUp = SignInUp(rawValue: type)
                } else {
                    LogUtil.e("액세스 토큰을 키체인에 저장하지 못했습니다.")
                }
            } else if type == "sign-up" {

                KeyChainManager.shared.identityToken = identityToken
                UserDefaults.standard.set(SignType.apple.rawValue, forKey: "signType")
                self?.signInUp = SignInUp(rawValue: type)
            }
            
            
//            if let signType = responseContent.type {
//                switch SignInUp(rawValue: signType) {
//                case .signIn:
//                    if KeyChainManager.shared.create(authorizationCode, type: .authorizationCode) {
//                        UserDefaults.standard.set(SignType.apple.rawValue, forKey: "signType")
//                        self?.signInUp = SignInUp.signIn
//                    }
//                case .signUp:
//                    if KeyChainManager.shared.create(authorizationCode, type: .authorizationCode) {
//                        UserDefaults.standard.set(SignType.apple.rawValue, forKey: "signType")
//                        self?.signInUp = SignInUp.signUp
//                    }
//                default:
//                    break
//                }
//            }
        }.store(in: &bag)
    }
    
}
