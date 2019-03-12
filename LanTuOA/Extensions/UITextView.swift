//
//  UITextView.swift
//  DanJuanERP
//
//  Created by HYH on 2019/2/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

//class PTextView: UITextView {
//    //存储属性，存放placeHolder内容
//    var placeHolder: String? = "" {
//        //属性观察者
//        didSet {
//            if self.text == "" {
//                self.text = placeHolder
//                self.textColor = .lightGray
//            }
//        }
//    }
//
//
//    //监听事件，根据文本框内容改变文字及颜色
//    override func becomeFirstResponder() -> Bool {
//        if self.text == placeHolder||self.text == "" {
//            self.text = ""
//            self.textColor = .black
//        }
//        return super.becomeFirstResponder()
//    }
//
//    override func resignFirstResponder() -> Bool {
//        text = self.text.replacingOccurrences(of: " ", with: "")
//        if text == "" {
//            self.text = placeHolder
//            self.textColor = .lightGray
//        }
//        return super.resignFirstResponder()
//    }
//}

var placeHolderKey = 1121089799101 // place的 ASCII 转十进制

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
