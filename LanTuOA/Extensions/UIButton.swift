//
//  UIButton.swift
//  DanJuanERP
//
//  Created by HYH on 2019/1/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  按钮扩展

import UIKit

extension UIButton {
    /// 设置按钮文字在图片下面
    ///
    /// - Parameter spacing: 图片和文字的间距（默认为2）
    func setSpacing(spacing: CGFloat = 2) {
        let originalSpacing = 2 // 原本的间隔
        let imageSize : CGSize = (self.imageView?.frame.size)!
        var titleSize : CGSize = (self.titleLabel?.frame.size)!
        let textMaxSize : CGSize = CGSize(width: self.width - 5, height: CGFloat(MAXFLOAT))
        let textSize : CGSize = (self.titleLabel?.text ?? "").getTextSize(font: (self.titleLabel?.font)!, maxSize: textMaxSize)
        let frameSize : CGSize = CGSize.init(width: Int(ceilf(Float(textSize.width))), height: Int(ceilf(Float(textSize.height))))
        
        if titleSize.width + 0.5 < frameSize.width {
            titleSize.width = frameSize.width
        }
        let totalHeight = imageSize.height + titleSize.height + CGFloat(spacing)
        
        self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height), left: CGFloat(originalSpacing), bottom: CGFloat(originalSpacing), right: -titleSize.width)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0);
    }
}

