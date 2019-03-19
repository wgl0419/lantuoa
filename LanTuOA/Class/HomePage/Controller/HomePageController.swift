//
//  HomePageController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  首页 控制器

import UIKit

class HomePageController: UIViewController {

    /// 主要tableview
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        navigationItem.title = "蓝图OA"
        let nav = navigationController as! MainNavigationController
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        nav.backBtn.isHidden = false
    }
    
    /// 初始化子控件
    private func initSubViews() {
        tableView = UITableView(frame: .zero, style: .grouped)
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalTo(view)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
                tableView.register(HomePageVisitCell.self, forCellReuseIdentifier: "HomePageVisitCell")
                tableView.register(HomePageNoticeCell.self, forCellReuseIdentifier: "HomePageNoticeCell")
            })
    }
}

extension HomePageController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageNoticeCell", for: indexPath) as! HomePageNoticeCell
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageVisitCell", for: indexPath) as! HomePageVisitCell
            return cell
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HomePageProjectCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HomePageProjectCell")
                cell?.accessoryType = .disclosureIndicator
                cell?.textLabel?.textColor = blackColor
                cell?.textLabel?.font = UIFont.medium(size: 16)
                
                cell?.detailTextLabel?.font = UIFont.medium(size: 12)
                cell?.detailTextLabel?.textColor = UIColor(hex: "#999999")
            }
            cell?.textLabel?.text = "保利地产爱琴海"
            cell?.detailTextLabel?.text = "最新状态:初步交涉"
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let headerView = HomePageHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 44))
            var logoName = "visit"
            var btnStr = "查看历史"
            var attriMuStr = NSMutableAttributedString(string: "本周拜访")
            if section == 2 {
                logoName = "project"
                btnStr = "查看全部"
                let coutStr = " (当前跟进项目数：\(1))"
                attriMuStr = NSMutableAttributedString(string: "我的项目" + coutStr)
                attriMuStr.changeFont(str: coutStr, font: UIFont.medium(size: 12))
                attriMuStr.changeColor(str: coutStr, color: UIColor(hex: "#999999"))
            }
            headerView.setContent(logoName: logoName, attriMuStr: attriMuStr, btnStr: btnStr)
            
            headerView.btnBlock = { // [weak self] in // 跳转其他界面
                if section == 1 {
                    
                } else {
                    
                }
            }
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 40
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
