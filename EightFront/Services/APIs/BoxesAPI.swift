//
//  ClothesAPI.swift
//  EightFront
//
//  Created by wargi on 2022/10/01.
//

import UIKit
import Moya

enum ClothesAPI {
    case clothingBins(latitude: Double, longitude: Double)
    case newReport(info: ReportRequest, images: [UIImage])
    case updateReport(id: String, info: ReportRequest, images: [UIImage])
    case deleteReport(id: String)
}

extension ClothesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.droptheclothes.site/api")!
    }
    
    var path: String {
        switch self {
        case .clothingBins:
            return "/clothing-bins"
        case .newReport:
            return "/clothing-bins/report/new"
        case .updateReport(let id, _, _):
            return "/clothing-bins/report/\(id)"
        case .deleteReport(let id):
            return "/clothing-bins/report/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .clothingBins:
            return .get
        case .newReport:
            return .post
        case .updateReport:
            return .put
        case .deleteReport:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .clothingBins(let lat, let lng):
            let params: [String: Any] = [
                "latitude": lat,
                "longitude": lng
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .newReport(let info, let images):
            var fromData = [MultipartFormData]()
            
            if let report = try? JSONEncoder().encode(info) {
                fromData.append(MultipartFormData(provider: .data(report), name: "request"))
            }
            
            images.first?.jpegData(compressionQuality: 0.3)
            
            for image in images {
                guard let jpegData = image.jpegData(compressionQuality: 0.3) else { continue }
                let name = UUID().uuidString
                fromData.append(MultipartFormData(provider: .data(jpegData),
                                                  name: name,
                                                  fileName: "\(name).jpeg",
                                                  mimeType: "image/jpeg"))
            }
            return .uploadMultipart(fromData)
        case let .updateReport(_, info, images):
            var fromData = [MultipartFormData]()
            
            if let report = try? JSONEncoder().encode(info) {
                fromData.append(MultipartFormData(provider: .data(report), name: "request"))
            }
            
            images.first?.jpegData(compressionQuality: 0.3)
            
            for image in images {
                guard let jpegData = image.jpegData(compressionQuality: 0.3) else { continue }
                let name = UUID().uuidString
                fromData.append(MultipartFormData(provider: .data(jpegData),
                                                  name: name,
                                                  fileName: "\(name).jpeg",
                                                  mimeType: "image/jpeg"))
            }
            return .uploadMultipart(fromData)
        case .deleteReport:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
