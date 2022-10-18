//
//  simpleSignUpRequest.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import Foundation

struct simpleSignUpRequest: Codable {
    var authId: String
    var authType: String
    var deviceID: String
    
    init(authId: String, authType: String, deviceID: String) {
        self.authId = authId
        self.authType = authType
        self.deviceID = deviceID
    }
}
