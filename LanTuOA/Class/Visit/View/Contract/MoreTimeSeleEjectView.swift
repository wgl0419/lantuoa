//
//  MoreTimeSeleEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  多时间选择 弹框

import UIKit
import FSCalendar

class MoreTimeSeleEjectView: UIView {
    
    /// 选择回调
    var seleBlock: ((Int, Int) -> ())?
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 填充时间空间的滚动视图
    private var scrollView: UIScrollView!
    /// 开始时间按钮
    private var startBtn: UIButton!
    /// 结束时间按钮
    private var endBtn: UIButton!
    /// 滑杆
    private var slideView: UIView!
    /// 开始时间
    private var startCalendar: FSCalendar!
    /// 结束时间
    private var endCalendar: FSCalendar!

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
                make.width.equalTo(300)
                make.center.equalToSuperview()
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
            })
        
        let segmentView = setSegmentView()
        setScrollView(segmentView: segmentView)
        
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(scrollView.snp.bottom)
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
                make.top.equalTo(scrollView.snp.bottom)
                make.right.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(scrollView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.centerX.equalToSuperview()
                make.height.equalTo(55)
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
    }
    
    /// 设置选择器
    private func setSegmentView() -> UIView {
        let segmentView = UIView().taxi.adhere(toSuperView: whiteView) // 填充开始结束按钮视图
            .taxi.layout { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(44)
            }
            .taxi.config { (view) in
                view.backgroundColor = UIColor(hex: "#F1F1F1")
        }
        
        let dayStr = Date().customTimeStr(customStr: "yyyy-MM-dd")
        
        startBtn = UIButton().taxi.adhere(toSuperView: segmentView) // 开始按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.isSelected = true
                btn.setTitle(dayStr, for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#2E4695"), for: .selected)
                btn.addTarget(self, action: #selector(timeClick(btn:)), for: .touchUpInside)
            })
        
        slideView = UIView().taxi.adhere(toSuperView: segmentView) // 滑杆
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalTo(startBtn)
                make.bottom.equalToSuperview()
                make.height.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        let toLabel = UILabel().taxi.adhere(toSuperView: segmentView) // ”至“
            .taxi.layout { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(startBtn.snp.right).offset(10)
        }
            .taxi.config { (label) in
                label.text = "至"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        endBtn = UIButton().taxi.adhere(toSuperView: segmentView) // 结束按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(toLabel.snp.right).offset(10)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle(dayStr, for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#2E4695"), for: .selected)
                btn.addTarget(self, action: #selector(timeClick(btn:)), for: .touchUpInside)
            })
        
        return segmentView
    }
    
    /// 设置滚动视图
    private func setScrollView(segmentView: UIView) {
        scrollView = UIScrollView().taxi.adhere(toSuperView: whiteView) // 填装日历控件的滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(slideView.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(226)
            })
            .taxi.config({ (scrollView) in
                scrollView.bounces = false
//                scrollView.delegate = self
                scrollView.isPagingEnabled = true
                scrollView.backgroundColor = .white
                scrollView.showsHorizontalScrollIndicator = false
            })
        
        startCalendar = FSCalendar().taxi.adhere(toSuperView: scrollView) // 日历
            .taxi.layout(snapKitMaker: { (make) in
                make.left.width.equalToSuperview()
                make.top.equalToSuperview().offset(10)
                make.height.equalToSuperview().offset(-5)
            })
            .taxi.config({ (calendar) in
                calendar.delegate = self
                calendar.backgroundColor = UIColor.white
                let locale = Locale(identifier: "zh_CN")
                calendar.locale = locale
                calendar.headerHeight = 0
                calendar.appearance.borderRadius = 1
                calendar.appearance.weekdayTextColor = blackColor
                calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
                calendar.select(Date())
            })
        
        endCalendar = FSCalendar().taxi.adhere(toSuperView: scrollView) // 日历
            .taxi.layout(snapKitMaker: { (make) in
                make.right.width.equalToSuperview()
                make.top.equalToSuperview().offset(10)
                make.height.equalToSuperview().offset(-5)
                make.left.equalTo(startCalendar.snp.right)
            })
            .taxi.config({ (calendar) in
                calendar.delegate = self
                calendar.backgroundColor = UIColor.white
                let locale = Locale(identifier: "zh_CN")
                calendar.locale = locale
                calendar.headerHeight = 0
                calendar.appearance.borderRadius = 1
                calendar.appearance.weekdayTextColor = blackColor
                calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
                calendar.select(Date())
            })
    }
    
    // MARK: - 按钮点击
    /// 点击选中时间
    @objc private func timeClick(btn: UIButton) {
        scrollView.setContentOffset(CGPoint(x: btn == startBtn ? 0 : scrollView.width, y: 0), animated: true)
        if btn == startBtn {
            startBtn.isSelected = true
            endBtn.isSelected = false
        } else {
            startBtn.isSelected = false
            endBtn.isSelected = true
        }
        
        UIView.animate(withDuration: 0.25) {
            self.slideView.snp.remakeConstraints({ (make) in
                make.left.right.equalTo(btn)
                make.bottom.equalToSuperview()
                make.height.equalTo(2)
            })
            self.layoutIfNeeded()
        }
    }
    
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    /// 点击确定
    @objc private func determineClick() {
        if seleBlock != nil {
            let dayStr = Date().customTimeStr(customStr: "yyyy-MM-dd")
            var startStr = startBtn.title(for: .normal) ?? dayStr
            startStr.append(" 00:00:00")
            var endStr = endBtn.title(for: .normal) ?? dayStr
            endStr.append(" 23:59:50")
            
            
            let start = startStr.getTimeStamp(customStr: "yyyy-MM-dd HH:mm:ss")
            let end = endStr.getTimeStamp(customStr: "yyyy-MM-dd HH:mm:ss")
            seleBlock!(start, end)
        }
        hidden()
    }
}


extension MoreTimeSeleEjectView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        let dayStr = date.customTimeStr(customStr: "yyyy-MM-dd")
        if calendar == startCalendar {
            startBtn.setTitle(dayStr, for: .normal)
        } else {
            endBtn.setTitle(dayStr, for: .normal)
        }
    }
}
