//
//  LogUtil.swift
//  EightFront
//
//  Created by wargi on 2022/09/15.
//

import Foundation

final class LogUtil {
    enum LogEvent: String {
        case d = "[💬]" // debug
        case e = "[‼️]" // error
        case i = "[ℹ️]" // info
        case v = "[🔬]" // verbose
        case w = "[⚠️]" // warning
        case s = "[🔥]" // severe
    }
    
    // error
    public class func e( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // info
    public class func i( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // debug
    public class func d( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
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
    
    // verbose
    public class func v( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // warning
    public class func w( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString) \(LogEvent.w.rawValue)[\(sourceFileName(filePath: filename))]
            Line:\(line)
            Column:\(column)
            Function:\(funcName) ->
            \(object)
            ------------------------------------------------------------------------------------
            """)
    }
    
    // severe
    public class func s( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("""
            ------------------------------------------------------------------------------------
            \(Date().toString) \(LogEvent.s.rawValue)[\(sourceFileName(filePath: filename))]
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
