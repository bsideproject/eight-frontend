//
//  AuthAPI.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation
import Moya

struct simpleSignUp: Codable {
    var authId: String
    var authType: String
    var deviceID: String
    
    init(authId: String, authType: String, deviceID: String) {
        self.authId = authId
        self.authType = authType
        self.deviceID = deviceID
    }
}

enum AuthAPI {
    case login(_ authType: String?, _ authId: String?, _ deviceID: String?)
}

enum simpleLoginType {
    case apple
    case kakao
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
    
    var sampleData: Data {
        switch self {
        case .login(let authType, let authId, let deviceID):
//            let authType = authType
//            let authId = authId
//            let deviceID = deviceID
            
            return Data(
                    """
                    {
                        "authId": \(authType),
                        "authType": \(authId),
                        "deviceID": \(deviceID)
                    }
                    """.utf8)
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
