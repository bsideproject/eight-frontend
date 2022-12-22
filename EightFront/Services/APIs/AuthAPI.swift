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
    case appleSignIn(param: SocialSignInRequest)
    case appleSignUp(param: SocialSignUpRequest)
    case memberResign(param: String)
    case nicknameCheck(nickname: String)
    case nicknameChange(nickname: String)
    case userInfo
    case profileDefaultImageChange(defaultImage: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site")!
    }
    
    var path: String {
        switch self {
        case .socialSignIn:                return "/api/oauth2/kakao"
        case .socialSignUp:                return "/api/oauth2/kakao/signup"
        case .appleSignIn:                 return "/api/oauth2/apple"
        case .appleSignUp:                 return "/api/oauth2/apple/signup"
            
        case .memberResign:                return "/api/oauth2/member"
        case .nicknameCheck(let nickname): return "/api/oauth2/\(nickname)"
        case .nicknameChange:              return "/api/my/info/nickname"
        case .userInfo:                    return "/api/my/info"
        case .profileDefaultImageChange:   return "/api/my/info/profile-image"
//        case .profileUploadImageChange:    return ""
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .socialSignIn,
             .socialSignUp,
             .appleSignIn,
             .appleSignUp:        return .post
        case .memberResign:       return .delete
        case .nicknameCheck:      return .get
        case .nicknameChange:     return .put
        case .userInfo:           return .get
        case .profileDefaultImageChange: return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .socialSignIn(let param): return .requestJSONEncodable(param)
        case .socialSignUp(let param): return .requestJSONEncodable(param)
        case .memberResign(let authCode):
            if authCode.isEmpty {
                return .requestPlain
            } else {
                let params = [
                    "authorizationCode": authCode
                ]
                return .requestParameters(parameters: params, encoding: URLEncoding.httpBody)
            }
        case .nicknameCheck: return .requestPlain
            
        case .nicknameChange(let nickname):
            return .requestParameters(
                parameters: [
                    "nickname": nickname
                ], encoding: URLEncoding.queryString)

        case .appleSignIn(let param): return .requestJSONEncodable(param)
        case .appleSignUp(let param): return .requestJSONEncodable(param)
        case .userInfo: return .requestPlain
        case .profileDefaultImageChange(let defaultImage):
            return .requestParameters(parameters: [
                "defaultProfileImage": defaultImage
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .socialSignIn,
             .appleSignIn:
            return [
                "Content-type": "application/json",
            ]
        case .memberResign:
            let bearer = "Bearer \(KeyChainManager.shared.read(type: .accessToken))"
            return [
                "Content-type": "application/x-www-form-urlencoded",
                "Authorization": bearer
            ]
        default:
            let bearer = "Bearer \(KeyChainManager.shared.read(type: .accessToken))"
            return [
                "Content-type": "application/json",
                "Authorization": bearer
            ]
        }
    }
}
