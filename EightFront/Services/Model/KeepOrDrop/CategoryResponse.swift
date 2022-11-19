//
//  CategoryResponse.swift
//  EightFront
//
//  Created by wargi on 2022/11/05.
//

import Foundation

struct CategoryResponse: Decodable {
    let result: ApiResponse?
    let data: CategoriesModel?
}

struct CategoriesModel: Decodable {
    let categories: [String]?
    let totalCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case categories = "contents"
        case totalCount = "totalCount"
    }
}

