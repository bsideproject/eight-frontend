//
//  AuthAPI.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation
import Moya

//enum simpleLoginType: String {
//    case apple = "apple"
//    case kakao = "kakao"
//}

enum AuthAPI {
    case kakaoSignIn(param: SimpleSignInRequest)
    case kakaoSignUp(param: SimpleSignUpRequest)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site")!
    }
    
    var path: String {
        switch self {
        case .kakaoSignIn:
            return "/api/oauth2/kakao"
        case .kakaoSignUp:
            // singup 오타 아님
            return "/api/oauth2/kakao/singup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoSignIn:
            return .post
        case .kakaoSignUp:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoSignIn(let param):
            return .requestJSONEncodable(param)
        case .kakaoSignUp(let param):
            return .requestJSONEncodable(param)
        }
    }

    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
