//
//  ResignViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/20.
//

import Foundation
import Combine
import KakaoSDKUser

class ResignViewModel {
    
    var bag = Set<AnyCancellable>()
    
    @Published var isChecked = false
    
    func kakaoResign(completion: @escaping(Bool) -> Void){
        UserApi.shared.unlink { error in
            if let error = error {
                print(error)
            } else {
                completion(true)
            }
        }
    }
}
