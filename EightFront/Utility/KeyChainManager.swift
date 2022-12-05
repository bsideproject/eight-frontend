//
//  KeyChainManager.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/05.
//

import Foundation
import JWTDecode

/// service = 키 체인에서 해당 앱을 식별하는 값 (앱만의 고유한 값)
/// account = 앱 내에서 데이터를 식별하기 위한 키에 해당하는 값 (키체인의 이름)

final class KeyChainManager {
    
    enum KeyChainCategory {
        case accessToken
        case authorizationCode
        
        var account: String {
            switch self {
            case .accessToken:
                return "accessToken"
            case .authorizationCode:
                return "authorizationCode"
            }
        }
    }
    
    static let shared = KeyChainManager()
    private let service = Bundle.main.bundleIdentifier
    var accessToken = ""
    
    /// keyChain에 입력 받은 값(token)을 저장
    func create(_ token: String, type: KeyChainCategory) -> Bool {
        guard let service = self.service else { return false }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: type.account,
            kSecAttrGeneric: token.data(using: .utf8)
        ]
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    /// keyChain에서 AccessToken을 가져옴
    func read(type: KeyChainCategory) -> String {
        guard let service = self.service else { return "" }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: type.account,
            kSecMatchLimit : kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            LogUtil.e("KeyChain AccessToken Read Failed")
            return ""
        }
        guard let existingItem = item as? [String: Any] else {
            LogUtil.e("existingItem Error")
            return ""
        }
        guard let data = existingItem[kSecAttrGeneric as String] as? Data else {
            LogUtil.e("data Error")
            return ""
        }
        guard let accessToken = String(data: data, encoding: .utf8) else {
            LogUtil.e("KeyChain AccessToken Read Failed ~! ")
            return ""
        }
        return accessToken
    }

    func delete(type: KeyChainCategory) -> Bool {
        guard let service = self.service else { return false }
        // 키 체인 쿼리 정의
        let query:[CFString: Any]=[
            kSecClass: kSecClassGenericPassword, // 보안 데이터 저장
            kSecAttrService: service, // 키 체인에서 해당 앱을 식별하는 값 (앱만의 고유한 값)
            kSecAttrAccount : type.account] // 앱 내에서 데이터를 식별하기 위한 키에 해당하는 값 (사용자 계정)
        // 현재 저장되어 있는 값 삭제
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            LogUtil.d("키체인 삭제 성공")
            return true
        }
        else {
            LogUtil.e("키체인 삭제 실패")
            return false
        }
    }
}
