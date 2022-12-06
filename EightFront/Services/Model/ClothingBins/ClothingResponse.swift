//
//  ClothingResponse.swift
//  EightFront
//
//  Created by wargi on 2022/10/01.
//

import Foundation

struct ClothingResponse: Decodable {
    let result: ApiResponse?
    let data: CollectionBoxes?
}

struct CollectionBoxes: Decodable {
    let boxes: [CollectionBox]?
    let totalCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case boxes = "contents"
        case totalCount = "totalCount"
    }
}

struct CollectionBox: Decodable {
    let id: Int?
    let name: String?
    let address: String?
    let roadName: String?
    let buildingIndex: String?
    let imageUrlString: String?
    let detailedAddress: String?
    let latitude: Double?
    let longitude: Double?
    let distance: Double?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "clothingBinId"
        case name = "name"
        case address = "address"
        case roadName = "roadName"
        case buildingIndex = "buildingIndex"
        case imageUrlString = "image"
        case detailedAddress = "detailedAddress"
        case latitude = "latitude"
        case longitude = "longitude"
        case distance = "distanceInMeters"
        case updatedAt = "updatedAt"
    }
}
