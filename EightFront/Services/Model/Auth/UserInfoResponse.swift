//
//  UserInfo.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation

struct UserInfoResponse: Decodable {
    let result: ApiResponse?
    let data: UserInfo?
}

struct UserInfo: Decodable {
    let accessToken: String?
    let nickName: String?
    let email: String?
    let type: String?
}

