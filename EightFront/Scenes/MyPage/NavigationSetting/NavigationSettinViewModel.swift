//
//  NavigationSettinViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation
import Combine


class NavigationSettinViewModel {
    
    enum mapType {
        case kakao
        case naver
    }
    
    var bag = Set<AnyCancellable>()
    
    @Published var navagation = UserDefaults.standard.object(forKey: "navigation") as? String
    
}
