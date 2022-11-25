//
//  ReportResponse.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/26.
//

import Foundation

struct ReportResponse: Decodable {
    let header: ApiResponse
    let data: Reports
}

struct Reports: Decodable {
    let contents: [Report]
}

struct Report: Decodable {
    let address: String
    let createdAt: String
    let status: String
}
