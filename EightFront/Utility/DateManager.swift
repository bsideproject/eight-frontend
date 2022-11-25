//
//  DateManager.swift
//  EightFront
//
//  Created by wargi on 2022/11/19.
//

import Foundation

class DateManager {
    private let formatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_kr")
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    static let shared = DateManager()
    
    private init() {}
    
    func timeString(target: String?) -> String? {
        guard let date = formatter.date(from: target ?? "") else { return nil }
        
        let from = date.timeIntervalSince1970
        let to = Date().timeIntervalSince1970
        
        let duration = to - from
        
        let minute = 60.0
        let hour = minute * 60
        let day = hour * 24
        let month = day * 30
        let year = day * 365
        
        if duration > year {
            return "\(Int(duration / year))년 전"
        } else if duration > month && duration < year {
            return "\(Int(duration / month))달 전"
        } else if duration > (day * 3) && duration < month {
            return "\(Int(duration / year))일 전"
        } else if duration > (day * 2) && duration < (day * 3) {
            return "그저께"
        } else if duration > day && duration < (day * 2) {
            return "어제"
        } else if duration > hour && duration < day {
            return "\(Int(duration / hour))시간 전"
        } else if duration > minute && duration < hour {
            return "\(Int(duration / minute))분 전"
        } else {
            return "지금"
        }
    }
}
