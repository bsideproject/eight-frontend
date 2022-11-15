//
//  MyInfoViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/13.
//

import Foundation
import Combine
import KakaoSDKUser
import JWTDecode

class MyInfoViewModel {
    
    var bag = Set<AnyCancellable>()
    
    @Published var userEmail = UserDefaults.standard.object(forKey: "email") as? String ?? ""
    @Published var nickName = UserDefaults.standard.object(forKey: "nickName") as? String ?? ""
    
    func resign() {
        let accessToken = KeyChainManager.shared.readAccessToken()
        let jwt = try? decode(jwt: accessToken)   
    }
    
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
