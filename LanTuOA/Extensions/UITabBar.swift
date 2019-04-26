//
//  UITabBar.swift
//  DanJuanERP
//
//  Created by HYH on 2019/2/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

extension UITabBar {
    
    
    /// 显示红点
    ///
    /// - Parameter index: 第几个tabbar
    func showBadgeOnItemIndex(index: Int) {
        /// 删除原有小红点
        hideBadgeOnItemIndex(index: index)
        
        // 新建小红点
        let badgeView = UIView()
        badgeView.tag = 888 + index
        badgeView.layer.cornerRadius = 5
        badgeView.layer.masksToBounds = true
        let tabFrame = frame
        
        // 确定小红点位置
        let percentX: CGFloat = (CGFloat(index) + 0.6) / 5 // 5为tabbar数量
        let X: CGFloat = CGFloat(ceilf(Float(percentX * tabFrame.size.width)))
        let Y: CGFloat = CGFloat(ceilf(Float(0.1 * tabFrame.size.height)))
        badgeView.frame = CGRect(x: X, y: Y, width: 10, height: 10) // 红点宽高为10
        badgeView.backgroundColor = .red
        addSubview(badgeView)
    }
    
    /// 隐藏红点
    ///
    /// - Parameter index: 第几个tabbar
    func hideBadgeOnItemIndex(index: Int) {
        removeByTag(tag: 888 + index)
    }
}
