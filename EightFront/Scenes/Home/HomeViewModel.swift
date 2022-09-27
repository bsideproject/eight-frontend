//
//  HomeViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/09/27.
//

import UIKit
import Combine

//MARK: HomeViewModel
final class HomeViewModel {
    //MARK: - Properties
    var cancelBag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    
    //MARK: Initializer
    init() {
        rxBind()
    }
    
    //MARK: RxBinding..
    func rxBind() {
        
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
    
}
