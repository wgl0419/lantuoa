//
//  SingleSeleTimeEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  单选时间 弹出框

import UIKit
import FSCalendar

class SingleSeleTimeEjectView: UIView {

    // 选中时间回调
    var seleBlock: ((String) -> ())?
    /// 标题数据
    var titleStr: String? {
        didSet {
            if let str = titleStr {
                titleLabel.text = str
            }
        }
    }
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// 选中时间
    private var timeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: ScreenBounds)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义公有方法
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
    private func initSubViews() {
        whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(300)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
            })
        
        let titleView = UIView().taxi.adhere(toSuperView: whiteView) // 标题背景图
            .taxi.layout { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(55)
        }
            .taxi.config { (view) in
                view.backgroundColor = UIColor(hex: "#F1F1F1")
        }
        
        titleLabel = UILabel().taxi.adhere(toSuperView: titleView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })

        timeLabel = UILabel().taxi.adhere(toSuperView: titleView) // 选中时间
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(titleLabel.snp.right).offset(5)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
                let time = Date().customTimeStr(customStr: "yyyy-MM-dd")
                label.text = time
            })
        
        _ = UIView().taxi.adhere(toSuperView: titleView) // 时间下滑线
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview()
                make.left.right.equalTo(timeLabel)
                make.height.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        let calendar = FSCalendar().taxi.adhere(toSuperView: whiteView) // 日历
            .taxi.layout { (make) in
                make.top.equalTo(titleView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(244)
        }
            .taxi.config { (calendar) in
                calendar.delegate = self
                calendar.backgroundColor = UIColor.white
                let locale = Locale(identifier: "zh_CN")
                calendar.locale = locale
                calendar.headerHeight = 0
                calendar.appearance.borderRadius = 1
                calendar.appearance.weekdayTextColor = blackColor
                calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
                calendar.select(Date())
        }
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(calendar.snp.bottom)
                make.left.bottom.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.setTitle("取消", for: .normal)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(calendar.snp.bottom)
                make.right.bottom.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(calendar.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(calendar.snp.bottom)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    /// 点击确定
    @objc private func determineClick() {
        if seleBlock != nil {
            seleBlock!(timeLabel.text ?? "")
        }
        hidden()
    }
}

extension SingleSeleTimeEjectView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        let dayStr = date.customTimeStr(customStr: "yyyy-MM-dd")
        timeLabel.text = dayStr
    }
}
