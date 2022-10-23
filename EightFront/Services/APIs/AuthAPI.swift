//
//  AuthAPI.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation
import Moya

enum AuthAPI {
    case login(param: SimpleSignUpRequest)
}

enum simpleLoginType: String {
    case apple = "apple"
    case kakao = "kakao"
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/oauth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
