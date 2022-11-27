//
//  ReportLogViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation
import Combine
import Moya

class ReportLogViewModel {
    
    enum Category {
        case all
        case edit
        case add
    }
    
    let provider = MoyaProvider<ReportAPI>()
    var bag = Set<AnyCancellable>()
    
    @Published var selectedCategory = Category.all
    @Published var reportList = [Report]()
    
    func numberOfRowsInSection() -> Int {
        return reportList.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Report {
        return reportList[indexPath.row]
    }
    
    func fetchReportList() {
        provider.requestPublisher(.clothingBeanReport)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    LogUtil.e(error)
                case .finished:
                    LogUtil.d("제보 내역 호출")
                }
            } receiveValue: { response in
                let data = try? response.map(ReportResponse.self)
                self.reportList = data?.data.contents ?? []
            }.store(in: &bag)

    }
    
}
