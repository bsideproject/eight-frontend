//
//  ReportRequest.swift
//  EightFront
//
//  Created by wargi on 2022/11/01.
//

import Foundation

struct ReportRequest: Encodable {
    var memberId: String
    var address: String
    var detailedAddress: String
    var latitude: Double
    var longitude: Double
    var comment: String
}
