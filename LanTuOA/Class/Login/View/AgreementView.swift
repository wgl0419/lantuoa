//
//  AgreementView.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/14.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  登录界面 协议字样view

import UIKit

class AgreementView: UIView {
    
    /// 查看协议回调
    var agreementBlock: (() -> ())?
    /// 查看隐私
    var privacyBlock: (() -> ())?
    
    /// 同意状态
    enum agreeStatus {
        /// 同意
        case agree
        /// 不同意
        case unagree
    }
    
    /// 是否同意
    var agree: agreeStatus = .agree
    
    /// 同意按钮
    private var agreeBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        let agreeBtn = UIButton().taxi.adhere(toSuperView: self) // 同意按钮
            .taxi.layout { (make) in
                make.width.height.equalTo(30)
                make.left.top.bottom.equalTo(self)
            }
            .taxi.config { (btn) in
                btn.isSelected = true
                btn.setImage(UIImage(named: "login_icon_disagree"), for: .normal)
                btn.setImage(UIImage(named: "order_icon_check"), for: .selected)
                btn.addTarget(self, action: #selector(agreeClick(btn:)), for: .touchUpInside)
        }
        
        let agreeLabel = UILabel().taxi.adhere(toSuperView: self) // “阅读并同意”
            .taxi.layout { (make) in
                make.centerY.equalTo(agreeBtn)
                make.left.equalTo(agreeBtn.snp.right)
            }
            .taxi.config { (label) in
                label.text = "阅读并同意"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
        }
        
        let agreementBtn  = UIButton().taxi.adhere(toSuperView: self) // 《蛋卷出行用户使用协议》
            .taxi.layout { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(agreeLabel.snp.right)
            }
            .taxi.config { (btn) in
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitle("《用户协议》", for: .normal)
                btn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
                btn.addTarget(self, action: #selector(agreementClick), for: .touchUpInside)
        }
        
        let label = UILabel().taxi.adhere(toSuperView: self) // “和”
            .taxi.layout { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(agreementBtn.snp.right)
            }
            .taxi.config { (label) in
                label.text = "和"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
        }
        
        _ = UIButton().taxi.adhere(toSuperView: self) // 隐私协议
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalTo(self)
                make.centerY.equalTo(self)
                make.left.equalTo(label.snp.right)
            })
            .taxi.config({ (btn) in
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitle("《隐私协议》", for: .normal)
                btn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
                btn.addTarget(self, action: #selector(privacyClick), for: .touchUpInside)
            })
    }
    
    // MARK: 按钮点击
    /// 点击同意协议
    @objc private func agreeClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        agree = btn.isSelected ? .agree : .unagree
    }
    
    /// 点击用户协议
    @objc private func agreementClick() {
        if agreementBlock != nil {
            agreementBlock!()
        }
    }
    
    /// 点击隐私协议
    @objc private func privacyClick() {
        if privacyBlock != nil {
            privacyBlock!()
        }
    }
}

