//
//  VoteRequest.swift
//  EightFront
//
//  Created by wargi on 2022/11/09.
//

import Foundation

struct CategoryResponse: Decodable {
    let result: ApiResponse?
    let data: Categories?
}

struct Categories: Decodable {
    let categories: [String]?
    let totalCount: Int?
}
