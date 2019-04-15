//
//  MeHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  我 首页 控制器

import UIKit

class MeHomeController: UIViewController {

    /// 显示数据的tableviwe
    private var tableView: UITableView!
    
    /// 标题
    private let titleArray = [["", "我的审批", "查询绩效", "工作申请", "离职申请", "工作交接"], ["部门管理", "角色管理"], ["设置"]]
    /// 图标
    private let iconArray = [["", "me_approval", "me_achievements", "me_jobApplication", "me_jeaveApplication", "me_handover"], ["me_departmentManagement", "me_roleManagement"], ["me_setUp"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        navigationItem.title = "我"
        let nav = navigationController as! MainNavigationController
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
    }
    
    /// 初始化子控件
    private func initSubViews() {
        tableView = UITableView().taxi.adhere(toSuperView: view) // 主要显示数据的tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 45
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(MeHomeCell.self, forCellReuseIdentifier: "MeHomeCell")
                tableView.register(MeHomeHeaderCell.self, forCellReuseIdentifier: "MeHomeHeaderCell")
            })
    }
}

extension MeHomeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if row == 0 && section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeHomeHeaderCell", for: indexPath) as! MeHomeHeaderCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: ScreenWidth, bottom: 0, right: 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeHomeCell", for: indexPath) as! MeHomeCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
            cell.data = (iconArray[section][row], titleArray[section][row], false)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 10
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let section = indexPath.section
        var vc: UIViewController!
        if section == 0 {
            switch row {
            case 1:
                vc = ToExamineController()
            case 2:
                vc = AchievementsListController()
            case 3:
                vc = ApplyController()
            case 4:
                return
            case 5:
                vc = JobHandoverController()
            default: return
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        if section == 1 {
            if row == 0 {
                let vc = DepartmentManagementController()
                navigationController?.pushViewController(vc, animated: true)
            } else {
                
            }
        }
        if section == 2 {
            let vc = SetUpController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
