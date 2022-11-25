//
//  UserInfoManager.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/24.
//

import Foundation
import Moya
import JWTDecode

class UserInfoManager {
    let authProvider = MoyaProvider<AuthAPI>()
    static let shared = UserInfoManager()
    
    var userInfo: UserInfo?
    
    func fetchUserInfo(completion: @escaping(UserInfo?) -> Void) {
        let accessToken = KeyChainManager.shared.readAccessToken()
        if accessToken != "" {
            let jwt = try? JWTDecode.decode(jwt: accessToken)
            if let memeberId = jwt?.body["sub"] as? String {
                authProvider.request(.userInfo(memberId: memeberId)) { [weak self] result in
                    switch result {
                    case .success(let response):
                        let data = try? JSONDecoder().decode(UserInfo.self, from: response.data)
                        UserInfoManager.shared.userInfo = UserInfo(accessToken: data?.accessToken,
                                                                   nickName: data?.nickName,
                                                                   email: data?.email,
                                                                   type: data?.type)
                        completion(self?.userInfo)
                    case .failure(let moyaError):
                        LogUtil.e(moyaError)
                    }
                }
            }
        }
    }
}
