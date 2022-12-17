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
    
    @Published var notices = [String: String]()
    
    // 알림 목록 불러오기
    func requestNotice() {
     // 로직 작성 필요
    }
    
    func numberOfRowsInSection() -> Int {
        notices.count
    }
    
//    func cellForRowAt(indexPath: IndexPath) -> NoticeModel {
//        return notices[indexPath.row]
//    }
    
}

struct NoticeModel {
    let title: String
    let description: String
}
