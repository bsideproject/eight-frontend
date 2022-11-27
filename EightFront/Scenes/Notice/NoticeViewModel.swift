//
//  NoticeViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/27.
//

import Foundation
import Combine

class NoticeViewModel {
    
    var bag = Set<AnyCancellable>()
    
//    @Published var notices = [NoticeModel]()
    @Published var notices = [
        NoticeModel(title: "버릴까 말까", description: "~님이 댓글을 달았습니다."),
        NoticeModel(title: "버릴까 말까", description: "~님이 대댓글을 달았습니다."),
        NoticeModel(title: "신규 등록", description: "처리중 상태로 변경되었습니다.")
    ]
    
    // 알림 목록 불러오기
    func fetchNotice() {
    }
    
    func cellForRowAt(indexPath: IndexPath) -> NoticeModel {
        return notices[indexPath.row]
    }
    
}

struct NoticeModel {
    let title: String
    let description: String
}
