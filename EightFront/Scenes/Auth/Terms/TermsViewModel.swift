//
//  TermsViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation
import Combine

final class TermsViewModel {
    
    enum Terms {
        case all
        case policy
        case privacy
        case location
        
        var type: String {
            switch self {
            case .all :
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
    
    @Published var isAllAgree: Bool = false
    @Published var isPolicy: Bool = false
    @Published var isPrivacy: Bool = false
    @Published var isLocation: Bool = false
    
    func checkButtonTapped(_ type: Terms) {
        switch type {
        case .all:
            isAllAgree = !isAllAgree
            
            isPolicy = isAllAgree
            isPrivacy = isAllAgree
            isLocation = isAllAgree
            
        case .policy:
            isPolicy = !isPolicy
        case .privacy:
            isPrivacy = !isPrivacy
        case .location:
            isLocation = !isLocation
        }
        
        if isPolicy == true && isPrivacy == true && isLocation == true {
            isAllAgree = true
        } else {
            isAllAgree = false
        }
        
    }
}
