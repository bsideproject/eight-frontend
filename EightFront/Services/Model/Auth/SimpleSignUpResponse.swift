//
//  SimpleSignUpResponse.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import Foundation

struct SimpleSignUpResponse: Decodable {
    let result: ApiResponse?
    let data: SignUpData?
}

struct SignUpData: Decodable {
    let content: SignUpContent?
}

struct SignUpContent: Decodable {
    let nickName: String?
    let email: String?
    let accessToken: String?
    let identityToken: String?
    let refreshToken: String?
    let type: String?
}
