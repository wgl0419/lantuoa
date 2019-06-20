//
//  HandoverStaffController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  交接员工  控制器

import UIKit
import MJRefresh
import MBProgressHUD

class HandoverStaffController: UIViewController {
    
    /// 员工数据
    var userData: WorkExtendListData!
    
    /// tableView
    private var tableView: UITableView!
    /// 工作数据
    private var data = [WorkExtendListPersonData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        workExtendListPerson()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "交接员工"
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.register(HandoverStaffCell.self, forCellReuseIdentifier: "HandoverStaffCell")
                tableView.register(HandoverStaffHeaderCell.self, forCellReuseIdentifier: "HandoverStaffHeaderCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.workExtendListPerson()
                })
            })
    }
    
    // MAKR: - Api
    /// 员工工作列表
    private func workExtendListPerson() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workExtendListPerson(userData.id), t: WorkExtendListPersonModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.data = result.data
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            if result.data.count == 0 {
                MBProgressHUD.showError("该员工没有需要交接的工作")
            }
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
}

extension HandoverStaffController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 25))
            headerView.backgroundColor = .white
            _ = UILabel().taxi.adhere(toSuperView: headerView)
                .taxi.layout(snapKitMaker: { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(15)
                })
                .taxi.config({ (label) in
                    label.text = "交接工作："
                    label.font = UIFont.medium(size: 10)
                    label.textColor = kMainSelectedColor
                })
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 25
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HandoverStaffHeaderCell", for: indexPath) as! HandoverStaffHeaderCell
            cell.data = userData
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HandoverStaffCell", for: indexPath) as! HandoverStaffCell
            cell.data = data[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let vc = HandoverStaffSeleController()
            vc.oldUserId = userData.id
            vc.projectId = data[indexPath.row].id
            vc.workExtendBlock = { [weak self] in // 交接成功  -> 删除
                self?.workExtendListPerson()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
