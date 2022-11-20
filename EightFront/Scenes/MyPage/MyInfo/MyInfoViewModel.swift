//
//  MyInfoViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation
import Combine
import KakaoSDKUser
import JWTDecode

class MyInfoViewModel {
    
    var bag = Set<AnyCancellable>()
    
    @Published var userEmail = UserDefaults.standard.object(forKey: "email") as? String ?? ""
    @Published var nickName = UserDefaults.standard.object(forKey: "nickName") as? String ?? ""
    
    @Published var inputNickname = ""
    @Published var isButtonEnabled = false
    
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
}
