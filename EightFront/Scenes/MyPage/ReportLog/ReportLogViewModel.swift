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
    var reportList = [
        Report(address: "서울", time: "2022.01.21 08:00", state: "처리중"),
        Report(address: "대전", time: "2022.02.21 08:00", state: "완료"),
        Report(address: "대구", time: "2022.03.21 08:00", state: "반려"),
        Report(address: "부산", time: "2022.04.21 08:00", state: "완료"),
        Report(address: "광주", time: "2022.05.21 08:00", state: "반려"),
    ]
    
    func numberOfRowsInSection() -> Int {
        return reportList.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Report {
        return reportList[indexPath.row]
    }
    
}
