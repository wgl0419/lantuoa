//
//  SeleTimeEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/5.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  选择时间（系统控件）  弹出框

import UIKit

class SeleTimeEjectView: UIView {

    /// 点击确定
    var determineBlock: ((Int) -> ())?
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// 确定按钮
    private var determineBtn: UIButton!
    /// 时间控件
    private var datePicker: UIDatePicker!
    
    
    // MAKR: - 自定义公有方法
    /// 自定义初始化 (已经选择的时时间戳   标题)
    convenience init(timeStamp: Int?, titleStr: String) {
        self.init(frame: ScreenBounds)
        initSubViews(timeStamp: timeStamp)
        titleLabel.text = titleStr
    }
    
    /// 弹出
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(hex: "#000000", alpha: 0.5)
        }
    }
    
    /// 隐藏
    @objc func hidden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = .clear
            self.removeAllSubviews()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews(timeStamp: Int?) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidden))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : -8)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(50)
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "选择开始时间:"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        determineBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(titleLabel)
                make.right.equalToSuperview().offset(-10)
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        datePicker = UIDatePicker().taxi.adhere(toSuperView: whiteView) // 时间选择器
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
            })
            .taxi.config({ (datePicker) in
                datePicker.locale = Locale(identifier: "zh")
                datePicker.datePickerMode = .date
                if timeStamp != nil {
                    datePicker.setDate(Date(timeIntervalSince1970: TimeInterval(timeStamp!)), animated: true)
                }
            })
    }
    
    // MARK: - 按钮点击
    /// 点击确定
    @objc private func determineClick() {
        if determineBlock != nil {
            let timeStamp = Int(datePicker.date.timeIntervalSince1970)
            determineBlock!(timeStamp)
        }
        hidden()
    }
}

extension SeleTimeEjectView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        let whiteViewFrame = whiteView.convert(whiteView.bounds, to: self)
        if whiteViewFrame.contains(touchPoint) {
            return false
        } else {
            return true
        }
    }
}
