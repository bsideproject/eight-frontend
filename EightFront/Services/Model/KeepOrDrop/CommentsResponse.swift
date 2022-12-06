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
    let id: Int?
    let nickname: String?
    let comment: String?
    let children: [Comment]?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "commentId"
        case nickname = "nickname"
        case comment = "comment"
        case children = "children"
        case createdAt = "createdAt"
    }
}

struct Comment: Decodable {
    var parentId: Int?
    let id: Int?
    let nickname: String?
    let comment: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "commentId"
        case nickname = "nickname"
        case comment = "comment"
        case createdAt = "createdAt"
    }
}
