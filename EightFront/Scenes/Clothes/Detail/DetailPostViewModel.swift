//
//  DetailPostViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import UIKit
import Combine

//MARK: DetailPostViewModel
final class DetailPostViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        
    }
}

//MARK: - I/O & Error
extension DetailPostViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}

//MARK: - Method
extension DetailPostViewModel {
    
}
