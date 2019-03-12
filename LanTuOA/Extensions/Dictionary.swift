//
//  Dictionary.swift
//  DanJuanERP
//
//  Created by HYH on 2019/1/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

extension Dictionary {
    
    /// 转换成json
    ///
    /// - Returns: json
    func toJSONString() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}


