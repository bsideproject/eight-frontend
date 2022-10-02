//
//  ApiResponse.swift
//  EightFront
//
//  Created by wargi on 2022/10/02.
//

import Foundation

struct ApiResponse: Decodable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "resultCode"
        case message = "resultMessage"
    }
}
