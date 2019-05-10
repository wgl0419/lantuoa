//
//  ProjectDetailsSegmentedView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情 选择器控件

import UIKit

class ProjectDetailsSegmentedView: UIView {

    /// 修改回调 (选中按钮位置)
    var changeBlock:((Int) -> ())?
    /// 默认选择第几个(默认第一个)
    var seleIndex = 0
    
    /// 滚动视图
    private var scrollView: UIScrollView!
    /// 滑杆
    private var slideView: UIView!
    
    /// 标记选中的按钮tag
    private var seleTag = 100
    /// 记录按钮数组
    private var btnArray = [UIButton]()
    
    convenience init(title: [String]) {
        self.init()
        initSubViews(titleArray: title)
    }
    
    /// 修改显示按钮
    func changeBtn(page: Int) {
        let btn = self.viewWithTag(page + 100) as! UIButton
        btnChange(btn: btn)
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews(titleArray: [String]) {
        backgroundColor = .white
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: self) // 滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(40).priority(800)
            })
        
        var lastBtn: UIButton!
        for index in 0..<titleArray.count {
            let title = titleArray[index]
            let btn = UIButton().taxi.adhere(toSuperView: scrollView)
                .taxi.layout { (make) in
                    if index == 0 {
                        make.left.equalToSuperview().offset(15)
                    } else {
                        make.left.equalTo(lastBtn.snp.right).offset(15)
                    }
                    if index == titleArray.count - 1 {
                        make.right.equalToSuperview().offset(-15)
                    }
                    make.height.equalTo(40).priority(800)
                    make.top.bottom.equalToSuperview()
            }
                .taxi.config { (btn) in
                    btn.tag = index + 100
                    btn.isSelected = lastBtn == nil
                    btn.setTitle(title, for: .normal)
                    btn.titleLabel?.font = UIFont.medium(size: 14)
                    btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                    btn.setTitleColor(UIColor(hex: "#2E4695"), for: .selected)
                    btn.setTitleColor(UIColor(hex: "#2E4695"), for: .highlighted)
                    btn.addTarget(self, action: #selector(optionClick(btn:)), for: .touchUpInside)
            }
            lastBtn = btn
            btnArray.append(btn)
        }
        
        slideView = UIView().taxi.adhere(toSuperView: scrollView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(3)
                make.bottom.equalToSuperview()
                make.left.width.equalTo(btnArray[seleIndex])
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        _ = UIView().taxi.adhere(toSuperView: self) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
    }
    
    /// 按钮动效处理
    private func btnAnimateHandle(btn: UIButton) {
        let btnFrame = btn.convert(btn.bounds, to: self)
        
        if btnFrame.maxX > width {
            let showX = scrollView.contentOffset.x + (btnFrame.maxX - width) + 15
            scrollView.setContentOffset(CGPoint(x: showX, y: 0), animated: true)
        } else if btnFrame.minX < 0 {
            let showX = scrollView.contentOffset.x + btnFrame.minX - 15
            scrollView.setContentOffset(CGPoint(x: showX, y: 0), animated: true)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.slideView.snp.remakeConstraints({ (make) in
                make.height.equalTo(3)
                make.left.width.equalTo(btn)
                make.bottom.equalToSuperview()
            })
            self.layoutIfNeeded()
        }
    }
    
    /// 修改按钮状态
    ///
    /// - Parameter btn: 选中的按钮
    private func btnChange(btn: UIButton) {
        guard btn.tag != seleTag else {
            return
        }
        
        let oldBtn = viewWithTag(seleTag) as! UIButton
        oldBtn.isSelected = false
        btn.isSelected = true
        seleTag = btn.tag
        btnAnimateHandle(btn: btn)
    }
    
    // MARK: - 按钮点击
    /// 点击选项
    @objc private func optionClick(btn: UIButton) {
        btnChange(btn: btn)
        if changeBlock != nil {
            changeBlock!(seleTag - 100)
        }
    }
}
