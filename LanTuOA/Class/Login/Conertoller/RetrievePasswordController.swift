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
    
    /// 确定按钮
    private var confirmBtn: UIButton!
    
    /// 标题
    private let titleArray = [["手机号码", "输入验证码"], ["新密码", "确认密码"]]
    /// 提示
    private let placeholderArray = [["请输入", "请输入"], ["请输入", "请输入"]]
    /// 填写的数据
    private var contentStrArray = [["", ""], ["", ""]]
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
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        let firstView = UIView().taxi.adhere(toSuperView: view) // 第一个框
            .taxi.layout { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(100)
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        let phone = UILabel().taxi.adhere(toSuperView: firstView) // 手机号
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.height.equalTo(50)
        }
            .taxi.config { (label) in
                label.text = "手机号"
        }
    }
        
}
