//
//  TermsViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation
import Combine

final class TermsViewModel {
    
    var bag = Set<AnyCancellable>()
    
    @Published var isAllAgree: Bool = true
    @Published var isPolicy: Bool = true
    @Published var isPrivacy: Bool = true
    @Published var isLocation: Bool = true
    
    lazy var isAllAgessValid: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest3($isPolicy, $isPrivacy, $isLocation)
        .compactMap { $0 == true && $1 == true && $2 == true ? true : false }
        .eraseToAnyPublisher()
    
}
