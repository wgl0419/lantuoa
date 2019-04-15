//
//  SegmentView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class SegmentView: UIView {
    
    /// 代理
    weak var delegate: SegmentViewDelegate?
    
    /// 滑杆
    private var slideView: UIView!
    
    /// 标题数组
    private var titleArray = [String]()
    /// 记录按钮
    private var btnArray = [UIButton]()
    /// 选中按钮
    private var seleBtn: UIButton!
    
    convenience init(title: [String]) {
        self.init()
        titleArray = title
        initSubViews()
    }
    
    func setTips(index: Int, showTips: Bool) {
        let btn = btnArray[index]
        btn.titleLabel?.isShowRedDot = true
    }
    
    /// 修改显示按钮
    func changeBtn(page: Int) {
        let btn = self.viewWithTag(page + 100) as! UIButton
        btnChange(btn: btn)
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        var lastBtn: UIButton!
        for index in 0..<titleArray.count {
            let title = titleArray[index]
            let btn = UIButton().taxi.adhere(toSuperView: self)
                .taxi.layout { (make) in
                    make.top.bottom.equalToSuperview()
                    if lastBtn == nil {
                        make.left.equalToSuperview()
                    } else {
                        make.width.equalTo(lastBtn)
                        make.left.equalTo(lastBtn.snp.right)
                    }
                    if index == titleArray.count - 1 {
                        make.right.equalToSuperview()
                    }
            }
                .taxi.config { (btn) in
                    btn.tag = index + 100
                    btn.setTitle(title, for: .normal)
                    btn.titleLabel?.font = UIFont.medium(size: 14)
                    btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                    btn.setTitleColor(UIColor(hex: "#2E4695"), for: .selected)
                    btn.setTitleColor(UIColor(hex: "#2E4695"), for: .highlighted)
                    btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            }
            lastBtn = btn
            btnArray.append(btn)
            if index != 0 {
                _ = UIView().taxi.adhere(toSuperView: self) // 分割线
                    .taxi.layout(snapKitMaker: { (make) in
                        make.width.equalTo(1)
                        make.left.equalTo(btn)
                        make.centerY.equalToSuperview()
                        make.height.equalToSuperview().offset(-30)
                    })
                    .taxi.config({ (view) in
                        view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                    })
            } else {
                seleBtn = lastBtn
                lastBtn.isSelected = true
                slideView = UIView().taxi.adhere(toSuperView: self) // 滑杆
                    .taxi.layout(snapKitMaker: { (make) in
                        make.left.right.equalTo(lastBtn)
                        make.bottom.equalToSuperview()
                        make.height.equalTo(3)
                    })
                    .taxi.config({ (view) in
                        view.backgroundColor = UIColor(hex: "#2E4695")
                    })
            }
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
    
    /// 修改按钮
    private func btnChange(btn: UIButton) {
        if seleBtn != btn {
            seleBtn.isSelected = false
            seleBtn = btn
            seleBtn.isSelected = true
            UIView.animate(withDuration: 0.25) {
                self.slideView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.left.right.equalTo(btn)
                    make.height.equalTo(3)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - 按钮点击
    @objc private func btnClick(btn: UIButton) {
        if seleBtn != btn {
            btnChange(btn: btn)
            delegate?.changeScrollView(page: btn.tag - 100)
        }
    }
}

@objc
protocol SegmentViewDelegate: NSObjectProtocol {
    func changeScrollView(page: Int)
}
