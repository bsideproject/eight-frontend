//
//  NicknameChangeResponse.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/12/03.
//

import Foundation

struct NicknameChangeResponse: Decodable {
    let header: ApiResponse?
    let data: NicknameChange?
}

struct NicknameChange: Decodable {
    let email: String?
    let nickname: String?
    let profileImage: String?
}
