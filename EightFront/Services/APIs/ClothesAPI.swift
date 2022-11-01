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
    case newReport(param: ReportRequest?)
}

extension ClothesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site/api")!
    }
    
    var path: String {
        switch self {
        case .clothingBins:
            return "/clothing-bins"
        case .newReport:
            return "/clothing-bins/report/new"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .clothingBins:
            return .get
        case .newReport:
            return .post
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
        case .newReport(let param):
            
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
