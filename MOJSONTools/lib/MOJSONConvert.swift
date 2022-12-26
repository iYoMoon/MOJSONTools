//
//  MOJSONConvert.swift
//  MOJSONTools
//
//  Created by Moon on 2022/12/22.
//

import Foundation
import AppKit

fileprivate struct Model {
    var name: String?
    var data: [String: Any]
}

public class MOJSONConvert {
    
    public enum Language {
        case oc
        case swift
    }
    
    public var stype: String = ""
    public var prefix: String = ""
    public var suffix: String = ""
    public var className: String?
    public var superName: String?
    public var sort: Bool = true
    public var note: Bool = false
    public var optional: Bool = true
    public var language: Language = .swift
    
    private var dictionarys: [Model] = []
    
}

public extension MOJSONConvert {
    
    func description(_ item: Any?, call: (String) -> Void) {
        dictionarys.removeAll()
        find(name: className, item: item)
        handle(item, call: call)
    }
    
}

private extension MOJSONConvert {
    
    func find(name: String?, item: Any?) {
        if let item = item as? [String: Any], !item.keys.isEmpty {
            var model = Model(data: item)
            if let name = name {
                model.name = name
            }
            dictionarys.insert(model, at: 0)
            item.forEach({ find(name: $0.key, item: $0.value) })
        } else if let item = item as? [Any] {
            find(name: name, item: item.first)
        }
    }
    
    private func property(_ key: String, value: Any?, array: Bool = false) -> String {
        guard let value = value else {
            return "\tvar \(key): <#Any#>?\n"
        }
        let left = array ? "[" : ""
        let right = array ? "]" : ""
        var result: String = ""
        
        func def(_ at: Int, name: String = "") -> String {
            switch at {
                case 1: return optional ? "?" : " = \(array ? "[]" : "false")"
                case 2: return optional ? "?" : " = \(array ? "[]" : "0")"
                case 3: return optional ? "?" : " = \(array ? "[]" : "0.0")"
                case 4: return optional ? "?" : " = \(array ? "[]" : "\"\"")"
                case 5: return optional ? "?" : " = \(array ? "[]" : "\(name)()")"
                default: return ""
            }
        }
        
        if type(of: value) == NSClassFromString("__NSCFBoolean") {
            result += "\tvar \(key): \(left)Bool\(right)\(def(1))\n"
        } else if let _ = value as? Int {
            result += "\tvar \(key): \(left)Int\(right)\(def(2))\n"
        } else if let _ = value as? Double {
            result += "\tvar \(key): \(left)Double\(right)\(def(3))\n"
        } else if let _ = value as? String {
            result += "\tvar \(key): \(left)String\(right)\(def(4))\n"
        } else if let value = value as? [String: Any], !value.keys.isEmpty {
            let sClass = prefix + key.uppercased(at: 0) + suffix
            result += "\tvar \(key): \(left)\(sClass)\(right)\(def(5,name: sClass))\n"
        } else if let value = value as? [Any] {
            result += property(key, value: value.first, array: true)
        } else {
            result += "\tvar \(key): \(left)<#Any#>\(right)?\n"
        }
        return result
    }
    
    func handle(_ item: Any?, call: (String) -> Void) {
        var array: [Model] = []
        for dictionary in dictionarys {
            if !array.contains(where: {dictionary.name == $0.name && dictionary.data.keys == $0.data.keys}) {
                array.append(dictionary)
            }
        }
        
        var result: String = "\n"
        array.forEach { model in
            var name: String = "<#ClassName#>"
            if let value = model.name {
                name = prefix + value.uppercased(at: 0) + suffix
            }
            var sName: String = ""
            if let superName = superName, !superName.isEmpty {
                sName = ": " + superName
            }
            if note { result += "/// <#Description#>\n" }
            result += "\(stype) \(name)\(sName) {\n"
            if sort {
                model.data.sorted(by: {$0.key < $1.key}).forEach {
                    if note { result += "\t/// <#Description#>\n" }
                    result += property($0.key, value: $0.value)
                }
            } else {
                model.data.forEach {
                    if note { result += "\t/// <#Description#>\n" }
                    result += property($0.key, value: $0.value)
                }
            }
            result += "}\n\n"
        }
        
        call(result)
    }
    
}
