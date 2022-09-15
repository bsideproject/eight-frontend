//
//  Date+.swift
//  EightFront
//
//  Created by wargi on 2022/09/15.
//

import Foundation

extension Date {
    var toString: String {
        return Formatter.yyyyMMddhhmmss.string(from: self)
    }
}
