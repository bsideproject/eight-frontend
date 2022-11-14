//
//  CommentsResponse.swift
//  EightFront
//
//  Created by wargi on 2022/11/09.
//

import Foundation

struct CommentsResponse: Decodable {
    let result: ApiResponse?
    let data: CommentsModel?
}

struct CommentsModel: Decodable {
    let comments: [CommentModel]?
    let totalCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case comments = "contents"
        case totalCount = "totalCount"
    }
}

struct CommentModel: Decodable {
    let nickname: String?
    let comment: String?
    let children: [ReCommentModel]?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nickname"
        case comment = "comment"
        case children = "children"
        case createdAt = "createdAt"
    }
}

struct ReCommentModel: Decodable {
    let nickname: String?
    let comment: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nickname"
        case comment = "comment"
        case createdAt = "createdAt"
    }
}
