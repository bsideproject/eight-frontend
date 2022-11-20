//
//  ReportLogViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation
import Combine

struct Report {
    let address: String
    let time: String
    let state: String
}

class ReportLogViewModel {
    
    enum Category {
        case all
        case edit
        case add
    }
    
    var bag = Set<AnyCancellable>()
    
    @Published var selectedCategory = Category.all
    
    var reportList = [
        Report(address: "마포구 마포18길 12", time: "2022.01.21 08:00", state: "처리중"),
        Report(address: "마포구 마포18길 12", time: "2022.02.21 08:00", state: "완료"),
        Report(address: "마포구 마포18길 12", time: "2022.03.21 08:00", state: "반려"),
        Report(address: "마포구 마포18길 12", time: "2022.04.21 08:00", state: "완료"),
        Report(address: "마포구 마포18길 12", time: "2022.05.21 08:00", state: "반려"),
    ]
    
    func numberOfRowsInSection() -> Int {
        return reportList.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Report {
        return reportList[indexPath.row]
    }
    
}
