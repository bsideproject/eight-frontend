//
//  ReportRequest.swift
//  EightFront
//
//  Created by wargi on 2022/11/01.
//

import UIKit

struct ReportRequest: Encodable {
    var request: BoxInfoRequest
    var images: [Data]
}

struct BoxInfoRequest: Encodable {
    var address: String
    var detailedAddress: String
    var comment: String
}
