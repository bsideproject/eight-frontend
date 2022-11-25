//
//  PostsResponse.swift
//  EightFront
//
//  Created by wargi on 2022/11/09.
//

import Foundation

struct PostsResponse: Decodable {
    let result: ApiResponse?
    let data: PostsModel?
}

struct PostsModel: Decodable {
    let posts: [PostModel]?
    let totalCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case posts = "contents"
        case totalCount = "totalCount"
    }
}

struct PostModel: Decodable {
    let id: Int?
    let category: String?
    let title: String?
    let description: String?
    let images: [String]?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "articleId"
        case category = "category"
        case title = "title"
        case description = "description"
        case images = "images"
        case createdAt = "createdAt"
    }
}
