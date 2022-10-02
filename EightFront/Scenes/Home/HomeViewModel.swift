//
//  HomeViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/09/27.
//

import UIKit
import Combine
import Moya
import CombineMoya

//MARK: HomeViewModel
final class HomeViewModel {
    //MARK: - Properties
    var cancelBag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    let clothesProvider = MoyaProvider<ClothesAPI>()
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    func bind() {
        
    }
}

//MARK: - I/O & Error
extension HomeViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}

//MARK: - Method
extension HomeViewModel {
    func requestCoordinates() {
        clothesProvider.requestPublisher(.coordinates)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                case .finished:
                    LogUtil.d("Successed")
                }
            } receiveValue: { response in
                guard let responseData = try? response.map(CoordinatesResponse.self).data else { return }
                LogUtil.d(responseData)
            }
            .store(in: &cancelBag)
    }
}
