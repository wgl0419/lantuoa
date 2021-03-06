//
//  LoginController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/14.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  登录控制器

import UIKit
import MBProgressHUD

class LoginController: UIViewController {
    
    /// 账号输入框
    private var accountTextField: UITextField!
    /// 密码输入框
    private var pwdTextField: UITextField!
    /// 登录按钮
    private var loginBtn: UIButton!
    /// 同意协议视图
    private var agreementView: AgreementView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarStyle = .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }

    // MARK: - 自定义私有方法
    
    /// 初始化子控件
    private func initSubViews() {
        let imageView = UIImageView().taxi.adhere(toSuperView: view) // logo
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(30 + NavigationH)
        }
            .taxi.config { (imageView) in
                imageView.image = UIImage(named: "login_logo")
        }
        
        _ = UILabel().taxi.adhere(toSuperView: view) // “欢迎使用蓝图OA”
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(imageView.snp.right).offset(8)
                make.centerY.equalTo(imageView)
            })
            .taxi.config({ (label) in
                label.text = "欢迎使用蓝图OA"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 24)
            })
        
        let accountLabel = UILabel().taxi.adhere(toSuperView: view) // “账号”
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(imageView.snp.bottom).offset(50)
        }
            .taxi.config { (label) in
                label.text = "账号"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
        }
        
        accountTextField = UITextField().taxi.adhere(toSuperView: view) // 账号输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(38)
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.top.equalTo(accountLabel.snp.bottom).offset(5)
            })
            .taxi.config({ (textField) in
                textField.textColor = blackColor
                textField.keyboardType = .phonePad
                textField.clearButtonMode = .always
                textField.font = UIFont.medium(size: 16)
                let attriMuStr = NSMutableAttributedString(string: "请输入您的账号")
                attriMuStr.changeColor(str: "请输入您的账号", color: UIColor(hex: "#CCCCCC"))
                textField.attributedPlaceholder = attriMuStr
                textField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
            })
        
        _ = UIView().taxi.adhere(toSuperView: view) // 输入框底部线段
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.left.right.bottom.equalTo(accountTextField)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#D5D5D5")
            })
        
        let pwdLabel = UILabel().taxi.adhere(toSuperView: view) // “密码”
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(accountTextField.snp.bottom).offset(25)
        }
            .taxi.config { (label) in
                label.text = "密码"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
        }
        
        pwdTextField = UITextField().taxi.adhere(toSuperView: view) // 密码输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(38)
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.top.equalTo(pwdLabel.snp.bottom).offset(5)
            })
            .taxi.config({ (textField) in
                textField.textColor = blackColor
                textField.isSecureTextEntry = true
                textField.font = UIFont.medium(size: 16)
                let attriMuStr = NSMutableAttributedString(string: "请输入您的密码")
                attriMuStr.changeColor(str: "请输入您的密码", color: UIColor(hex: "#CCCCCC"))
                textField.attributedPlaceholder = attriMuStr
                textField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
            })
        
        _ = UIView().taxi.adhere(toSuperView: view) // 输入框底部线段
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.left.right.bottom.equalTo(pwdTextField)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#D5D5D5")
            })
        
        loginBtn = UIButton().taxi.adhere(toSuperView: view) // 登录按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(50)
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.top.equalTo(pwdTextField.snp.bottom).offset(35)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitle("登录", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 16)
                
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: view) // 忘记密码
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(loginBtn.snp.bottom).offset(15)
            })
            .taxi.config({ (btn) in
                btn.setTitle("忘记密码？", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.addTarget(self, action: #selector(forgetClick), for: .touchUpInside)
            })
        
        _ = UILabel().taxi.adhere(toSuperView: view) // 公司标识
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : -20)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 10)
                label.text = "©2019 广西蛋卷科技有限公司"
                label.textColor = UIColor(hex: "#6B83D1")
            })
        
        agreementView = AgreementView().taxi.adhere(toSuperView: view) // 协议模块
            
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(view)
                make.bottom.equalToSuperview().offset((isIphoneX ? -SafeH : -20) - 25)
            })
            
            .taxi.config({ (view) in
                view.agreementBlock = { [weak self] in // 点击用户协议
                    let webController = WebController()
                    webController.fileNameStr = "deal"
                    self?.navigationController?.pushViewController(webController, animated: true)
                }
                view.privacyBlock = { [weak self] in // 点击隐私协议
                    let webController = WebController()
                    webController.fileNameStr = "privacy"
                    self?.navigationController?.pushViewController(webController, animated: true)
                }
                view.changeBlock = { [weak self] in // 修改同意状态
                    self?.textFieldChange()
                }
            })
    }
    
    /// textField 内容变化
    @objc private func textFieldChange() {
        let accountStr = accountTextField.text ?? ""
        let pwdStr = pwdTextField.text ?? ""
        if accountStr.count == 11 && pwdStr.count >= 4 && pwdStr.count < 20 && agreementView.agree == .agree { // 账号：11位   密码：4~20位   同意协议
            loginBtn.backgroundColor = UIColor(hex: "#2E4695")
            loginBtn.isEnabled = true
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = UIColor(hex: "#CCCCCC")
        }
        
    }
    
    /// 跳转主界面
    private func postMainController() {
        
        let vcs = [HomePageController(), VisitHomeController(), CustomerHomeController(), NoticeHomeController(), MeHomeController()]
        let seleImageNames = ["menu_homePage_highlight", "menu_visit_highlight", "menu_customer_highlight", "menu_notice_highlight", "menu_me_highlight"]
        let imageNames = ["menu_homePage_normal", "menu_visit_normal", "menu_customer_normal", "menu_notice_normal", "menu_me_normal"]
        let titles = ["首页", "拜访", "客户", "通知", "我"]
        let bar = UITabBarController()
        for index in 0..<vcs.count {
            let vc = vcs[index]
            let nav = MainNavigationController(rootViewController: vc)
            let item = nav.tabBarItem
            item?.title = titles[index]
            item?.selectedImage = UIImage(named: seleImageNames[index])?.withRenderingMode(.alwaysOriginal)
            item?.image = UIImage(named: imageNames[index])?.withRenderingMode(.alwaysOriginal)
            item?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "#999999")], for: .normal)
            item?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "#2E4695")], for: .selected)
            bar.addChild(nav)
        }
        self.view.window?.rootViewController = bar
    }
    
    /// 获取个人信息
    private func loginUser() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.loginUser, t: LoginUserModel.self, successHandle: { (result) in
            Jurisdiction.share.setJurisdiction(data: result.data?.privilegeList ?? [])
            UserInfo.share.setUserName(result.data?.realname ?? "")
            self.postMainController()
            MBProgressHUD.dismiss()
        }, errorHandle: { (_) in
            UserInfo.share.userRemve()
            MBProgressHUD.showError("登录失败")
        })
    }
    // MARK: - 按钮点击
    /// 点击登录
    @objc private func loginClick() {
        MBProgressHUD.showWait("")
        let pwdStr = pwdTextField.text ?? ""
        let accountStr = accountTextField.text ?? ""
        _ = APIService.shared.getData(.login(accountStr, pwdStr), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            UserInfo.share.setPhone(accountStr)
            UserInfo.share.setToken(result.data?.token ?? "")
            self.loginUser()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "登录失败")
        })
    }
    
    /// 点击忘记密码
    @objc private func forgetClick() {
        let vc = RetrievePasswordController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
