//
//  UITabBar.swift
//  DanJuanERP
//
//  Created by HYH on 2019/2/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

extension UITabBar {
    func showBadgeOnItem(index:Int, count:Int) {
        removeBadgeOnItem(index: index)
        let bview = UIView.init()
        bview.tag = 888+index
        bview.layer.cornerRadius = 9
        bview.clipsToBounds = true
        bview.backgroundColor = UIColor.red
        let tabFrame = self.frame
        
        let percentX = (Float(index)+0.6) / 4
        let x = CGFloat(ceilf(percentX*Float(tabFrame.width)))
        let y = CGFloat(ceilf(0.1*Float(tabFrame.height)))
        bview.frame = CGRect(x: x, y: y, width: 18, height: 18)
        
        let cLabel = UILabel.init()
        cLabel.text = "\(count)"
        cLabel.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        cLabel.font = UIFont.systemFont(ofSize: 10)
        cLabel.textColor = UIColor.white
        cLabel.textAlignment = .center
        bview.addSubview(cLabel)
        
        addSubview(bview)
        bringSubviewToFront(bview)
    }
    //隐藏红点
    func hideBadgeOnItem(index:Int) {
        removeBadgeOnItem(index: index)
    }
    //移除控件
    func removeBadgeOnItem(index:Int) {
        for subView:UIView in subviews {
            if subView.tag == 888+index {
                subView.removeFromSuperview()
            }
        }
    }
}
