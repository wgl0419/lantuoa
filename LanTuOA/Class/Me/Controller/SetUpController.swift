//
//  SetUpController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  设置 控制器

import UIKit

class SetUpController: UIViewController {

    /// 主要显示内容的tableview
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "设置"
        view.backgroundColor = .white
        
        tableView = UITableView(frame: .zero, style: .grouped) // 主要显示内容的tableView
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.rowHeight = 50
                tableView.delegate = self
                tableView.dataSource = self
                tableView.sectionHeaderHeight = 0.01
                tableView.tableFooterView = UIView()
            })
    }
    
    /// 退出登录处理
    private func logoutHandle() {
        let alertController = UIAlertController(title: "提示", message: "是否退出登录?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "退出", style: .default, handler: { (_) in
            UserInfo.share.userRemve() // 清除数据
            let vc = LoginController()
            let nav = MainNavigationController(rootViewController: vc)
            self.view.window?.rootViewController = nav
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
        
    }
}

extension SetUpController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "SetUpCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "SetUpCell")
                cell?.textLabel?.textColor = UIColor(hex: "#444444")
                cell?.textLabel?.font = UIFont.medium(size: 14)
                cell?.accessoryType = .disclosureIndicator
            }
            cell?.textLabel?.text = indexPath.row == 0 ? "修改密码" : "退出登录"
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "UpdateCell")
                cell?.selectionStyle = .none
                _ = UILabel().taxi.adhere(toSuperView: cell!)
                    .taxi.layout { (make) in
                        make.edges.equalToSuperview()
                }
                    .taxi.config { (label) in
                        label.tag = 10086
                        label.textAlignment = .center
                        label.font = UIFont.medium(size: 14)
                        label.textColor = kMainSelectedColor
                }
            }
            let label = cell!.viewWithTag(10086) as! UILabel
            label.text = "当前版本：" + appVersion
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        if section == 0 {
            if indexPath.row == 0 {
                let vc = ChangePasswordController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                logoutHandle()
            }
        }
    }
}
