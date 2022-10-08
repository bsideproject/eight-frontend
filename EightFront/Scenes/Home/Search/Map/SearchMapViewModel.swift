//
//  FindAddressViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import UIKit
import Combine
import CoreLocation

//MARK: FindAddressViewModel
final class SearchMapViewModel {
    //MARK: - Properties
    var cancelBag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    @Published var addressString: String?
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
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
extension SearchMapViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var requestAddress = CurrentValueSubject<CLLocation?, ErrorResult>.init(nil)
    }
    
    struct Output {
        
    }
}

//MARK: - Method
extension SearchMapViewModel {
}
