//
//  BlockListResponse.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/26.
//

import Foundation

struct BlockListResponse: Decodable {
    let result: ApiResponse?
    let data: BlockUsers?
}

struct BlockUsers: Decodable {
    let users: [BlockUser]?
    enum CodingKeys: String, CodingKey {
        case users = "contents"
    }
}

struct BlockUser: Decodable {
    let memeberId: String
    let nickName: String
    let createdAt: String
}
