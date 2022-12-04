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
//            let accessToken = KeyChainManager.shared.readAccessToken()
//            let jwt = try? JWTDecode.decode(jwt: accessToken)
//            guard let memberId = jwt?.subject else { return }
            authProvider.request(.memberResign) { [weak self] result in
                switch result {
                case .failure(let error):
                    LogUtil.e(error)
                case .success(let response):
                    LogUtil.d(response)
                    guard
                        let signType = UserDefaults.standard.object(forKey: "signType") as? String
                    else {
                        return
                    }
                    switch signType {
                    case SignType.kakao.rawValue:
                        self?.kakaoResign { [weak self] bool in
                            if bool {
                                if KeyChainManager.shared.deleteAccessToken() {
                                    UserDefaults.standard.removeObject(forKey: "signType")
                                    self?.isResigned = true
                                } else {
                                    print("키체인 제거 실패")
                                }
                            }
                        }
                    case SignType.apple.rawValue:
                        LogUtil.d("애플 회원 탈퇴")
                        if KeyChainManager.shared.deleteAccessToken() {
                            UserDefaults.standard.removeObject(forKey: "signType")
                            self?.isResigned = true
                        } else {
                            print("키체인 제거 실패")
                        }
                    case SignType.email.rawValue:
                        LogUtil.d("이메일 회원 탈퇴")
                    default:
                        break
                    }
                }
            }
        }
    }
}
