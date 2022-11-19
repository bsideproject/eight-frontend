//
//  NicknameCheck.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/20.
//

import Foundation

struct NicknameCheckResponse: Decodable {
    let result: ApiResponse?
    let data: NicknameCheck?
}

struct NicknameCheck: Decodable {
    let content: Bool?
}
