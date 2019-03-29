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
                tableView.delegate = self
                tableView.dataSource = self
                tableView.sectionHeaderHeight = 45
                tableView.tableFooterView = UIView()
            })
    }
}

extension SetUpController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SetUpCell")
        if cell == nil {
            cell = UITableViewCell(style: .value2, reuseIdentifier: "SetUpCell")
//            cell?.imageView?.layer.cornerRadius = (cell?.imageView?.height ?? 0) / 2
            cell?.imageView?.layer.masksToBounds = true
            cell?.textLabel?.font = UIFont.medium(size: 14)
            cell?.textLabel?.textColor = UIColor(hex: "#444444")
        }
        cell?.imageView?.backgroundColor = .gray
        cell?.textLabel?.text = indexPath.row == 0 ? "修改密码" : "退出登录"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = ChangePasswordController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
