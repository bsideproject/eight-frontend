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

    @Published var inputNickname = "" {
        didSet {
            isNicknameCheck = false
            isSignUpButtonValid = false
            nicknameDuplicateText = ""
        }
    }
    @Published var nicknameDuplicateText = ""
    
    @Published var isNicknameCheck = false
    @Published var isSignUpButtonValid = false
    
    @Published var isSignUpSuccessed = false

    lazy var isNicknameValid: AnyPublisher<Bool, Never> = $inputNickname
        .compactMap {
            let nicknameRegEx = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{2,16}"
            let nicknameValid = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx).evaluate(with: $0)
            return nicknameValid
        }.eraseToAnyPublisher()
    
    func requestNickNameCheck() {
        if inputNickname.count > 1 {
            authProvider.requestPublisher(.nicknameCheck(nickname: inputNickname))
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        LogUtil.e(error)
                    }
                } receiveValue: { [weak self] response in
                    let data = try? response.map(NicknameCheckResponse.self)
                    if let content = data?.data?.content {
                        if content {
                            // 중복된 닉네임이 있을 때
                            self?.isNicknameCheck = false
                            self?.nicknameDuplicateText = "* 중복 된 닉네임입니다."
                        } else {
                            // 일치하는 닉네임이 없을 때
                            self?.isNicknameCheck = true
                            self?.nicknameDuplicateText = "* 사용 가능한 닉네임입니다."
                        }
                    }
                }.store(in: &bag)
        }
    }
    
    func requestSignUp() {
        if isNicknameCheck && isSignUpButtonValid {
            switch signType {
            case .kakao:
                LogUtil.d("카카오 회원가입")
                let accessToken = KeyChainManager.shared.accessToken
                authProvider.request(
                    .socialSignUp(
                        param: SocialSignUpRequest(
                            accessToken: accessToken,
                            nickName: inputNickname
                        ))) { [weak self] result in
                            switch result {
                            case .success(let response):
                                if let data = try? response.map(SimpleSignUpResponse.self).data {
                                    guard
                                        let accessToken = data.content?.accessToken
                                    else {
                                        return
                                    }
                                    if KeyChainManager.shared.create(accessToken, type: .accessToken) {
                                        UserDefaults.standard.set(SignType.kakao.rawValue, forKey: "signType")
                                        self?.isSignUpSuccessed = true
                                    }
                                }
                            case .failure(let error):
                                LogUtil.e(error)
                            }
                        }
                
            case .apple:
                let identityToken = KeyChainManager.shared.identityToken
                authProvider.request(
                    .appleSignUp(
                        param: SocialSignUpRequest(
                            identityToken: identityToken,
                            nickName: inputNickname
                        ))) { [weak self] result in
                            switch result {
                            case .success(let response):
                                
                                if let data = try? response.map(SimpleSignUpResponse.self).data {
                                    guard let accessToken = data.content?.accessToken else { return }
                                    if KeyChainManager.shared.create(accessToken, type: .accessToken) {
                                        UserDefaults.standard.set(SignType.apple.rawValue, forKey: "signType")
                                        self?.isSignUpSuccessed = true
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
}
