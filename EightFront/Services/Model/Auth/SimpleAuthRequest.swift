//
//  simpleSignUpRequest.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation

enum SocialCategory: String, Codable {
    case kakao = "kakao"
    case apple = "apple"
}

struct SocialSignInRequest: Codable {
    var accessToken: String?
    var identityToken: String?
    var type: String?
    var social: String?
}

struct SocialSignUpRequest: Codable {
    var accessToken: String?
    var identityToken: String?
    var nickName: String
}

