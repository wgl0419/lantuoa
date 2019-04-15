//
//  DepartmentEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/12.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  添加 部门  弹框

import UIKit
import MBProgressHUD

class DepartmentEjectView: UIView {
    
    /// 添加方式
    enum AddMode {
        /// 添加部门
        case department
        /// 添加小组
        case group(Int)
    }
    
    /// 新增回调
    var createBlock: (() -> ())?
    /// 显示数据  (标题   输入框前面的标题   添加方式)
    var displayData: (String, String, AddMode)? {
        didSet {
            if let data = displayData {
                titleLabel.text = data.0
                nameLabel.text = data.1
                addMode = data.2
            }
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    /// 名称
    private var nameLabel: UILabel!
    /// 输入框
    private var textField: UITextField!
    /// 确认按钮
    private var confirmBtn: UIButton!
    /// 添加方式
    private var addMode = AddMode.department
    
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
        
        let whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景框
            .taxi.layout { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(300)
        }
            .taxi.config { (view) in
                view.layer.cornerRadius = 4
                view.backgroundColor = .white
                view.layer.masksToBounds = true
        }
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(56)
            })
            .taxi.config({ (label) in
                label.text = "新增部门"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.backgroundColor = UIColor(hex: "#F1F1F1")
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(55)
            })
            .taxi.config({ (label) in
                label.text = "部门名称"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
            })
        
        textField = UITextField().taxi.adhere(toSuperView: whiteView) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.equalTo(nameLabel)
                make.right.equalToSuperview().offset(-15)
                make.left.equalTo(nameLabel.snp.right).offset(5)
            })
            .taxi.config({ (textField) in
                textField.placeholder = "请输入"
                textField.textAlignment = .right
                textField.textColor = blackColor
                textField.font = UIFont.medium(size: 16)
                textField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.left.right.equalToSuperview()
                make.top.equalTo(nameLabel.snp.bottom)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(55)
                make.left.bottom.equalToSuperview()
                make.top.equalTo(nameLabel.snp.bottom)
                make.width.equalToSuperview().dividedBy(2).priority(800)
            })
            .taxi.config({ (btn) in
                btn.setTitle("取消", for: .normal)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        confirmBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.bottom.equalToSuperview()
                make.top.equalTo(nameLabel.snp.bottom)
                make.width.equalToSuperview().dividedBy(2).priority(800)
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
            })
    }
    
    /// textField 内容变化
    @objc private func textFieldChange() {
        confirmBtn.isSelected = (textField.text?.count ?? 0) > 0
    }
    
    // MARK: - Api
    /// 新增部门
    private func departmentsCreate() {
        MBProgressHUD.showWait("")
        var parentId = 0
        switch addMode {
        case .department: parentId = 0
        case .group(let id): parentId = id
        }
        _ = APIService.shared.getData(.departmentsCreate(textField.text ?? "", parentId), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if self.createBlock != nil {
                self.createBlock!()
            }
            self.hidden()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "新增失败")
        })
    }
    
    
    // MARK: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    /// 点击确定
    @objc private func confirmClick() {
        departmentsCreate()
    }
}
