//
//  ChangePasswordController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  修改密码 控制器

import UIKit
import MBProgressHUD

class ChangePasswordController: UIViewController {

    /// tableView
    private var tableView: UITableView!
    /// 确认按钮
    private var confirmBtn: UIButton!
    
    /// 标题
    private let titleArray = [["原密码"], ["新密码", "确认密码"]]
    /// 提示
    private let placeholderArray = [["请输入"], ["请输入", "请输入"]]
    /// 填写的数据
    private var contentStrArray = [[""], ["", ""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "修改密码"
        view.backgroundColor = .white
        
        let confirmView = UIView().taxi.adhere(toSuperView: view) // 确认按钮 view
            .taxi.layout { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(62 + (isIphoneX ? SafeH : 18))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        confirmBtn = UIButton().taxi.adhere(toSuperView: confirmView) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(44)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(18)
                make.width.equalToSuperview().offset(-30)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitle("确认修改", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 16)
                
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(confirmView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.bounces = false
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = kMainBackColor
                tableView.register(FillInApplyFieldViewCell.self, forCellReuseIdentifier: "FillInApplyFieldViewCell")
            })
    }

    /// 判断是否能点击
    private func judgeEnabled() {
        var isEnabled = true
        for strArray in contentStrArray {
            for str in strArray {
                if str.count == 0 {
                    isEnabled = false
                    break
                }
            }
        }
        if isEnabled {
            confirmBtn.backgroundColor = UIColor(hex: "#2E4695")
            confirmBtn.isEnabled = true
        } else {
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = UIColor(hex: "#CCCCCC")
        }
    }
    
    /// 退出登录处理
    private func logoutHandle() {
        UserInfo.share.userRemve() // 清除数据
        let vc = LoginController()
        let nav = MainNavigationController(rootViewController: vc)
        self.view.window?.rootViewController = nav
        MBProgressHUD.showSuccess("请重新登录")
    }
    
    // MARK: - Api
    /// 修改密码
    private func usersPwd() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.usersPwd(contentStrArray[0][0], contentStrArray[1][0]), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.showSuccess("修改成功")
//            self.login() // token变化   还需自行调用登录接口获取token (后端未处理好  导致修改密码后 重新获取token 无效)
            self.logoutHandle()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "修改失败")
        })
    }
    
    /// 登录
    private func login() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.login(UserInfo.share.phone, contentStrArray[1][0]), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            UserInfo.share.setToken(result.data?.token ?? "")
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "修改失败")
        })
    }
    
    // MARK: - 按钮点击
    @objc private func confirmClick() {
        if contentStrArray[1][0] != contentStrArray[1][1] {
            MBProgressHUD.showError("确认密码和新密码不一致")
            return
        }
        usersPwd()
    }
}

extension ChangePasswordController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyFieldViewCell", for: indexPath) as! FillInApplyFieldViewCell
        cell.data = (titleArray[section][row], placeholderArray[section][row])
        cell.contentStr = contentStrArray[section][row]
        cell.isSecureTextEntry = section == 1
        cell.inputBlock = { [weak self] (str) in
            self?.contentStrArray[section][row] = str
            self?.judgeEnabled()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        footerView.backgroundColor = kMainBackColor
        return footerView
    }
}
