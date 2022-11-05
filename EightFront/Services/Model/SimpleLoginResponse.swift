//
//  SimpleLoginResponse.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/05.
//

import Foundation

struct SimpleLoginResponse: Decodable {
    let result: ApiResponse?
    let data: Info?
}

struct Info: Decodable {
    let nickName: String?
    let email: String?
    let accessToken: String?
    let refreshToken: String?
}

