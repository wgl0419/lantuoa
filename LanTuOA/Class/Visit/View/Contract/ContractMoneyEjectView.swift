//
//  ContractMoneyEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同金额  弹出框

import UIKit
import MBProgressHUD

class ContractMoneyEjectView: UIView {

    /// 选择回调
    var seleBlock: ((Float) -> ())?
    /// 数据 (标题  金额标题 )
    var data: (String, String)! {
        didSet {
            titleLabel.text = data.0
            typeLabel.text = data.1
        }
    }
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// 金额类型 -> 金额标题
    private var typeLabel: UILabel!
    /// 金额输入框
    private var textField: UITextField!
    
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
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.textAlignment = .center
                label.backgroundColor = UIColor(hex: "#F1F1F1")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        typeLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 金额类型 -> 金额标题
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(55)
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
        
        textField = UITextField().taxi.adhere(toSuperView: whiteView) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(typeLabel.snp.right).offset(5)
                make.right.equalToSuperview().offset(-15)
                make.top.bottom.equalTo(typeLabel)
            })
            .taxi.config({ (textField) in
                textField.delegate = self
                textField.textAlignment = .right
                textField.placeholder = "请输入金额"
                textField.font = UIFont.boldSystemFont(ofSize: 16)
                textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(typeLabel.snp.bottom)
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
                make.top.equalTo(typeLabel.snp.bottom)
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
                make.top.equalTo(typeLabel.snp.bottom)
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
    
    // MARK: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    /// 点击确定
    @objc private func determineClick() {
        let str = textField.text ?? ""
        guard str.count != 0 else {
            MBProgressHUD.showError("请输入金额")
            return
        }
        let money = Float(str) ?? 0
        if seleBlock != nil {
            seleBlock!(money)
        }
    }
}

extension ContractMoneyEjectView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 { // 删除
            return true
        }
        let str = (textField.text ?? "") + string
        return str.isRegexDecimal()
    }
}
