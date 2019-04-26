//
//  UIResponder.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

private weak var currentFirstResponder: AnyObject?

extension UIResponder {
    
    static func firstResponder() -> AnyObject? {
        currentFirstResponder = nil
        // 通过将target设置为nil，让系统自动遍历响应链
        // 从而响应链当前第一响应者响应我们自定义的方法
        UIApplication.shared.sendAction(#selector(findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return currentFirstResponder
    }
    
    @objc func findFirstResponder(_ sender: AnyObject) {
        // 第一响应者会响应这个方法，并且将静态变量currentFirstResponder设置为自己
        currentFirstResponder = self
    }
}
