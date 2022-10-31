//
//  ClothesAPI.swift
//  EightFront
//
//  Created by wargi on 2022/10/01.
//

import Foundation
import Moya

enum ClothesAPI {
    case clothingBins(latitude: Double, longitude: Double)
}

extension ClothesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site/api")!
    }
    
    var path: String {
        switch self {
        case .clothingBins:
            return "/clothing-bins"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .clothingBins:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .clothingBins(let lat, let lng):
            let params: [String: Any] = [
                "latitude": lat,
                "longitude": lng
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
