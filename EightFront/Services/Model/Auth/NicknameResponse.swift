//
//  NicknameResponse.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/20.
//

import Foundation

struct NicknameResponse: Decodable {
    let result: ApiResponse?
    let data: Nickname?
}

struct Nickname: Decodable {
    let content: Bool?
}
