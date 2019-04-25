//
//  UiView.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import SnapKit
import YYText

extension UIView: NamespaceWrappable { }
extension NamespaceWrapper where T: UIView {
    
    public func adhere(toSuperView: UIView) -> T {
        toSuperView.addSubview(wrappedValue)
        return wrappedValue
    }
    
    @discardableResult
    public func layout(snapKitMaker: (ConstraintMaker) -> Void) -> T {
        wrappedValue.snp.makeConstraints { (make) in
            snapKitMaker(make)
        }
        return wrappedValue
    }
    
    @discardableResult
    public func config(_ config: (T) -> Void) -> T {
        config(wrappedValue)
        return wrappedValue
    }
}

extension UIView {
    /// 裁剪 view 的圆角
    func clipRectCorner(_ direction: UIRectCorner, cornerRadius: CGFloat) {
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.addSublayer(maskLayer)
        layer.mask = maskLayer
    }
    
    /**
     移除所有子控件
     */
    func removeAllSubviews() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    func removeByTag(tag: Int) {
        subviews.forEach { (view) in
            if view.tag == tag {
                view.removeFromSuperview()
            }
        }
    }
    
    /// x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    /// size
    var size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y = newValue
            center = tempCenter;
        }
    }
    
    
    enum ShakeDirection: Int
    {
        case horizontal
        case vertical
    }
    // MARK: 扩展UIView,增加抖动方法
    ///
    /// - Parameters:
    ///   - direction: 抖动方向（默认是水平方向）
    ///   - times: 抖动次数（默认5次）
    ///   - interval: 每次抖动时间（默认0.1秒）
    ///   - delta: 抖动偏移量（默认2）
    ///   - completion: 抖动动画结束后的回调
    func shake(direction: ShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, delta: CGFloat = 2, completion: (() -> Void)? = nil)
    {
        UIView.animate(withDuration: interval, animations: {
            
            switch direction
            {
            case .horizontal:
                self.layer.setAffineTransform(CGAffineTransform(translationX: delta, y: 0))
            case .vertical:
                self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: delta))
            }
        }) { (finish) in
            
            if times == 0
            {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (finish) in
                    completion?()
                })
            }
            else
            {
                self.shake(direction: direction, times: times - 1, interval: interval, delta: -delta, completion: completion)
            }
        }
    }
}

var noDataKey = 100
var noDataImageViewKey = 101
var noDataLabelKey = 102
var redDotKey = 103
var showRedDotKey = 104

extension UIView {
    
    /// 是否显示无数据
    var isNoData: Bool {
        set {
            self.noDataImageView?.isHidden = !newValue
            self.noDataLabel?.isHidden = !newValue
            objc_setAssociatedObject(self, &noDataKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &noDataKey) as? Bool {
                self.noDataImageView?.isHidden = !rs
                self.noDataLabel?.isHidden = !rs
                return rs
            }
            return false
        }
    }
    
    /// 无数据图片
    var noDataImageView: UIImageView? {
        set {
            objc_setAssociatedObject(self, &noDataImageViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let imageView = objc_getAssociatedObject(self, &noDataImageViewKey)
            if !(imageView is UIImageView) {
                self.noDataImageView = UIImageView().taxi.adhere(toSuperView: self)
                    .taxi.layout(snapKitMaker: { (make) in
                        make.centerX.equalToSuperview()
                        make.bottom.equalTo(self.snp.centerY).offset(-55 + spacing * 2)
                    })
                    .taxi.config({ (imageView) in
                        imageView.isHidden = true
                    })
            }
            return objc_getAssociatedObject(self, &noDataImageViewKey) as? UIImageView
        }
    }
    
    /// 无数据文本提示
    var noDataLabel: YYLabel? {
        set {
            objc_setAssociatedObject(self, &noDataLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let label = objc_getAssociatedObject(self, &noDataLabelKey)
            if !(label is YYLabel) {
                self.noDataLabel = YYLabel().taxi.adhere(toSuperView: self)
                    .taxi.layout(snapKitMaker: { (make) in
                        make.centerX.equalToSuperview()
                        make.bottom.equalTo(self.snp.centerY)
                    })
                    .taxi.config({ (label) in
                        label.isHidden = true
                        label.textAlignment = .center
                        label.textColor = UIColor(hex: "#666666")
                        label.font = UIFont.regular(size: 15)
                    })
            }
            
            return objc_getAssociatedObject(self, &noDataLabelKey) as? YYLabel
        }
    }
    
    /// 右上角的红点
    var redDot: UIView? {
        set {
            objc_setAssociatedObject(self, &redDotKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let view = objc_getAssociatedObject(self, &redDotKey)
            if !(view is UIView) {
                self.redDot = UIView().taxi.adhere(toSuperView: self)
                    .taxi.layout(snapKitMaker: { (make) in
                        make.centerX.equalTo(self.snp.right)
                        make.centerY.equalTo(self.snp.top)
                        make.width.height.equalTo(8)
                    })
                    .taxi.config({ (view) in
                        view.backgroundColor = .red
                        view.layer.cornerRadius = 4
                        view.layer.masksToBounds = true
                    })
            }
            return objc_getAssociatedObject(self, &redDotKey) as? UIView
        }
    }
    
    /// 是否显示无数据
    var isShowRedDot: Bool {
        set {
            self.redDot?.isHidden = !newValue
            objc_setAssociatedObject(self, &showRedDotKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &showRedDotKey) as? Bool {
                return rs
            }
            return false
        }
    }
}
