//
//  UIFont.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//  UIFont 扩展

import UIKit

extension UIFont {
    
    class func medium(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: "PingFangSC-Medium", size: size)!
        } else {
            return UIFont(name: "STHeitiSC-Medium", size: size)!
        }
    }
    
    class func regular(size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: "PingFangSC-regular", size: size)!
        } else {
            return UIFont(name: "STHeitiK-Light", size: size)!
        }
    }
}
