//
//  MeHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  我 首页 控制器

import UIKit
import MBProgressHUD

class MeHomeController: UIViewController {

    /// 显示数据的tableviwe
    private var tableView: UITableView!
    
    /// 标题
    private var titleArray = [["", "我的审批", "绩效查询", "工作申请"], ["合同", "工作组"], ["组织架构"], ["设置"]]
//    private var titleArray = [["", "我的审批", "绩效查询", "工作申请"], ["合同"], ["组织架构"], ["设置"]]
    /// 图标
    private var iconArray = [["", "me_approval", "me_achievements", "me_contract"], ["me_jobApplication", "me_workGroup"], ["me_departmentManagement"], ["me_setUp"]]
//    private var iconArray = [["", "me_approval", "me_achievements", "me_contract"], ["me_jobApplication"], ["me_departmentManagement"], ["me_setUp"]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        loginUser()
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
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        
        if Jurisdiction.share.isViewWorkextend { // 有无工作交接权限
            titleArray[0].append("工作交接")
            iconArray[0].append("me_handover")
        }
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // 主要显示数据的tableview
            .taxi.layout(snapKitMaker: { (make) in
                if #available(iOS 9.0, *) {
                    make.edges.equalToSuperview()
                } else {
                    make.top.left.right.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-TabbarH)
                }
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 45
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = kMainBackColor
                if #available(iOS 11.0, *) {
                    tableView.contentInsetAdjustmentBehavior = .never
                }
                tableView.register(MeHomeCell.self, forCellReuseIdentifier: "MeHomeCell")
                tableView.register(MeHomeHeaderCell.self, forCellReuseIdentifier: "MeHomeHeaderCell")
            })
    }
    
    // MARK: - Api
    /// 获取个人信息
    private func loginUser() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.loginUser, t: LoginUserModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            UserInfo.share.setUserName(result.data?.realname ?? "")
            let positio = (result.data?.roleList.count ?? 0) > 0 ? result.data?.roleList[0].name ?? "" : "员工"
            UserInfo.share.setPosition(positio)
            Jurisdiction.share.setJurisdiction(data: result.data?.privilegeList ?? [])
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取个人信息失败")
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
            headerView.backgroundColor = kMainBackColor
            return headerView
        } else {
            return nil
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
                vc = ApplyControllers()
            case 4:
                vc = JobHandoverController()
            default: return
            }
        } else if section == 1 {
            if row == 0 {
                vc = ContractListController()
            } else {
                vc = WorkGroupController()
            }
        } else if section == 2 {
            vc = DepartmentManagementController()
        } else if section == 3 {
            vc = SetUpController()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
