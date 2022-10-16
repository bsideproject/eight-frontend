//
//  EmailSignUpViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation

import Combine

class EmailSignUpViewModel {
    var cancelBag = Set<AnyCancellable>()
    
    @Published var emailInput: String = ""
    @Published var nicknameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var passwordConfirmInput: String = ""
    
    lazy var isSignupButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest4($emailInput, $nicknameInput, $passwordInput, $passwordConfirmInput)
        .compactMap { $0 == "" || $1 == "" || $2 == "" || $3 == "" ? false : true }
        .eraseToAnyPublisher()
}
