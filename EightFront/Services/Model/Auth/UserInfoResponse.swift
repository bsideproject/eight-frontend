//
//  UserInfo.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation

struct UserInfoResponse: Decodable {
    let result: ApiResponse?
    let data: UserInfoResponseContent?
}

struct UserInfoResponseContent: Decodable {
    let content: UserInfo
}

struct UserInfo: Decodable {
    let email: String
    let nickname: String
    let profileImage: String?
}

