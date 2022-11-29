//
//  ReportPostViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/11/20.
//

import UIKit
import Moya
import Combine

//MARK: ReportPostViewModel
final class ReportPostViewModel {
    //MARK: - Properties
    private var apiCall = 0
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    private let clothesProvider = MoyaProvider<ClothesAPI>()
    @Published var type: SelectType
    
    let reports = [
        "음란물",
        "불법정보를 포함",
        "청소년에게 유해한 내용",
        "욕설/생명경시/혐오/차별적 표현",
        "개인정보 노출 게시물",
        "불쾌한 표현"
    ]
    
    //MARK: Initializer
    init(type: SelectType) {
        self.type = type
        
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        input
            .requestCategroies
            .sink { [weak self] _ in
                self?.requestCategories()
            }
            .store(in: &bag)
        
        if type == .report {
            output.requestCategroies.send(reports)
        } else {
            input.requestCategroies.send(nil)
        }
    }
}

//MARK: - I/O & Error
extension ReportPostViewModel {
    enum SelectType {
        case report
        case category
    }
    
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var requestCategroies = PassthroughSubject<Void?, Never>()
    }
    
    struct Output {
        var requestCategroies = CurrentValueSubject<[String], Never>([])
    }
}

//MARK: - Method
extension ReportPostViewModel {
    private func requestCategories() {
        clothesProvider
            .requestPublisher(.categories)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                    
                    guard (self?.apiCall ?? 3) < 3 else { return }
                    self?.apiCall += 1
                    self?.requestCategories()
                case .finished:
                    LogUtil.d("Successed")
                    self?.apiCall = 0
                }
            } receiveValue: { [weak self] response in
                guard let responseData = try? response.map(CategoryResponse.self).data else { return }
                
                self?.output.requestCategroies.send(responseData.categories ?? [])
            }
            .store(in: &bag)
    }
}
