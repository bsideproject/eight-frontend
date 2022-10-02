//
//  CoordinatesResponse.swift
//  EightFront
//
//  Created by wargi on 2022/10/01.
//

import Foundation

struct CoordinatesResponse: Decodable {
    let result: ApiResponse?
    let data: Coordinates?
}

struct Coordinates: Decodable {
    let coordinates: [Coordinate]?
    let totalCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "contents"
        case totalCount = "totalCount"
    }
}

struct Coordinate: Decodable {
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "positionX"
        case longitude = "positionY"
    }
}
