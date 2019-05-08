//
//  FillInApplyController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请  控制器

import UIKit
import MBProgressHUD

class FillInApplyController: UIViewController {
    
    /// 流程名称
    var processName = "流程名称"
    /// 流程id
    var processId = 0
    /// 流程类型
    var pricessType = 0

    /// tableview
    private var tableView: UITableView!
    /// 提交按钮
    private var submissionBtn: UIButton!
    
    /// 数据
    private var data = [ProcessParamsData]()
    /// 审核人数据
    private var processUsersData: ProcessUsersData!
    /// 添加的抄送人数据
    private var carbonCopyData = [ProcessUsersCheckUsers]()
    /// 添加合同人员数据
    private var contractData = [(UsersData, String, String)]()
    /// 选中内容
    private var seleStrArray = [String]()
    /// 项目所在section
    private var projectPosition = -1
    /// 客户id
    private var customerId = -1
    /// 项目id
    private var projectId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        processParams()
        processUsers()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = processName
        view.backgroundColor = .white
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮背景
            .taxi.layout { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(62 + (isIphoneX ? SafeH : 18))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        submissionBtn = UIButton().taxi.adhere(toSuperView: btnView) // 提交按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().offset(-30)
                make.top.equalToSuperview().offset(18)
                make.centerX.equalToSuperview()
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitle("提交", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(submissionClick), for: .touchUpInside)
            })
        
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
                tableView.register(FillInApplyTextViewCell.self, forCellReuseIdentifier: "FillInApplyTextViewCell")
                tableView.register(FillInApplyFieldViewCell.self, forCellReuseIdentifier: "FillInApplyFieldViewCell")
                tableView.register(FillInApplyApprovalCell.self, forCellReuseIdentifier: "FillInApplyApprovalCell")
                tableView.register(FillInApplyPersonnelCell.self, forCellReuseIdentifier: "FillInApplyPersonnelCell")
            })
    }
    
    /// 确认按钮处理
    private func confirmHandle() {
        var isEnabled = true
        for index in 0..<data.count {
            let model = data[index]
            if model.isNecessary == 1 && seleStrArray[index].count == 0 {
                isEnabled = false
                break
            }
        }
        if isEnabled && pricessType == 5 {
            isEnabled = contractData.count > 0
        }
        
        if isEnabled {
            submissionBtn.backgroundColor = UIColor(hex: "#2E4695")
            submissionBtn.isEnabled = true
        } else {
            submissionBtn.isEnabled = false
            submissionBtn.backgroundColor = UIColor(hex: "#CCCCCC")
        }
    }
    
    /// 选择时间
    private func seleTimeHandle(section: Int) {
        UIApplication.shared.keyWindow?.endEditing(true)
        let timeStr = seleStrArray[section]
        var timeStamp: Int!
        if timeStr.count > 0 {
            timeStamp = timeStr.getTimeStamp(customStr: "yyyy-MM-dd")
        }
        let ejectView = SeleTimeEjectView(timeStamp: timeStamp, titleStr: data[section].title ?? "")
        ejectView.determineBlock = { [weak self] (timeStamp) in
            let timeStr = Date(timeIntervalSince1970: TimeInterval(timeStamp)).customTimeStr(customStr: "yyyy-MM-dd")
            self?.seleStrArray[section] = timeStr
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)
            self?.confirmHandle()
        }
        ejectView.show()
    }
    
    /// 单选
    private func singleSeleHandle(section: Int) {
        var contentArray = [String]()
        for model in data[section].choices {
            contentArray.append(model.name ?? "")
        }
        let view = SeleVisitModelView(title: "选择拜访方式", content: contentArray)
        view.didBlock = { [weak self] (seleIndex) in
            self?.seleStrArray[section] = contentArray[seleIndex]
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)
            self?.confirmHandle()
        }
        view.show()
    }
    
    /// 多选处理
    private func multipleSeleHandle(section: Int) {
        var contentArray = [String]()
        for model in data[section].choices {
            contentArray.append(model.name ?? "")
        }
        let vc = MultipleSeleController()
        vc.contentArray = contentArray
        vc.didBlock = { [weak self] (seleArray) in
            var seleStr = ""
            for str in seleArray {
                seleStr.append("、" + str)
            }
            if seleStr.count > 0 { seleStr.remove(at: seleStr.startIndex) }
            self?.seleStrArray[section] = seleStr
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择客户
    private func seleCustomerHandle(section: Int) {
        let vc = NewlyBuildVisitSeleController()
        vc.isAdd = false
        vc.type = .customer
        vc.seleBlock = { [weak self] (customerArray) in
            let position = self?.projectPosition ?? 0
            self?.customerId = customerArray.first?.0 ?? -1
            self?.seleStrArray[section] = customerArray.first?.1 ?? ""
            // 重置数据 -> 防止出现选择项目后 修改客户
            self?.projectId = -1
            if position != -1 {
                self?.seleStrArray[position] = ""
                self?.tableView.reloadRows(at: [IndexPath(row: 0, section: position)], with: .none)
            }
            
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择项目
    private func seleProjectHandle(section: Int) {
        guard customerId != -1 else {
            MBProgressHUD.showError("请先选择客户")
            return
        }
        let customerName = seleStrArray.first ?? ""
        let vc = NewlyBuildVisitSeleController()
        vc.type = .project(customerId, customerName)
        vc.isAdd = false
        
        vc.seleBlock = { [weak self] (customerArray) in
            self?.projectId = customerArray.first?.0 ?? -1
            self?.seleStrArray[section] = customerArray.first?.1 ?? ""
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 数据处理
    private func dataHandld() {
        data.sort { (model1, model2) -> Bool in
            return model1.sort < model2.sort
        }
        for index in 0..<data.count {
            let model = data[index]
            if model.type == 7 { // 客户
                projectPosition = index
            }
            seleStrArray.append("")
        }
    }
    
    /// 添加抄送人处理
    private func addCarbonCopyHandle(indexPath: IndexPath) {
        let vc = SelePersonnelController()
        var prohibitIds = [Int]()
        for model in processUsersData.ccUsers {
            prohibitIds.append(model.checkUserId)
        }
        vc.prohibitIds = prohibitIds
        vc.displayData = ("请选择", "添加", .back)
        vc.backBlock = { [weak self] (users) in
            for model in users {
                var newModel = ProcessUsersCheckUsers()
                newModel.checkUserId = model.id
                newModel.realname = model.realname
                let position = model.roleList.count == 0 ? "员工" : model.roleList[0].name ?? "员工"
                newModel.roleName = position
                self?.carbonCopyData.append(newModel)
                self?.processUsersData.ccUsers.append(newModel)
            }
            self?.tableView.reloadRows(at: [indexPath], with: .none)
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 删除抄送人处理
    private func deleteCarbonCopyHandle(indexPath: IndexPath, row: Int) {
        let oldCount = processUsersData.ccUsers.count - carbonCopyData.count
        let deleteRow = row - oldCount
        carbonCopyData.remove(at: deleteRow)
        processUsersData.ccUsers.remove(at: row)
        tableView.reloadRows(at: [indexPath], with: .none)
        confirmHandle()
    }
    
    /// 处理添加人员
    private func addPersonnelHandle() {
        // 剩余的业绩百分比和提成百分比
        var achievemenhtsPercentage = 100
        var royaltyPercentage = 100
        for model in contractData {
            achievemenhtsPercentage -= Int(model.1) ?? 0
            royaltyPercentage -= Int(model.2) ?? 0
        }
        
        if achievemenhtsPercentage == 0 && royaltyPercentage == 0 {
            MBProgressHUD.showError("分配完毕，无法继续添")
            return
        }
        
        let ejectView = FillInApplyAddPersonnelEjectView()
        
        ejectView.maxInput = [achievemenhtsPercentage, royaltyPercentage]
        ejectView.determineBlock = { [weak self] (userData, achievemenhts, royalty) in
            self?.contractData.append((userData, achievemenhts, royalty))
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: self?.data.count ?? 0)], with: .none)
            self?.confirmHandle()
        }
        ejectView.seleBlock = { [weak self] in
            ejectView.isHidden = true
            let vc = SelePersonnelController()
            var prohibitIds = [Int]()
            for model in (self?.contractData)! {
                prohibitIds.append(model.0.id)
            }
            vc.prohibitIds = prohibitIds
            vc.isMultiple = false
            vc.displayData = ("选择人员", "选定", .back)
            vc.backBlock = { (users) in
                if users.count > 0 {
                    ejectView.userData = users[0]
                }
                ejectView.isHidden = false
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        ejectView.show()
    }
    
    /// 处理添加人员
    private func deletePersonnelHandle(index: Int) {
        let alertController = UIAlertController(title: "提示", message: "是否删除该合同人员", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (_) in
            self.contractData.remove(at: index)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: self.data.count)], with: .none)
            self.confirmHandle()
        }
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api
    /// 获取流程内容
    private func processParams() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.processParams(processId), t: ProcessParamsModel.self, successHandle: { (result) in
            self.data = result.data
            self.dataHandld()
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取流程内容失败,请下拉重新加载")
        })
    }
    
    /// 获取流程默认审批/抄送人
    private func processUsers() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.processUsers(processId), t: ProcessUsersModel.self, successHandle: { (result) in
            self.processUsersData = result.data
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "")
        })
    }
    
    /// 提交流程
    private func processCommit() {
        MBProgressHUD.showWait("")
        
        /// 数据
        var dataDic: [String:String] = [:]
        for index in 0..<data.count {
            let model = data[index]
            var contentStr = seleStrArray[index]
            if model.type == 3 { // 时间
                contentStr = "\(contentStr.getTimeStamp(customStr: "yyyy-MM-dd"))"
            } else if model.type == 6 { // 客户
                contentStr = "\(customerId)"
            } else if model.type == 7 { // 项目
                contentStr = "\(projectId)"
            }
            dataDic.updateValue(contentStr, forKey: model.name ?? "")
        }
        
        /// 成员
        var memberArray = [[String:String]]()
        if pricessType == 5 {
            for index in 0..<contractData.count {
                let model = contractData[index]
                var dic: [String:String] = [:]
                dic["userId"] = "\(model.0.id)"
                dic["propPerform"] = model.1
                dic["propMoney"] = model.2
                memberArray.append(dic)
            }
        }
        
        /// 抄送人
        var ccUsersArray = [[String:String]]()
        for index in 0..<carbonCopyData.count {
            let model = carbonCopyData[index]
            var dic: [String:String] = [:]
            dic["checkUser"] = "\(model.checkUserId)"
            dic["checkUserName"] = model.realname ?? ""
            ccUsersArray.append(dic)
        }
        
        _ = APIService.shared.getData(.processCommit(processId, dataDic, memberArray, ccUsersArray), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.showSuccess("申请成功")
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "申请失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击提交
    @objc private func submissionClick() {
        if pricessType == 5 {
            // 剩余的业绩百分比和提成百分比
            var achievemenhtsPercentage = 100
            var royaltyPercentage = 100
            for model in contractData {
                achievemenhtsPercentage -= Int(model.1) ?? 0
                royaltyPercentage -= Int(model.2) ?? 0
            }
            
            if achievemenhtsPercentage != 0 {
                MBProgressHUD.showError("业绩比例未分配完全")
                return
            } else if royaltyPercentage != 0 {
                MBProgressHUD.showError("提成比例未分配完全")
                return
            }
        }
        processCommit()
    }
}

extension FillInApplyController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if processUsersData != nil {
            return pricessType == 5 ? data.count + 3 : data.count + 2
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == data.count {
            if pricessType == 5 { // 合同人员
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyPersonnelCell", for: indexPath) as! FillInApplyPersonnelCell
                cell.data = contractData
                cell.addBlock = { [weak self] in
                    self?.addPersonnelHandle()
                    self?.confirmHandle()
                }
                cell.deleteBlock = { [weak self] (index) in
                    self?.deletePersonnelHandle(index: index)
                }
                return cell
            } else { // 审批人
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyApprovalCell", for: indexPath) as! FillInApplyApprovalCell
                cell.isApproval = true
                cell.data = processUsersData.checkUsers
                return cell
            }
        } else if section > data.count {
            if pricessType == 5 && section == data.count + 1 { // 审批人
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyApprovalCell", for: indexPath) as! FillInApplyApprovalCell
                cell.isApproval = true
                cell.data = processUsersData.checkUsers
                return cell
            } else { // 抄送
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyApprovalCell", for: indexPath) as! FillInApplyApprovalCell
                cell.isApproval = false
                let oldCount = processUsersData.ccUsers.count - carbonCopyData.count // 原本的抄送人数量
                cell.oldCount = oldCount
                cell.data = processUsersData.ccUsers
                cell.addBlock = { [weak self] in
                    self?.addCarbonCopyHandle(indexPath: indexPath)
                }
                cell.deleteBlock = { [weak self] (row) in
                    self?.deleteCarbonCopyHandle(indexPath: indexPath, row: row)
                }
                return cell
            }
        } else {
            let model = data[section]
            switch model.type {
            case 1: // 1.文本
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyTextViewCell", for: indexPath) as! FillInApplyTextViewCell
                cell.data = (model.title ?? "", model.hint ?? "")
                cell.contentStr = seleStrArray[section]
                cell.isMust = model.isNecessary == 1
                cell.inputBlock = { [weak self] (contentStr) in
                    self?.seleStrArray[section] = contentStr
                    self?.confirmHandle()
                }
                return cell
            case 2: // 2.数字
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyFieldViewCell", for: indexPath) as! FillInApplyFieldViewCell
                cell.data = (model.title ?? "", model.hint ?? "")
                cell.specialStr = seleStrArray[section]
                cell.isMust = model.isNecessary == 1
                cell.isSpecial = true
                cell.inputBlock = { [weak self] (contentStr) in
                    self?.seleStrArray[section] = contentStr
                    self?.confirmHandle()
                }
                return cell
            case 3, 4, 5, 6, 7: // 3.日期，4.单选，5.多选，6.客户，7.项目
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
                cell.data = (model.title ?? "", model.hint ?? "")
                cell.contentStr = seleStrArray[section]
                cell.isMust = model.isNecessary == 1
                return cell
            default: return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        guard section < data.count else {
            return
        }
        let model = data[section]
        switch model.type {
        case 3: // 3.日期
            seleTimeHandle(section: section)
        case 4: // 4.单选
            singleSeleHandle(section: section)
        case 5: // 5.多选
            multipleSeleHandle(section: section)
        case 6: // 6.客户
            seleCustomerHandle(section: section)
        case 7: // 7.项目
            seleProjectHandle(section: section)
        default: break
        }
    }
}
