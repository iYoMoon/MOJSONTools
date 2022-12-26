//
//  MOPrintingLog.swift
//  MolyKit
//
//  Created by iMac-Moon on 2021/1/21.
//

import Foundation


/// JSON形式描述协议
public protocol JSONDescription {
    
    /// 自定义JSON形式描述
    /// - Parameter level: 内容级别, 一般用于Dictionary、Array等有二级内容的类型
    func description(_ level: Int) -> String
    
}

extension JSONDescription {
    
    /// JSON形式描述
    var jsonDescription: String {
        return description(0)
    }
    
    
}

extension Dictionary: JSONDescription {
    
    public func description(_ level: Int = 0) -> String {
        func match(_ item: Any?) -> String {
            if let value = item as? JSONDescription {
                return value.description(level + 1)
            }
            return "\(item ?? "<null>")"
        }
        let tab: String = "\t"
        let tabs = String(repeating: tab, count: level)
        let items = map({
            let key = match($0.key)
            let value = match($0.value)
            return "\(tabs)\(tab)\(key): \(value)"
        })
        return "{\n\(items.joined(separator: ",\n"))\n\(tabs)}"
    }
    
}

extension NSDictionary: JSONDescription {
    
    public func description(_ level: Int = 0) -> String {
        return (self as! [AnyHashable: Any]).description(level)
    }
    
}

extension Array: JSONDescription {
    
    public func description(_ level: Int = 0) -> String {
        func match(_ item: Any?) -> String {
            if let value = item as? JSONDescription {
                return value.description(level + 1)
            }
            return "\(item ?? "<null>")"
        }
        let tab: String = "\t"
        let tabs = String(repeating: tab, count: level)
        let items = map({
            let value = match($0)
            return "\(tabs)\(tab)\(value)"
        })
        return "[\n\(items.joined(separator: ",\n"))\n\(tabs)]"
    }
    
}

extension NSArray: JSONDescription {
    
    public func description(_ level: Int = 0) -> String {
        return (self as! [Any]).description(level)
    }
    
}

extension String: JSONDescription {
    
    public func description(_ level: Int = 0) -> String {
        return "\"\(self)\""
    }
    
}

extension NSString: JSONDescription {
    
    public func description(_ level: Int = 0) -> String {
        return "\"\(self)\""
    }
    
}
