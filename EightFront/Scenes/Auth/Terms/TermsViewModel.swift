//
//  TermsViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation
import Combine

final class TermsViewModel {
    
    enum Terms: CaseIterable {
        case all
        case policy
        case privacy
        case location
        
        var type: String {
            switch self {
            case .all:
                return "all"
            case .policy:
                return "policy"
            case .privacy:
                return "privacy"
            case .location:
                return "location"
            }
        }
    }
    
    var bag = Set<AnyCancellable>()
    
    @Published var isPolicy: Bool = false
    @Published var isPrivacy: Bool = false
    @Published var isLocation: Bool = false
    
}
