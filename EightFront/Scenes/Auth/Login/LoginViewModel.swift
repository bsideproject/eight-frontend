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
    
    lazy var isLoginButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($emailInput, $passwordInput)
        .map { $0.isEmpty || $1.isEmpty ? false : true }
        .eraseToAnyPublisher()
    
}
