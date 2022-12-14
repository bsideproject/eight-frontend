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
    @Published var signType: SignInUp?
    @Published var content: Content?
    
    lazy var isLoginButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($emailInput, $passwordInput)
        .map { $0 == "" || $1 == "" ? false : true }
        .eraseToAnyPublisher()
    
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
            let data = try? response.map(SimpleSignInResponse.self)
            guard let responseContent = data?.data?.content else { return }
            self?.content = responseContent
            _ = KeyChainManager.shared.delete(type: .authorizationCode)
            
            if let signType = responseContent.type {
                switch SignInUp(rawValue: signType) {
                case .signIn:
                    if KeyChainManager.shared.create(authorizationCode, type: .authorizationCode) {
                        UserDefaults.standard.set(SignType.apple.rawValue, forKey: "signType")
                        self?.signType = SignInUp.signIn
                    }
                case .signUp:
                    if KeyChainManager.shared.create(authorizationCode, type: .authorizationCode) {
                        UserDefaults.standard.set(SignType.apple.rawValue, forKey: "signType")
                        self?.signType = SignInUp.signUp
                    }
                default:
                    break
                }
            }
        }.store(in: &bag)
    }
    
}
