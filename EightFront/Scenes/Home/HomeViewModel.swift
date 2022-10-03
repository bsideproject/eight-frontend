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
import CoreLocation

//MARK: HomeViewModel
final class HomeViewModel {
    //MARK: - Properties
    var cancelBag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    let clothesProvider = MoyaProvider<ClothesAPI>()
    @Published var addressString: String?
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    func bind() {
        LocationManager.shared.$currentAddress
            .compactMap { $0 }
            .sink { [weak self] in
                self?.addressString = $0
            }
            .store(in: &cancelBag)
        
        input.requestAddress
            .sink {
                if case let .failure(error) = $0 {
                    LogUtil.d(error.localizedDescription)
                }
            } receiveValue: {
                LocationManager.shared.addressUpdate(location: $0) { [weak self] address in
                    self?.addressString = address
                }
            }
            .store(in: &cancelBag)
    }
}

//MARK: - I/O & Error
extension HomeViewModel {
    enum ErrorResult: Error {
        case notFoundAddress
    }
    
    struct Input {
        var requestAddress = CurrentValueSubject<CLLocation?, ErrorResult>.init(nil)
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
