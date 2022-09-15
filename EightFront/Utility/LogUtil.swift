//
//  LogUtil.swift
//  EightFront
//
//  Created by wargi on 2022/09/15.
//

import Foundation

final class LogUtil {
    enum LogEvent: String {
        // TODO: 현재는 d만 사용하지만 혜령님이 추가하실 부분이 있다면, 추가해서 사용해주세요 :)
        case d = "[💬]" // debug
        case e = "[‼️]" // error
        case i = "[ℹ️]" // info
        case v = "[🔬]" // verbose
        case w = "[⚠️]" // warning
        case s = "[🔥]" // severe
    }
    
    // debug
    static func d( _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    private static func print(_ object: Any) {
        #if DEBUG
        Swift.print(object)
        #endif
    }
    
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last ?? ""
    }
}
