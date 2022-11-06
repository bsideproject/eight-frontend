//
//  EmailSignUpViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation

import Combine

final class EmailSignUpViewModel {
    var bag = Set<AnyCancellable>()
    
    @Published var emailInput: String = ""
    @Published var nicknameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var passwordConfirmInput: String = ""
    
    lazy var isEmailValid: AnyPublisher<Bool, Never> = $emailInput
        .compactMap {
            if $0.count > 0 {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailValid = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: $0)
                return emailValid
            } else {
                return false
            }
        }.eraseToAnyPublisher()
    
    // TODO: 정규식 조건 수정 필요
    lazy var isNicknameValid: AnyPublisher<Bool, Never> = $nicknameInput
        .compactMap {
            if $0.count > 0 {
                // 2~16 글자
                let nicknameRegEx = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{1,15}"
                let nicknameValid = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx).evaluate(with: $0)
                return nicknameValid
            } else {
                return false
            }
        }.eraseToAnyPublisher()
    
    lazy var isPasswordValid: AnyPublisher<Bool, Never> = $passwordInput
        .compactMap {
            let passwordRegEx =  "^[A-Za-z0-9!@+].{7,15}"
            let isPasswordValid = NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: $0)
            return isPasswordValid
        }.eraseToAnyPublisher()
    
    lazy var isPasswordConfirmValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($passwordInput, $passwordConfirmInput)
        .compactMap {
            return $0 == $1 ? true : false
        }
        .eraseToAnyPublisher()
    
    lazy var isSignupButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest3(isEmailValid, isPasswordValid, isPasswordConfirmValid)
        .compactMap { $0 && $1 && $2 ? true : false }
        .eraseToAnyPublisher()

}
