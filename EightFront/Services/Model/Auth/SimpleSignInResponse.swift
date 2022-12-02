//
//  SimpleLoginResponse.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/05.
//

import Foundation

struct SimpleSignInResponse: Decodable {
    let result: ApiResponse?
    let data: DataClass?
}

struct DataClass: Decodable {
    let content: Content?
}

struct Content: Decodable {
    let memberId: String?
    let nickName: String?
    let email: String?
    let accessToken: String?
    let refreshToken: String?
    let type: String?
    let identityToken: String?
}
