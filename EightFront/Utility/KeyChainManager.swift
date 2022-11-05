//
//  KeyChainManager.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/05.
//

import Foundation

/*
 
 service = 키 체인에서 해당 앱을 식별하는 값 (앱만의 고유한 값)
 account = 앱 내에서 데이터를 식별하기 위한 키에 해당하는 값 (사용자 계정)
 
 
 */

final class KeyChainManager {
    static let shared = KeyChainManager()
    
    private let service = Bundle.main.bundleIdentifier
    
    func createToken(_ token: String) -> Bool {
        
        let data = token
        let account = "accessToken"
        
        guard let service = self.service else { return false }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrGeneric: data
        ]
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print(status)
            return false
        } else {
            print(status)
            return false
        }
    }
}
