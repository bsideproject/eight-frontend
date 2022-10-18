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
    @Published var nicknameInput: String = "" {
        didSet {
            print("닉네임 수정: \(nicknameInput)")
        }
    }
    @Published var passwordInput: String = ""
    @Published var passwordConfirmInput: String = ""
    
    lazy var isPasswordValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($passwordInput, $passwordConfirmInput)
        .compactMap { $0 == $1 ? true : false }
        .eraseToAnyPublisher()
    
    lazy var isSignupButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest4($emailInput, $nicknameInput, $passwordInput, $passwordConfirmInput)
        .compactMap { $0 == "" || $1 == "" || $2 == "" || $3 == "" ? false : true }
        .eraseToAnyPublisher()
}
