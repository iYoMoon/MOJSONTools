//
//  ViewController.swift
//  MOJSONTools
//
//  Created by Moon on 2022/12/22.
//

import Cocoa

public func MOLog(_ items: Any?..., file: String = #file, line: Int = #line) {
    
    func logs() -> String {
        var log: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        let time = dateFormatter.string(from: Date())
        log += "========================== \(time) ==========================\n"
        log += "文件: <\(file.components(separatedBy: "/").last ?? "")>,  行号: (\(line)),\n"
        let logs = items.map({
            if let value = $0 as? JSONDescription {
                return value.jsonDescription
            }
            return "\($0 ?? "<null>")"
        })
        log += logs.joined(separator: ",\n")
        log += "\n=============================================================================\n\n"
        return log
    }
    
    let log = logs()
    
#if DEBUG
    print(log)
#endif
    
}

class ViewController: NSViewController {

    @IBOutlet var leftTextView: NSTextView! {
        didSet {
            leftTextView.font = .systemFont(ofSize: 18)
        }
    }
    
    @IBOutlet var rightTextView: NSTextView! {
        didSet {
            rightTextView.font = .systemFont(ofSize: 18)
        }
    }
    
    @IBOutlet weak var prefixTF: NSTextField!
    @IBOutlet weak var fatherTF: NSTextField!
    @IBOutlet weak var suffixTF: NSTextField!
    @IBOutlet weak var comboBox: NSComboBox!
    @IBOutlet weak var noteBtn: NSButton!
    @IBOutlet weak var opBtn: NSButton!
    @IBOutlet weak var sortBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
//        leftTextView.string =
//"""
//{
//    "appVersion": "3.0.4",
//    "code": 200,
//    "msg": "success",
//    "double": 1.20,
//    "success": true,
//    "array": [true],
//    "hun": [
//        true,
//        {
//            "msg": "success",
//        }
//    ],
//    "data": {
//        "totalOnlineTimeRemark": "高于同行0%",
//        "averageMatchNumRemark": "低于同行100%",
//        "totalMatchNum": 0,
//        "communicateNum": 0,
//        "averageMatchNum": 0
//    }
//}
//"""
        
        
    }

    var convert = MOJSONConvert()
    
    @IBAction func toModel_click(_ sender: NSButton) {
        jsonObject()
    }
    
    func jsonObject() {
        guard let data = leftTextView.string.data(using: .utf8) else { return }
        do {
            let any = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            
            if let any = any as? JSONDescription {
                leftTextView.string = any.jsonDescription
            }
            
            
            convert.prefix = prefixTF.stringValue
            convert.superName = fatherTF.stringValue
            convert.suffix = suffixTF.stringValue
            convert.stype = comboBox.stringValue
            convert.note = (noteBtn.state == .on) ? true : false
            convert.sort = (sortBtn.state == .on) ? true : false
            convert.optional = (opBtn.state == .on) ? true : false
            convert.description(any) { string in
                rightTextView.string = string
            }
            
        } catch  {
            MOLog(error)
            rightTextView.string = (error as NSError).debugDescription
            return
        }
    }
    
}

