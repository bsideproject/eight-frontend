//
//  SettingViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation
import Combine

class SettingViewModel {
    
    var bag = Set<AnyCancellable>()
    @Published var isNotification: Bool = UserDefaults.standard.bool(forKey: "isNotification")
    
    func requestIsNotification() {
        // 유저 DB에 알림 여부 반영 필요
    }

}
