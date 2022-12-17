//
//  ResignViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/20.
//

import Foundation
import Combine

import KakaoSDKUser
import JWTDecode
import Moya

class ResignViewModel {
    
    private let authProvider = MoyaProvider<AuthAPI>()
    var bag = Set<AnyCancellable>()
    
    @Published var isChecked = false
    @Published var isResigned = false
    
    func kakaoResign(completion: @escaping(Bool) -> Void){
        UserApi.shared.unlink { error in
            if let error = error {
                print(error)
            } else {
                completion(true)
            }
        }
    }
    
    func resign() {
        if isChecked == true {
            guard
                let signType = UserDefaults.standard.object(forKey: "signType") as? String
            else {
                assertionFailure("signType 정의 되어있지 않음")
                return
            }
            
            switch SignType(rawValue: signType) {
            case .kakao:
                authProvider.request(.memberResign(param: "")) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        LogUtil.e(error)
                    case .success:
                        self?.kakaoResign { [weak self] bool in
                            if bool {
                                _ = KeyChainManager.shared.delete(type: .accessToken)
                                _ = KeyChainManager.shared.delete(type: .authorizationCode)
                                UserDefaults.resetStandardUserDefaults()
                                self?.isResigned = true
                            }
                        }
                    }
                }
            case .apple:
                let authCode = KeyChainManager.shared.read(type: .authorizationCode)
                authProvider.request(.memberResign(param: authCode)) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        LogUtil.e(error)
                    case .success:
                        _ = KeyChainManager.shared.delete(type: .accessToken)
                        _ = KeyChainManager.shared.delete(type: .authorizationCode)
                        UserDefaults.resetStandardUserDefaults()
                        self?.isResigned = true
                    }
                }
            default:
                assertionFailure("회원탈퇴 실패")
            }
        }
    }
}
