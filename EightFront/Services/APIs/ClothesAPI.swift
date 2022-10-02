//
//  ClothesAPI.swift
//  EightFront
//
//  Created by wargi on 2022/10/01.
//

import Foundation
import Moya

enum ClothesAPI {
    case coordinates
    case coordinate
}

extension ClothesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://118.67.133.14:8081/api")!
    }
    
    var path: String {
        switch self {
        case .coordinates:
            return "/coordinates"
        case .coordinate:
            return "/coordinate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .coordinates, .coordinate:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .coordinates, .coordinate:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
