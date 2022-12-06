//
//  ApiResponse.swift
//  EightFront
//
//  Created by wargi on 2022/10/02.
//

import Foundation

struct ApiResponse: Codable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "resultCode"
        case message = "resultMessage"
    }
}

struct ResponseResult: Decodable {
    let header: ApiResponse?
    let data: Data?
}
