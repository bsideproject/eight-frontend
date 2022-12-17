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
    @Published var inputNickname = "" {
        didSet {
            isNicknameCheck = false
            isSignUpButtonValid = false
            nicknameDuplicateText = ""
        }
    }
    @Published var nicknameDuplicateText = ""
    @Published var profileImage = ""
    
    @Published var isNicknameCheck = false
    @Published var isSignUpButtonValid = false
    
    @Published var isNickNameChanged = false
    
    
    lazy var isNicknameValid: AnyPublisher<Bool, Never> = $inputNickname
        .compactMap {
                // 2~16 글자
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
                        LogUtil.d("닉네임 중복확인 API 호출 완료")
                    case .failure(let error):
                        LogUtil.e(error)
                    }
                } receiveValue: { [weak self] response in
                    let data = try? response.map(NicknameCheckResponse.self)
                    if let content = data?.data?.content {
                        if content {
                            // 중복된 닉네임이 있을 때
                            self?.isNicknameCheck = false
                            self?.nicknameDuplicateText = "* 닉네임이 중복되었어요"
                        } else {
                            // 일치하는 닉네임이 없을 때
                            self?.isNicknameCheck = true
                            self?.nicknameDuplicateText = "* 사용 가능한 닉네임 입니다"
                        }
                    }
                }.store(in: &bag)
        }
    }
    
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
                guard
                    let data = try? response.map(UserInfoResponse.self),
                    let profileImage = data.data?.content.profileImage
                else {
                    return
                }
                self?.profileImage = profileImage
                
                guard
                    let data = try? response.map(UserInfoResponse.self),
                    let userEmail = data.data?.content.email
                else {
                    self?.userEmail = "이메일 비공개"
                    return
                }
                self?.userEmail = userEmail
            }.store(in: &bag)
    }
    

    // 닉네임 변경 API 호출
    func requestNicknameChange() {
        if isNicknameCheck && isSignUpButtonValid {
            authProvider.requestPublisher(.nicknameChange(nickname: inputNickname))
                .sink { completion in
                    switch completion {
                    case .finished:
                        LogUtil.d("닉네임 변경 API 호출 완료")
                    case .failure(let error):
                        LogUtil.e(error)
                    }
                } receiveValue: { [weak self] response in
                    if let response = try? response.map(NicknameChangeResponse.self) {
                        if let resultCode = response.header?.code {
                            if resultCode == 0 {
                                self?.isNickNameChanged = true
                            } else {
                                LogUtil.e("닉네임 변경 실패")
                            }
                        }
                    }
                }.store(in: &bag)
        }
    }
}
