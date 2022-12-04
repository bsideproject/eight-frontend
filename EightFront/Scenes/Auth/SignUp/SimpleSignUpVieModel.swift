//
//  SimpleSignUpVieModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/20.
//

import Foundation
import Combine
import Moya

class SimpleSignUpVieModel {
    
    var bag = Set<AnyCancellable>()
    var authProvider = MoyaProvider<AuthAPI>()
    
    @Published var signType: SignType?

    @Published var inputNickname = ""
    @Published var isSignUpButtonValid = false
    
    @Published var isNicknameCheck = false
    @Published var isSignUp = false

    lazy var isNicknameValid: AnyPublisher<Bool, Never> = $inputNickname
        .compactMap {
            if $0.count > 1 {
                // 2~16 글자
                let nicknameRegEx = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{1,15}"
                let nicknameValid = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx).evaluate(with: $0)
                return nicknameValid
            } else {
                return false
            }
        }.eraseToAnyPublisher()
    
    func requestNickNameCheck() {
        authProvider.requestPublisher(.nicknameCheck(nickname: inputNickname))
            .sink { completion in
                switch completion {
                case .finished:
                    LogUtil.d("닉네임 변경 API 호출 완료")
                case .failure(let error):
                    LogUtil.e(error)
                }
            } receiveValue: { [weak self] response in
                let data = try? response.map(NicknameCheckResponse.self)
                if let content = data?.data?.content {
                    if content {
                        // 중복된 닉네임이 있을 때
                        self?.isNicknameCheck = false
                    } else {
                        // 일치하는 닉네임이 없을 때
                        self?.isNicknameCheck = true
                    }
                }
            }.store(in: &bag)
    }
    
    func requestSignUp() {
        let accessToken = KeyChainManager.shared.accessToken
        switch signType {
        case .kakao:
            LogUtil.d("카카오 회원가입")
            authProvider.request(
                .socialSignUp(
                    param: SocialSignUpRequest(
                        accessToken: accessToken,
                        nickName: inputNickname
                    ))) { [weak self] result in
                        switch result {
                        case .success(let response):
                            LogUtil.d("회원가입 API 호출 성공")
                            if let data = try? response.map(SimpleSignUpResponse.self).data {
                                guard let accessToken = data.content?.accessToken else { return }
                                if KeyChainManager.shared.createAccessToken(accessToken) {
                                    UserDefaults.standard.set(SignType.kakao.rawValue, forKey: "signType")
                                    self?.isSignUp = true
                                }
                            }
                        case .failure(let error):
                            LogUtil.e(error)
                        }
                    }
        case .apple:
            authProvider.request(
                .appleSignUp(
                    param: SocialSignUpRequest(
                        identityToken: accessToken,
                        nickName: inputNickname
                    ))) { [weak self] result in
                        switch result {
                        case .success(let response):
                            LogUtil.d("회원가입 API 호출 성공")
                            if let data = try? response.map(SimpleSignUpResponse.self).data {
                                guard let accessToken = data.content?.accessToken else { return }
                                if KeyChainManager.shared.createAccessToken(accessToken) {
                                    UserDefaults.standard.set(SignType.apple.rawValue, forKey: "signType")
                                    self?.isSignUp = true
                                }
                            }
                        case .failure(let error):
                            LogUtil.e(error)
                        }
                    }
        default:
            LogUtil.e("오류")
        }
        
        
        
    }
}
