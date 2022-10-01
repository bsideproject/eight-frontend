//
//  LoginBottomSheetViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/01.
//

import UIKit
import Combine

class LoginBottomSheetViewModel {
    
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    
    lazy var isLoginButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($emailInput, $passwordInput)
        .map({ (email, password) in
            if email == "" || password == "" {
                return false
            } else {
                return true
            }
        })
        .eraseToAnyPublisher()
}
