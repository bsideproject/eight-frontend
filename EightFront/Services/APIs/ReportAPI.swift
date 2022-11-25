//
//  ReportAPI.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/26.
//

import Foundation
import Moya

enum ReportAPI {
    case clothingBeanReport
}

extension ReportAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site")!
    }
    
    var path: String {
        switch self {
        case .clothingBeanReport:
            return "/api/my/clothing-bin/report"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .clothingBeanReport:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .clothingBeanReport:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
