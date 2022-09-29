//
//  SearchMapViewModel.swift
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
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    var isMove = false
    @Published var addressString: String?
    var requestLocation: CLLocation? {
        didSet {
            LocationManager.shared.addressUpdate(location: requestLocation) { [weak self] address in
                self?.addressString = address
            }
        }
    }
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        
    }
}

//MARK: - I/O & Error
extension SearchMapViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}

//MARK: - Method
extension SearchMapViewModel {
}
