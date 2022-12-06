//
//  PostRequest.swift
//  EightFront
//
//  Created by wargi on 2022/11/09.
//

import Foundation

/// 게시물 등록 요청
struct PostRequest: Encodable {
    var category: String
    var title: String
    var description: String
}

/// 게시물 투표 요청
struct VoteRequest: Encodable {
    var voteType: String
}

/// 게시물 댓글 요청
struct CommentRequest: Encodable {
    var comment: String
    var parentId: Int?
}
