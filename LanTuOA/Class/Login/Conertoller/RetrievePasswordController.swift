//
//  RetrievePasswordController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/29.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  找回密码  控制器

import UIKit
import MBProgressHUD

class RetrievePasswordController: UIViewController {
    
    /// 计时器
    private var timer: Timer!
    /// 确定按钮
    private var confirmBtn: UIButton!
    /// 手机号输入框
    private var phoneTextField: UITextField!
    /// 验证码输入框
    private var verificationTextField: UITextField!
    /// 获取验证码按钮
    private var verificationBtn: UIButton!
    /// 新密码输入框
    private var newPasswordTextField: UITextField!
    /// 确认密码输入框
    private var confirmPasswrodTextField: UITextField!
    
    /// 倒计时
    private var countDownTime = 60
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let nav = navigationController as! MainNavigationController
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        nav.backBtn.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotification()
        initSubViews()
    }

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "找回密码"
        view.backgroundColor = UIColor(hex: "#F3F3F3")
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮背景框
            .taxi.layout { (make) in
                make.height.equalTo(62 + (isIphoneX ? SafeH : 18))
                make.left.right.bottom.equalToSuperview()
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        confirmBtn = UIButton().taxi.adhere(toSuperView: btnView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().offset(-30)
                make.top.equalToSuperview().offset(18)
                make.centerX.equalToSuperview()
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
            })
        
        let firstView = UIView().taxi.adhere(toSuperView: view) // 第一个框
            .taxi.layout { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(100)
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        let phone = UILabel().taxi.adhere(toSuperView: firstView) // "手机号"
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.height.equalTo(50)
        }
            .taxi.config { (label) in
                label.text = "手机号"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        phoneTextField = UITextField().taxi.adhere(toSuperView: firstView) // 手机号输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(phone.snp.right).offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.bottom.equalTo(phone)
            })
            .taxi.config({ (textField) in
                textField.placeholder = "请输入"
                textField.textAlignment = .right
                textField.font = UIFont.medium(size: 16)
            })
        
        _ = UIView().taxi.adhere(toSuperView: firstView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview()
                make.bottom.equalTo(phone)
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        let verification = UILabel().taxi.adhere(toSuperView: firstView) // “验证码”
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(phone.snp.bottom)
                make.height.equalTo(50)
        }
            .taxi.config { (label) in
                label.text = "输入验证码"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        verificationBtn = UIButton().taxi.adhere(toSuperView: firstView) // 获取验证码按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(verification)
                make.height.equalTo(30)
                make.width.equalTo(90)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.setTitle("获取验证码", for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.addTarget(self, action: #selector(verificationClick), for: .touchUpInside)
            })
        
        verificationTextField = UITextField().taxi.adhere(toSuperView: firstView) // 验证码输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalTo(verificationBtn.snp.left).offset(-15)
                make.left.equalTo(verification.snp.right).offset(15)
                make.top.bottom.equalTo(verification)
            })
            .taxi.config({ (textField) in
                textField.placeholder = "请输入"
                textField.textAlignment = .right
                textField.font = UIFont.medium(size: 16)
            })
        
        let secondView = UIView().taxi.adhere(toSuperView: view) // 第二块
            .taxi.layout { (make) in
                make.top.equalTo(firstView.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
                make.height.equalTo(100)
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        let newPassword = UILabel().taxi.adhere(toSuperView: secondView) // “新密码”
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.height.equalTo(50)
        }
            .taxi.config { (label) in
                label.text = "新密码"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        newPasswordTextField = UITextField().taxi.adhere(toSuperView: secondView) // 新密码输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(newPassword.snp.right).offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.bottom.equalTo(newPassword)
            })
            .taxi.config({ (textField) in
                textField.placeholder = "请输入"
                textField.textAlignment = .right
                textField.isSecureTextEntry = true
                textField.font = UIFont.medium(size: 16)
            })
        
        _ = UIView().taxi.adhere(toSuperView: secondView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalTo(newPassword)
                make.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        let confirmPasswrod = UILabel().taxi.adhere(toSuperView: secondView) // "确认密码"
            .taxi.layout { (make) in
                make.top.equalTo(newPassword.snp.bottom)
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(50)
        }
            .taxi.config { (label) in
                label.text = "确认密码"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        confirmPasswrodTextField = UITextField().taxi.adhere(toSuperView: secondView) // 确认密码输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(confirmPasswrod.snp.right).offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.bottom.equalTo(confirmPasswrod)
            })
            .taxi.config({ (textField) in
                textField.placeholder = "请输入"
                textField.textAlignment = .right
                textField.isSecureTextEntry = true
                textField.font = UIFont.medium(size: 16)
            })
    }
    
    /// 初始化通知
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    /// 文本变更时事件
    ///
    /// - Parameter noti: 通知对象
    @objc fileprivate func textChanged() {
        verificationHandle()
        let phone = phoneTextField.text ?? ""
        let verification = verificationTextField.text ?? ""
        let newPassword = newPasswordTextField.text ?? ""
        let confirmPasswrod = confirmPasswrodTextField.text ?? ""
        if phone.count > 0 && verification.count > 0 && newPassword.count > 0 && confirmPasswrod.count > 0 {
            confirmBtn.backgroundColor = UIColor(hex: "#2E4695")
        } else {
            confirmBtn.backgroundColor = UIColor(hex: "#CCCCCC")
        }
    }
    
    /// 启动计时任务
    @objc private func startTimer() {
        countDownTime -= 1
        verificationBtn.setTitle("(重送\(countDownTime)s)", for: .normal)
        if countDownTime == 0 {
            shopTimer()
        }
    }
    
    /// 停止计时任务
    private func shopTimer() {
        countDownTime = 60
        verificationBtn.setTitle("获取验证码", for: .normal)
        verificationHandle()
        guard timer != nil else {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    
    /// 处理获取验证码按钮
    private func verificationHandle() {
        let phone = phoneTextField.text ?? ""
        verificationBtn.isEnabled = false
        if phone.count == 11 && countDownTime == 60 { // 获取验证码按钮高亮
            verificationBtn.backgroundColor = UIColor(hex: "#2E4695")
            if verificationBtn.titleLabel?.text == "获取验证码" {
                verificationBtn.isEnabled = true
            }
        } else {
            verificationBtn.backgroundColor = UIColor(hex: "#CCCCCC")
        }
    }
    
    // MAKR: - Api
    /// 获取验证码
    private func code() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.code(phoneTextField.text ?? ""), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            self.shopTimer()
            MBProgressHUD.showError(error ?? "获取验证码失败")
        })
    }
    
    /// 忘记密码
    private func passwordReset() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.passwordReset(phoneTextField.text ?? "", verificationTextField.text ?? "", newPasswordTextField.text ?? ""), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.showSuccess("修改成功")
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            self.shopTimer()
            MBProgressHUD.showError(error ?? "获取验证码失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 获取验证码
    @objc private func verificationClick() {
        let phone = phoneTextField.text ?? ""
        if !phone.isRegexMobile() {
            MBProgressHUD.showError("请输入正确的手机号码")
            return
        }
        verificationBtn.isEnabled = false
        verificationBtn.backgroundColor = UIColor(hex: "#CCCCCC")
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        let runLoop = RunLoop.current
        runLoop.add(timer, forMode: .common)
        timer.fire()
        code()
    }
    
    /// 提交忘记密码
    @objc private func confirmClick() {
        let newPassword = newPasswordTextField.text ?? ""
        let confirmPasswrod = confirmPasswrodTextField.text ?? ""
        if newPassword != confirmPasswrod {
            MBProgressHUD.showError("确认密码与新密码不一致")
            return
        }
        passwordReset()
    }
        
}
