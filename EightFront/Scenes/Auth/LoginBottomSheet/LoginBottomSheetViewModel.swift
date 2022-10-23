//
//  LoginBottomSheetViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/01.
//

import UIKit
import Combine

import AuthenticationServices
import CombineCocoa
import Moya
import KakaoSDKUser

class LoginBottomSheetViewModel {
    
    var bag = Set<AnyCancellable>()
    
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    @Published var deviceID: String = ""
    
    lazy var isLoginButtonValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($emailInput, $passwordInput)
        .map { $0 == "" || $1 == "" ? false : true }
        .eraseToAnyPublisher()
    
}
