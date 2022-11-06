//
//  simpleSignUpRequest.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation

struct SimpleSignInRequest: Codable {
    var accessToken: String
    var type: String?
}

struct SimpleSignUpRequest: Codable {
    var accessToken: String
    var nickName: String
}
