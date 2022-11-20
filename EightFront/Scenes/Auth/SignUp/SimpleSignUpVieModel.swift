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

    @Published var inputNickname = ""
    @Published var isSignUpButtonValid = false

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
