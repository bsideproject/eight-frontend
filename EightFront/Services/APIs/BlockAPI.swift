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
    case unBlock
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
        case .unBlock:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        
        let accessToken = KeyChainManager.shared.accessToken
        
        return [
            "Content-type": "application/json",
            "accessToken": accessToken
        ]
    }
}
