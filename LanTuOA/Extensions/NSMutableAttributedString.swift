//
//  NSMutableAttributedString.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//  扩展富文本

import UIKit

extension NSMutableAttributedString {
    
    /// 设置行间距
    ///
    /// - Parameters:
    ///   - distance: 行间距
    ///   - alignment: 对其方式
    func addLineSpacing(distance: CGFloat, alignment: NSTextAlignment = .left) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = distance
        paragraphStyle.alignment = alignment
        self.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: self.length))
    }
    
    /// 修改制定文字的字体大小(只能修改文本中第一个的字体)
    func changeFont(str: String, font: UIFont) {
        let attriStr = self.string
        let range = attriStr.range(of: str)
        if range != nil {
            let nsRange = NSRange(range!, in: attriStr)
            self.addAttributes([NSAttributedString.Key.font : font], range: nsRange)
        }
    }
    
    /// 修改制定文字的颜色(只能修改文本中第一个的字体)
    func changeColor(str: String, color: UIColor) {
        let attriStr = self.string
        let range = attriStr.range(of: str)
        if range != nil {
            let nsRange = NSRange(range!, in: attriStr)
            self.addAttributes([NSAttributedString.Key.foregroundColor: color], range: nsRange)
        }
    }
    
    /// 修改制定文字的颜色
    func changeColor(range: NSRange, color: UIColor) {
        self.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
    }
    
    /// 添加下滑线
    ///
    /// - Parameter color: 下滑线颜色
    /// - Parameter range: 下划线位置
    func addUnderline(color: UIColor, range: NSRange) {
        let arrributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : color,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        self.addAttributes(arrributes, range: range)
    }
    
    /// 添加删除线
    ///
    /// - Parameter color: 删除线颜色
    /// - Parameter range: 删除线位置
    func addRtrikeline(color: UIColor, range: NSRange) {
        var arrributes: [NSAttributedString.Key : Any]
        if #available(iOS 11.0, *) {
            arrributes = [
                NSAttributedString.Key.foregroundColor : color,
                NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue
            ]
        } else {
            arrributes = [
                NSAttributedString.Key.foregroundColor : color,
                NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.baselineOffset : 0]
        }
        self.addAttributes(arrributes, range: range)
    }
    
    /// 获取文本宽高
    ///
    /// - Parameters:
    ///   - maxSize: 最大尺寸
    /// - Returns: 文本宽高
    func getRect(maxSize : CGSize) -> CGRect{
        return self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
    }
}
