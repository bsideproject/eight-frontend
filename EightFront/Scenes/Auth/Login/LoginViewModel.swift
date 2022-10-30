//
//  LoginViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/13.
//

import UIKit
import Combine

final class LoginViewModel {
    var bag = Set<AnyCancellable>()
    
    @Published var emailInput = ""
    @Published var passwordInput = ""
    
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
    
    lazy var isPasswordValid: AnyPublisher<Bool, Never> = $passwordInput
        .compactMap {
            let passwordRegEx =  "^[A-Za-z0-9].{7,15}"
            let isPasswordValid = NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: $0)
            return isPasswordValid
        }.eraseToAnyPublisher()
}
