//
//  AuthAPI.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation
import Moya

enum AuthAPI {
    case socialSignIn(param: SocialSignInRequest)
    case socialSignUp(param: SocialSignUpRequest)
    case emailSignIn(param: SocialSignInRequest)
    case emailSignUp(param: SocialSignUpRequest)
    case memberResign(memberId: String)
    case nicknameCheck(nickname: String)
    case nicknameChange(memberId: String, nickname: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site")!
    }
    
    var path: String {
        switch self {
        case .socialSignIn:
//            let social = param.category.rawValue
            let path = "/api/oauth2/kakao"
            return path
        case .socialSignUp:
//            let social = param.category.rawValue
            let path = "/api/oauth2/kakao/signup"
            return path
        case .emailSignIn:
            return ""
        case .emailSignUp:
            return ""
        case .memberResign(let memberId):
            return "/api/oauth2/\(memberId)"
        case .nicknameCheck(let nickname):
            return "/api/oauth2/\(nickname)"
        case .nicknameChange(let memberId, _):
            return "/api/oauth2/\(memberId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .socialSignIn:
            return .post
        case .socialSignUp:
            return .post
        case .emailSignIn:
            return .post
        case .emailSignUp:
            return .post
        case .memberResign:
            return .delete
        case .nicknameCheck:
            return .get
        case .nicknameChange:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .socialSignIn(let param):
            return .requestJSONEncodable(param)
        case .socialSignUp(let param):
            return .requestJSONEncodable(param)
        case .emailSignIn(let param):
            return .requestJSONEncodable(param)
        case .emailSignUp(let param):
            return .requestJSONEncodable(param)
        case .memberResign:
            return .requestPlain
        case .nicknameCheck:
            return .requestPlain
        case .nicknameChange(_, let nickname):
            return .requestParameters(parameters: [
                "nickname": nickname
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
