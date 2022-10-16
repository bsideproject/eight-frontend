//
//  SimpleSignUpResponse.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation

// MARK: - SignUpResponse
struct SimpleSignUpResponse: Codable {
    let header: Header
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let content: Content
}

// MARK: - Content
struct Content: Codable {
    let authID, authType, deviceID: String

    enum CodingKeys: String, CodingKey {
        case authID = "authId"
        case authType, deviceID
    }
}

// MARK: - Header
struct Header: Codable {
    let resultCode: Int
    let resultMessage: String
}
