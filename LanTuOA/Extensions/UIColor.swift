//
//  UIColor.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//  UIColor扩展

import UIKit

extension UIColor {
    
    /// 自定义颜色
    ///
    /// - Parameters:
    ///   - r: 红色值
    ///   - g: 绿色值
    ///   - b: 蓝色值
    ///   - alpha: 透明值
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        if #available(iOS 10.0, *) {
            self.init(displayP3Red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
        } else {
            self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha:alpha)
        }
    }
    
    
    /// 根据十六进制获取颜色（透明值为1）
    ///
    /// - Parameter hex: 颜色的十六进制
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    
    /// 根据十六进制获取颜色（可修改透明值）
    ///
    /// - Parameters:
    ///   - hex: 颜色的十六进制
    ///   - alpha: 透明值
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        if #available(iOS 10.0, *) {
            self.init(displayP3Red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
        } else {
            self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
        }
    }
    
    /// 获取随机颜色
    ///
    /// - Returns: 返回随机颜色
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha:1.0)
    }
}
