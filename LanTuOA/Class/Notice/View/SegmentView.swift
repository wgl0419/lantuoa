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
    /// 标记数组
    private var tipArray = [UILabel]()
    /// 选中按钮
    private var seleBtn: UIButton!
    
    convenience init(title: [String]) {
        self.init()
        titleArray = title
        initSubViews()
    }
    
    func setTips(index: Int, number: Int) {
        let label = tipArray[index]
        if number == 0 {
            label.isHidden = true
            return
        } else {
            label.isHidden = false
        }
        let numberStr = number < 100 ? "\(number)" : "99+"
        label.text = numberStr
        let width = numberStr.getTextSize(font: UIFont.boldSystemFont(ofSize: 10), maxSize: CGSize(width: ScreenWidth, height: ScreenHeight)).width
        label.snp.updateConstraints { (make) in
            make.width.equalTo(width + 8)
        }
        layoutIfNeeded()
        label.layer.cornerRadius = label.height / 2
        label.layer.masksToBounds = true
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
            
//            _ = UILabel().taxi.adhere(toSuperView: self)
//                .taxi.layout(snapKitMaker: { (make) in
//                    make.left.equalTo(btn.titleLabel!.snp.right)
//                    make.centerY.equalTo(btn)
//                })
//                .taxi.config({ (label) in
//                    label.text = "123"
//                    label.textColor = .green
//                })
            let tipLabel = UILabel().taxi.adhere(toSuperView: self) // 提示数量
                .taxi.layout { (make) in
                    make.left.equalTo(btn.titleLabel!.snp.right).offset(5)
                    make.centerY.equalTo(btn)
                    make.width.equalTo(10)
            }
                .taxi.config { (label) in
                    label.isHidden = true
                    label.textColor = .white
                    label.textAlignment = .center
                    label.font = UIFont.boldSystemFont(ofSize: 10)
                    label.backgroundColor = UIColor(hex: "#FF3333")
            }
            tipArray.append(tipLabel)
            
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
