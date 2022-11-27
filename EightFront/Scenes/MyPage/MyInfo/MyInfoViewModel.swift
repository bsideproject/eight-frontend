//
//  MyInfoViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation
import Combine

import Moya
import KakaoSDKUser

import JWTDecode

class MyInfoViewModel {
    
    private let authProvider = MoyaProvider<AuthAPI>()
    var bag = Set<AnyCancellable>()
    
    @Published var userEmail = ""
    
    @Published var inputNickname = ""
    @Published var isButtonEnabled = false
    @Published var isNicknameCheck = false
    @Published var isNickNameChanged = false
    
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
    
    func reqeustUserInfo() {
        authProvider.requestPublisher(.userInfo)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    LogUtil.d("유저 정보 가져오기 API 호출 완료")
                case .failure(let error):
                    LogUtil.e(error)
                }
            } receiveValue: { [weak self] response in
                let data = try? response.map(UserInfoResponse.self)
                self?.userEmail = data?.data?.content.email ?? "김에잇"
            }.store(in: &bag)
    }
    
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
                let data = try? response.map(NicknameResponse.self)
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
    
    func requestNicknameChange() {
        let accessToken = KeyChainManager.shared.readAccessToken()
        let jwt = try? JWTDecode.decode(jwt: accessToken)
        guard let memberId = jwt?.subject else { return }
        
        authProvider.requestPublisher(.nicknameChange(memberId: memberId, nickName: inputNickname))
            .sink { completion in
                switch completion {
                case .finished:
                    LogUtil.d("닉네임 변경 API 호출 완료")
                case .failure(let error):
                    LogUtil.e(error)
                }
            } receiveValue: { [weak self] response in
                if let data = try? response.map(NicknameResponse.self).data {
                    if data.content == true {
                        self?.isNickNameChanged = true
                    }
                }
            }.store(in: &bag)
    }
}
