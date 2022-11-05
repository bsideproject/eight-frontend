//
//  KeyChainManager.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/05.
//

import Foundation

/// service = 키 체인에서 해당 앱을 식별하는 값 (앱만의 고유한 값)
/// account = 앱 내에서 데이터를 식별하기 위한 키에 해당하는 값 (키체인의 이름)

final class KeyChainManager {
    
    enum KeyChainCategory {
        case accessToken
        
        var account: String {
            switch self {
            case .accessToken:
                return "accessToken"
            }
        }
    }
    
    static let shared = KeyChainManager()
    
    private let service = Bundle.main.bundleIdentifier
    
    /// keyChain에 입력 받은 값(token)을 저장
    func createAccessToken(_ token: String) -> Bool {
        let data = token
        guard let service = self.service else { return false }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: KeyChainCategory.accessToken.account,
            kSecAttrGeneric: data
        ]
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            LogUtil.d("KeyChain AccessToken Create Success.")
            return true
        } else {
            LogUtil.e("KeyChain AccessToken Create Faild")
            return false
        }
    }
    
    /// keyChain에서 AccessToken을 가져옴
    func readAccessToken() {
        guard let service = self.service else { return }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: KeyChainCategory.accessToken.account,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        
         if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
             LogUtil.e("KeyChain AccessToken Read Failed")
             return
         }
         guard let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let accessToken = String(data: data, encoding: .utf8) else { return }
         
        LogUtil.d("accessToken: \(accessToken)")
    }
}
