//
//  UITextView.swift
//  DanJuanERP
//
//  Created by HYH on 2019/2/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

var placeHolderKey = 1121089799 // place的 ASCII 转十进制 （1121089799101） 溢出 去掉后3位

extension UITextView {
    /// 提示文本
    var placeHolderLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, &placeHolderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let label = objc_getAssociatedObject(self, &placeHolderKey)
            if !(label is UILabel) {
                self.placeHolderLabel = UILabel().taxi.adhere(toSuperView: self)
                    .taxi.layout(snapKitMaker: { (make) in
                        make.top.equalTo(self).offset(self.textContainerInset.top)
                        make.left.equalTo(self).offset(self.textContainer.lineFragmentPadding)
                        make.right.equalTo(self).offset(-self.textContainer.lineFragmentPadding)
                    })
                    .taxi.config({ (label) in
                        label.textColor = .lightGray
                        label.font = self.font
                    })
            }
            
            return objc_getAssociatedObject(self, &placeHolderKey) as? UILabel
        }
    }
}
