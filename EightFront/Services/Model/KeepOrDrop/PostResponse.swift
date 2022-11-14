//
//  PostResponse.swift
//  EightFront
//
//  Created by wargi on 2022/11/09.
//

import Foundation

struct PostResponse: Decodable {
    let result: ApiResponse?
    let data: PostInfoModel?
}

struct PostInfoModel: Decodable {
    let info: DetailPostModel?
    
    enum CodingKeys: String, CodingKey {
        case info = "content"
    }
}

struct DetailPostModel: Decodable {
    let id: Int?
    let category: String?
    let title: String?
    let description: String?
    let keepCount: Int?
    let dropCount: Int?
    let nickname: String?
    let commentCount: Int?
    let images: [String]?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "articleId"
        case category = "category"
        case title = "title"
        case description = "description"
        case keepCount = "keepCount"
        case dropCount = "dropCount"
        case nickname = "nickname"
        case commentCount = "commentCount"
        case images = "images"
        case createdAt = "createdAt"
    }
}
