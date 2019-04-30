//
//  DepartmentalStaffController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  部门人员  控制器

import UIKit
import MJRefresh
import YCMenuView
import MBProgressHUD

class DepartmentalStaffController: UIViewController {

    /// 当前部门数据
    var departmentsData: DepartmentsData!
    /// 其他部门数据
    var otherDepartmentsData = [DepartmentsData]()
    
    /// tableView
    private var tableView: UITableView!
    
    /// 部门数据
    private var departmentData: [DepartmentsData]!
    /// 人员数据
    private var personnelData: [DepartmentsUsersData]!
    /// 修改部门用户id
    private var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        departments(parentId: departmentsData.id)
        departmentsUsers()
    }

    // MAKR: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        title = departmentsData.name ?? ""
        view.backgroundColor = .white
        if Jurisdiction.share.isAddDepartment {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新建小组",
                                                                titleColor: .white,
                                                                titleFont: UIFont.medium(size: 15),
                                                                titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                                target: self,
                                                                action: #selector(rightClick))
        }
    }
    
    /// 初始化子控件
    private func initSubViews() {
        tableView = UITableView().taxi.adhere(toSuperView: view) // 主要显示数据tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 40
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(DepartmentalGroupCell.self, forCellReuseIdentifier: "DepartmentalGroupCell")
                tableView.register(DepartmentalStaffCell.self, forCellReuseIdentifier: "DepartmentalStaffCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.departments(parentId: self?.departmentsData.id ?? 0)
                    self?.departmentsUsers()
                })
            })
    }
    
    /// 数据刷新处理
    private func reloadDataHandle() {
        tableView.mj_header.endRefreshing()
    }
    
    /// 离职员工处理
    private func usersLeaveHandle() {
        let alertController = UIAlertController(title: "提示", message: "是否离职该员工?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (_) in
            self.usersLeave()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 添加类的尾视图
    private func addFooterViewHandle() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 45))
        _ = UIButton().taxi.adhere(toSuperView: footerView)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle(" 添加成员", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setImage(UIImage(named: "add"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
            })
        
        for index in 0..<2 { // 添加分割线
            _ = UIView().taxi.adhere(toSuperView: footerView)
                .taxi.layout(snapKitMaker: { (make) in
                    make.height.equalTo(1)
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                    if index == 0 {
                        make.top.equalToSuperview()
                    } else {
                        make.bottom.equalToSuperview()
                    }
                })
                .taxi.config({ (view) in
                    view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                })
        }
        footerView.backgroundColor = .white
        return footerView
    }
    
    /// 点击更多处理
    private func moreHandle(btn: UIButton) {
        var actionArray = [YCMenuAction]()
        if Jurisdiction.share.isModifyPerson {
            let replaceAction = YCMenuAction(title: "   更换部门", image: nil) { (_) in
//                if self.otherDepartmentsData.count == 0 {
//                    self.departments(parentId: -1)
//                } else {
//                    self.seleDepartmentsHandle()
//                }
                let vc = ReplacementDepartmentController()
                vc.userId = self.userId
                vc.departmentsId = self.departmentsData.id
                vc.changeBlock = { [weak self] in
                    self?.departmentsUsers()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            actionArray.append(replaceAction!)
        }
        if Jurisdiction.share.isLeavePerson {
            let quitAction = YCMenuAction(title: "   设为离职", image: nil) { (_) in
                self.usersLeaveHandle()
            }
            actionArray.append(quitAction!)
        }
        
        let menuView = YCMenuView.menu(with: actionArray, width: 100, relyonView: btn)
        menuView?.menuColor = .white
        menuView?.separatorColor = UIColor(hex: "#E5E5E5")
        menuView?.maxDisplayCount = 5
        menuView?.offset = 0
        menuView?.textColor = UIColor(hex: "#6B83D1")
        menuView?.textFont = UIFont.medium(size: 12)
        menuView?.menuCellHeight = 40
        menuView?.dismissOnselected = true
        menuView?.dismissOnTouchOutside = true
        
        menuView?.show()
    }
    
    /// 选择部门处理
    private func seleDepartmentsHandle() {
        var contentStrArray = [String]()
        for model in otherDepartmentsData {
            contentStrArray.append(model.name ?? "")
        }
        let view = SeleVisitModelView(title: "更换部门", content: contentStrArray)
        view.didBlock = { [weak self] (seleIndex) in
            let newDeptId = self?.otherDepartmentsData[seleIndex].id ?? 0
            self?.departmentsChange(newDeptId: newDeptId)
        }
        view.show()
    }
    
    // MARK: - Api
    /// 部门列表
    private func departments(parentId: Int) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.departments(parentId), t: DepartmentsModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if parentId == -1 {
                self.otherDepartmentsData = result.data
                for index in (0..<self.otherDepartmentsData.count).reversed() {
                    let model = self.otherDepartmentsData[index]
                    if model.id == self.departmentsData.id {
                        self.otherDepartmentsData.remove(at: index)
                        break
                    }
                }
                self.seleDepartmentsHandle()
            } else {
                self.departmentData = result.data
                self.reloadDataHandle()
                self.tableView.reloadData()
            }
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取部门列表失败")
        })
    }
    
    /// 获取部门人员列表
    private func departmentsUsers() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.departmentsUsers(departmentsData.id, nil, nil), t: DepartmentsUsersModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.personnelData = result.data
            self.reloadDataHandle()
            self.tableView.reloadData()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取部门人员列表失败")
        })
    }
    
    /// 修改部门
    private func departmentsChange(newDeptId: Int) {
//        MBProgressHUD.showWait("")
//        _ = APIService.shared.getData(.departmentsChange(userId, departmentsData.id, newDeptId), t: LoginModel.self, successHandle: { (result) in
//            self.departmentsUsers()
//            self.departments(parentId: self.departmentsData.id)
//            MBProgressHUD.dismiss()
//        }, errorHandle: { (error) in
//            MBProgressHUD.showError(error ?? "修改部门失败")
//        })
    }
    
    /// 离职员工
    private func usersLeave() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.usersLeave(userId), t: LoginModel.self, successHandle: { (result) in
            self.departmentsUsers()
            self.departments(parentId: self.departmentsData.id)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "离职员工失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击邀请成员
    @objc private func rightClick() {
        let ejectView = DepartmentEjectView()
        ejectView.displayData = ("新建小组", "小组名称", .group(departmentsData.id))
        ejectView.createBlock = { [weak self] in
            self?.departments(parentId: self?.departmentsData.id ?? 0)
        }
        ejectView.show()
    }
    
    /// 邀请成员
    @objc private func addClick() {
        var prohibitIds = [Int]()
        for model in personnelData {
            prohibitIds.append(model.id)
        }
        let vc = SelePersonnelController()
        vc.prohibitIds = prohibitIds
        vc.displayData = ("邀请成员", "邀请", .departmentAddUsers(departmentsData.id))
        vc.determineBlock = { [weak self] in
            self?.departmentsUsers()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension DepartmentalStaffController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return departmentData == nil ? 0 : departmentData.count
        } else {
            return personnelData == nil ? 0 : personnelData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentalGroupCell", for: indexPath) as! DepartmentalGroupCell
            cell.data = departmentData[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentalStaffCell", for: indexPath) as! DepartmentalStaffCell
            cell.data = personnelData[indexPath.row]
            cell.moreBlock = { [weak self] (btn) in
                self?.userId = self?.personnelData[indexPath.row].id ?? 0
                self?.moreHandle(btn: btn)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return Jurisdiction.share.isAddDepartmentMember ? 45 : 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return Jurisdiction.share.isAddDepartmentMember ? addFooterViewHandle() : nil
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let vc = DepartmentalStaffController()
            vc.departmentsData = departmentData[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
