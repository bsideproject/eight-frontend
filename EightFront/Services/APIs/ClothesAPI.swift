//
//  ClothesAPI.swift
//  EightFront
//
//  Created by wargi on 2022/11/09.
//

import UIKit
import Moya

enum ClothesAPI {
    /// 카테고리 조회
    case categories
    /// 버릴까 말까 글 리스트 조회
    case posts(order: String, category: String)
    /// 버릴까 말까 글 조회
    case post(id: Int)
    /// 버릴까 말까 글 등록
    case newPost(info: PostRequest, images: [UIImage])
    /// 버릴까 말까 글 투표
    case vote(type: VoteRequest)
    /// 버릴까 말까 글 댓글 조회
    case comments(id: Int)
    /// 버릴까 말까 글 댓글 등록
    case newComment(id: Int, info: CommentRequest)
    /// 나의 버릴까 말까 글 목록 조회
    case myPosts
}

extension ClothesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site/api")!
    }
    
    var path: String {
        switch self {
        case .categories:
            return "/keep-or-drop/categories"
        case .posts:
            return "/keep-or-drop"
        case .post(let id):
            return "/keep-or-drop/\(id)"
        case .newPost:
            return "/keep-or-drop/article"
        case .vote(let id):
            return "/keep-or-drop/\(id)/vote"
        case .comments(let id):
            return "/keep-or-drop/\(id)/comments"
        case .newComment(let id, _):
            return "/keep-or-drop/\(id)/comments"
        case .myPosts:
            return "/my/keep-or-drop/article"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .posts, .post, .categories, .comments, .myPosts:
            return .get
        case .newPost, .vote, .newComment:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .posts(let order, let category):
            let params: [String: Any] = [
                "orderType": order,
                "category": category
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .post, .categories, .comments:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case let .newPost(info, images):
            var fromData = [MultipartFormData]()
            
            if let report = try? JSONEncoder().encode(info) {
                fromData.append(MultipartFormData(provider: .data(report), name: "request"))
            }
            
            images.first?.jpegData(compressionQuality: 0.3)
            
            for image in images {
                guard let jpegData = image.jpegData(compressionQuality: 0.3) else { continue }
                let name = UUID().uuidString
                fromData.append(MultipartFormData(provider: .data(jpegData),
                                                  name: name,
                                                  fileName: "\(name).jpeg",
                                                  mimeType: "image/jpeg"))
            }
            return .uploadMultipart(fromData)
        case .vote(let param):
            return .requestJSONEncodable(param)
        case .newComment(_, let param):
            return .requestJSONEncodable(param)
        case .myPosts:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        
        let bearer = "Bearer \(KeyChainManager.shared.readAccessToken())"
        
        return [
            "Content-type": "application/json",
            "Authorization": bearer
        ]
    }
}
