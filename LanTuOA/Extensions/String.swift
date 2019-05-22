//
//  String.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//  String扩展

import UIKit

extension String {
    
    /// 获取文本宽高
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - maxSize: 最大尺寸
    /// - Returns: 文本宽高
    func getTextSize(font : UIFont , maxSize : CGSize) -> CGSize{
        return self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    /// 转md5
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        
        return hash.copy() as? String
    }
    
    /// 截取从from到尾部的部分
    func substring(_ from: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let subString = self[startIndex..<self.endIndex]
        return String(subString)
    }
    
    
    /// 加密手机号
    func encryptionPhoneNumber() -> String {
        let range = NSMakeRange(3, 4)
        return self.replacingCharacters(in: Range(range, in: self)!, with: "****")
    }
    
    
    /// 正则式是否成立
    ///
    /// - Parameter str: 正则式
    /// - Returns: 是否成立
    func isRegex(str: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@" ,str)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是纯中文
    func isRegexChinese() -> Bool {
        let predicateStr = "^[\\u4E00-\\u9FA5]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是手机号
    func isRegexMobile() -> Bool {
        let predicateStr = "^1(3[0-9]|4[5,7]|5[0-3,5-9]|7[3,5-8]|8[0-9]|66|98|99)\\d{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: self)
    }
    
    /// 是否是数字
    func isRegexNumber() -> Bool {
        let predicateStr = "^[1-9]\\d*|0$"
        let predicate = NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: self)
    }
    
    /// 判断是否是网址
    ///
    /// - Returns: 是否是网址
    func isRegexMac() -> Bool {
        let predicateStr = "([A-Fa-f0-9]{2}:){5}[A-Fa-f0-9]{2}"
        let predicate = NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: self)
    }
    
    /// 判断是否是数字（两位小数）
    ///
    /// - Returns: 是否是数字（两位小数）
    func isRegexDecimal() -> Bool {
//        ^[0-9]+(\.[0-9]{2})?$
        let predicateStr = "(^[1-9](\\d+)?([.]\\d{0,2})?$)|(^0$)|(^\\d[.]\\d{0,2}$)"
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: self)
    }
    
    /// NSRange转换为range
    ///
    /// - Parameter nsRange: range
    /// - Returns: range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length,
                                   limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    /// 获取时间戳(秒级)
    ///
    /// - Parameter customStr: 时间格式
    /// - Returns: 时间戳(秒级)
    func getTimeStamp(customStr: String) -> Int {
        let format = DateFormatter()
        format.dateFormat = customStr
        let timeDate = format.date(from: self)
        let timeStamp = Int(timeDate?.timeIntervalSince1970 ?? 0)
        return timeStamp
    }
    
    /// 获取金额
    ///
    /// - Returns: 返回带","的金额
    func getMoney() -> String {
        let strArray = components(separatedBy: ".") // 分割小数部分和整数部分
        let integerStr = strArray[0] // 必定有整数部分
        if integerStr.count == 0 {
            return ""
        }
        let integer = Int(integerStr) ?? 0
        var moneyStr = integer.getMoneyStr()
        if integerStr.count != count { // 长度不一样  有小数点
            moneyStr = moneyStr + "."
        }
        if strArray.count == 2 {
            moneyStr.append(strArray[1])
        }
        return moneyStr
    }
    
    /// 生成指定长度的字符串
    func randomStringWithLength(len: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 0..<len {
            let letterStr = letters.randomElement() ?? "a"
            randomString.append(letterStr)
        }
        return randomString
    }
}
