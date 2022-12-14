//
//  BlockAPI.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/24.
//

import UIKit
import Moya

enum BlockAPI {
    case blockList
    case block
    case unBlock(param: String)
}

extension BlockAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site")!
    }
    
    var path: String {
        switch self {
        case .blockList,
             .block,
             .unBlock:
            return "/api/my/block/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .blockList:
            return .get
        case .block:
            return .post
        case .unBlock:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .blockList:
            return .requestPlain
        case .block:
            return .requestPlain
        case .unBlock(let memberId):
            let params = [
                "memberId": memberId
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let bearer = "Bearer \(KeyChainManager.shared.read(type: .accessToken))"
        return [
            "Content-type": "application/json",
            "accessToken": bearer
        ]
    }
}
