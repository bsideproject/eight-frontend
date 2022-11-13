//
//  MyInfoViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation
import Combine
import KakaoSDKUser

class MyInfoViewModel {
    
    var bag = Set<AnyCancellable>()
    
    func kakaoResign() {
        UserApi.shared.unlink { error in
            if let error = error {
                print(error)
            } else {
                print("회원탈퇴 성공")
            }
        }
        
    }
}
