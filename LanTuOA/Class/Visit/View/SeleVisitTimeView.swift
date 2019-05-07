//
//  SeleVisitTimeView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/19.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  选择拜访时间  视图

import UIKit
import SnapKit
import FSCalendar

class SeleVisitTimeView: UIView {
    
    /// 选中时间回调
    var seleBlock: ((String) -> ())?

    /// 灰色背景
    private var grayView: UIView!
    /// "年月日"按钮
    private var dayBtn: UIButton!
    /// “时分”按钮
    private var timeBtn: UIButton!
    /// 滑杆
    private var slideView: UIView!
    /// 填充日历 和 时间选择器的滚动视图
    private var scrollView: UIScrollView!
    /// 日历 控件
    private var calendar: FSCalendar!
    /// 时间选择器
    private var datePicker: UIDatePicker!
    /// 确定按钮
    private var determineBtn: UIButton!
    
    
    /// “年月日”约束
    private var dayConstraint: Constraint!
    /// “时分”约束
    private var timeConstraint: Constraint!
    
    convenience init(limit: Bool) {
        self.init(frame: ScreenBounds)
        initSubViews(limit: limit)
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
    private func initSubViews(limit: Bool) {
        
        grayView = UIView().taxi.adhere(toSuperView: self) // 灰色背景图
            .taxi.layout(snapKitMaker: { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(300)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
                view.backgroundColor = UIColor(hex: "#F1F1F1")
            })
        
        let dayStr = Date().customTimeStr(customStr: "yyyy-MM-dd")
        dayBtn = UIButton().taxi.adhere(toSuperView: grayView) // "年月日"按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.isSelected = true
                btn.setTitle(dayStr, for: .normal)
                btn.setTitleColor(blackColor, for: .selected)
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.addTarget(self, action: #selector(dayClick), for: .touchUpInside)
            })
        
        let timeStr = Date().dayTimeStr()
        timeBtn = UIButton().taxi.adhere(toSuperView: grayView) // “时分” 按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(dayBtn.snp.right).offset(10)
                make.top.bottom.equalTo(dayBtn)
            })
            .taxi.config({ (btn) in
                btn.setTitle(timeStr, for: .normal)
                btn.setTitleColor(blackColor, for: .selected)
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.addTarget(self, action: #selector(timeClick), for: .touchUpInside)
            })
        
        slideView = UIView().taxi.adhere(toSuperView: grayView) // 滑杆
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(2)
                make.bottom.equalTo(dayBtn)
                dayConstraint = make.left.right.equalTo(dayBtn).priority(800).constraint
                timeConstraint = make.left.right.equalTo(timeBtn).priority(800).constraint
            })
            .taxi.config({ (view) in
                dayConstraint.activate()
                timeConstraint.deactivate()
                view.backgroundColor = blackColor
            })
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: grayView) // 填充日历 和 时间选择器的滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(slideView.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(226)
            })
            .taxi.config({ (scrollView) in
                scrollView.bounces = false
                scrollView.delegate = self
                scrollView.isPagingEnabled = true
                scrollView.backgroundColor = .white
                scrollView.showsHorizontalScrollIndicator = false
            })
        
        calendar = FSCalendar().taxi.adhere(toSuperView: scrollView) // 日历
            .taxi.layout(snapKitMaker: { (make) in
                make.left.width.equalToSuperview()
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-5)
            })
            .taxi.config({ (calendar) in
                if limit {
                    calendar.dataSource = self
                }
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
        
        
        datePicker = UIDatePicker().taxi.adhere(toSuperView: scrollView) // 时间选择器
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(calendar.snp.right)
                make.top.right.bottom.width.equalToSuperview()
            })
            .taxi.config({ (datePicker) in
                if limit {
                    datePicker.maximumDate = Date()
                }
                datePicker.datePickerMode = .time
                datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: grayView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(56)
                make.left.bottom.equalToSuperview()
                make.top.equalTo(scrollView.snp.bottom)
                make.width.equalToSuperview().dividedBy(2).priority(800)
            })
            .taxi.config({ (btn) in
                btn.backgroundColor = .white
                btn.setTitle("取消", for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        determineBtn = UIButton().taxi.adhere(toSuperView: grayView) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(56)
                make.right.bottom.equalToSuperview()
                make.top.equalTo(scrollView.snp.bottom)
                make.width.equalToSuperview().dividedBy(2).priority(800)
            })
            .taxi.config({ (btn) in
                btn.backgroundColor = .white
                btn.setTitle("确定", for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: grayView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.top.equalTo(determineBtn)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIView().taxi.adhere(toSuperView: grayView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(1)
                make.height.equalTo(determineBtn)
                make.top.bottom.left.equalTo(determineBtn)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
    }
    
    /// MARK: - 通知
    @objc private func dateChange() {
        let timeStr = datePicker.date.dayTimeStr()
        timeBtn.setTitle(timeStr, for: .normal)
    }
    
    // MARK: - 按钮点击
    /// 点击 “年月日”
    @objc private func dayClick() {
        if timeConstraint.isActive {
            UIView.animate(withDuration: 0.25) {
                self.dayBtn.isSelected = true
                self.dayConstraint.activate()
                self.timeBtn.isSelected = false
                self.timeConstraint.deactivate()
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                self.layoutIfNeeded()
            }
        }
    }
    
    /// 点击“时分”
    @objc private func timeClick() {
        if dayConstraint.isActive {
            UIView.animate(withDuration: 0.25) {
                self.timeBtn.isSelected = true
                self.timeConstraint.activate()
                self.dayBtn.isSelected = false
                self.dayConstraint.deactivate()
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.width, y: 0), animated: true)
                self.layoutIfNeeded()
            }
        }
    }
    
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    /// 点击确定
    @objc private func determineClick() {
        if seleBlock != nil {
            let dayStr = dayBtn.titleLabel?.text ?? ""
            let timeStr = timeBtn.titleLabel?.text ?? ""
            seleBlock!("\(dayStr) \(timeStr)")
        }
        hidden()
    }
}


extension SeleVisitTimeView: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        let dayStr = date.customTimeStr(customStr: "yyyy-MM-dd")
        dayBtn.setTitle(dayStr, for: .normal)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}

extension SeleVisitTimeView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // 监听快速滑动，惯性慢慢停止
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            let page = Int(scrollView.contentOffset.x / scrollView.width)
            if page == 0 {
                dayClick()
            } else {
                timeClick()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { // 手指控制直接停止
        if !decelerate {
            let dragToDragStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if dragToDragStop {
                let page = Int(scrollView.contentOffset.x / scrollView.width)
                if page == 0 {
                    dayClick()
                } else {
                    timeClick()
                }
            }
        }
    }
}
