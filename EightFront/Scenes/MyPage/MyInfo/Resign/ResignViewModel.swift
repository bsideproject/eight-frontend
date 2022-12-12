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
            guard let signType = UserDefaults.standard.object(forKey: "signType") as? String else { return }
            if signType == SignType.kakao.rawValue {
                authProvider.request(.memberResign(param: "")) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        LogUtil.e(error)
                    case .success:
                        self?.kakaoResign { [weak self] bool in
                            if bool {
                                if KeyChainManager.shared.delete(type: .accessToken) {
                                    UserDefaults.standard.removeObject(forKey: "signType")
                                    self?.isResigned = true
                                } else {
                                    print("키체인 제거 실패")
                                }
                            }
                        }
                    }
                }
            } else if signType == SignType.apple.rawValue {
                let authCode = KeyChainManager.shared.read(type: .authorizationCode)
                authProvider.request(.memberResign(param: authCode)) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        LogUtil.e(error)
                    case .success:
                        LogUtil.d("애플 회원 탈퇴")
                        _ = KeyChainManager.shared.delete(type: .accessToken)
                        _ = KeyChainManager.shared.delete(type: .authorizationCode)
                        UserDefaults.standard.removeObject(forKey: "signType")
                        self?.isResigned = true
                    }
                }
            }
        }
    }
}
