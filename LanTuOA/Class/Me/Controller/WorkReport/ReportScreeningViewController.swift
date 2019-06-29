//
//  ReportScreeningViewController.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD
class ReportScreeningViewController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    /// 提交按钮
    private var submissionBtn: UIButton!
    /// 审核人数据
    private var processUsersData: ProcessUsersData!
    /// 日志模版数据
    private var data = [WorkReportListData]()
    /// 添加的抄送人数据
    private var carbonCopyData = [ProcessUsersCheckUsers]()
    var itmeStr: String?
    /// 选中内容
    private var seleStrArray = [String]()
    private var isNotRead = 0
    private var processId = 0
    private var startTime = 0
    private var endTime = 0
    let titleArr = ["开始时间","结束时间"]
    var itmeArr = [[String:String]]()
    var  processName = ""
    var screeningBlack:((Int,[String],Int,Int,Int,[[String:String]]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "汇报筛选"
        initSubViews()
        workReporLogTemplateList()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = .white
        processUsersData = ProcessUsersData()
        seleStrArray = ["",""]
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
                btn.setTitle("提交", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = kMainColor
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(submissionClick), for: .touchUpInside)
            })
        
        
        tableView = UITableView(frame: .zero, style: .grouped).taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.sectionHeaderHeight = 0.01
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = kMainBackColor
                tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
                tableView.register(CheckReportTemplateFilterCell.self, forCellReuseIdentifier: "CheckReportTemplateFilterCell")
                tableView.register(CheckReportAddReceiveCell.self, forCellReuseIdentifier: "CheckReportAddReceiveCell")
                tableView.register(CheckReportTimeScreenCell.self, forCellReuseIdentifier: "CheckReportTimeScreenCell")
                tableView.register(CheckReportDidReadCell.self, forCellReuseIdentifier: "CheckReportDidReadCell")
            })
    }
    
    // MARK: - Api
    /// 获取模版数据
    ///
    private func workReporLogTemplateList(){
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.WorkReporLogTemplate, t: WorkReportListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.data = result.data
            self.tableView.reloadData()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }

    

    // MARK: - 按钮点击
    /// 点击提交
    @objc private func submissionClick() {
        /// 提交人id
//        itmeArr = []
        if processName != "" {
            let dic = ["name":processName,"index":"1"]
            itmeArr.append(dic as! [String : String])
        }
        startTime = seleStrArray[0].getTimeStamp(customStr: "yyyy-MM-dd")
        endTime = seleStrArray[1].getTimeStamp(customStr: "yyyy-MM-dd")
        
        if startTime != 0 && endTime != 0 {
            let dic = ["name":"\(seleStrArray[0])至\(seleStrArray[1])","index":"2"]
            itmeArr.append(dic)
        }else if startTime != 0 && endTime == 0{
//            itmeArr.append("\(seleStrArray[0])")
            let dic = ["name":"\(seleStrArray[0])","index":"2"]
            itmeArr.append(dic)
        }else if startTime == 0 && endTime != 0{
//            itmeArr.append("\(seleStrArray[1])")
            let dic = ["name":"\(seleStrArray[1])","index":"2"]
            itmeArr.append(dic)
        }
        if isNotRead == 1 {
            let dic = ["name":"未读","index":"3"]
            itmeArr.append(dic)
        }
        var commitUser = [String]()
        for index in 0..<carbonCopyData.count {
            let model = carbonCopyData[index]
            commitUser.append("\(model.checkUserId)")
            let dic = ["name":model.realname!,"index":"\(index+4)"]
            itmeArr.append(dic)
        }

        if screeningBlack != nil  {
            screeningBlack?(processId,commitUser,startTime,endTime,isNotRead,itmeArr)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /// 选择时间
    private func seleTimeHandle(indexPath: IndexPath) {
        UIApplication.shared.keyWindow?.endEditing(true)
        let row = indexPath.row
//        let section = indexPath.section
        let timeStr = seleStrArray[row-1]
        var timeStamp: Int!
        if timeStr.count > 0 {
            timeStamp = timeStr.getTimeStamp(customStr: "yyyy-MM-dd")
        }
        let ejectView = SeleTimeEjectView(timeStamp: timeStamp, titleStr: "选择时间")
        ejectView.determineBlock = { [weak self] (timeStamp) in
            
            let timeStr = Date(timeIntervalSince1970: TimeInterval(timeStamp)).customTimeStr(customStr: "yyyy-MM-dd")
            self?.seleStrArray[row-1] = timeStr
            self?.tableView.reloadRows(at: [indexPath], with: .none)
            

        }
        ejectView.show()
    }
    
    /// 添加抄送人处理
    private func addCarbonCopyHandle(indexPath: IndexPath) {
        let vc = SelePersonnelController()
//        vc.displayData = ("请选择", "添加", .back)
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
            self?.perform(#selector(self?.reloadRows(indexPath:)), with: indexPath, afterDelay: 0.1)
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
    }
    
    @objc private func reloadRows(indexPath: IndexPath) {
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension ReportScreeningViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 3
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckReportTemplateFilterCell", for: indexPath) as! CheckReportTemplateFilterCell
            cell.data = data
            cell.itmeStr = itmeStr
            cell.templateBlack = {[weak self] id ,name in
                self!.processId = id
                self!.processName = name
            }
            return cell
        }else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckReportAddReceiveCell", for: indexPath) as! CheckReportAddReceiveCell
            cell.data = processUsersData.ccUsers
            cell.addBlock = { [weak self] in
                self?.addCarbonCopyHandle(indexPath: indexPath)
            }
            cell.deleteBlock = { [weak self] (row) in
                self?.deleteCarbonCopyHandle(indexPath: indexPath, row: row)
            }
            return cell
        }else if section == 2 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckReportDidReadCell", for: indexPath) as! CheckReportDidReadCell
                cell.rightBtn.isHidden = true
                cell.titleLabel.text = "按时间筛选"
                cell.titleLabel.textColor = UIColor(hex: "#999999")
                cell.titleLabel.font = UIFont.medium(size: 14)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckReportTimeScreenCell", for: indexPath) as! CheckReportTimeScreenCell
                cell.titleLabel.text = titleArr[indexPath.row-1]
                cell.contentStr = seleStrArray[row-1]
                cell.deleteBtn.tag = indexPath.row-1
                cell.deleteBtn.addTarget(self, action: #selector(deleteCilck), for: .touchUpInside)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckReportDidReadCell", for: indexPath) as! CheckReportDidReadCell
            cell.titleLabel.text = "未读"
            cell.readBlck = {[weak self] index in
                self!.isNotRead = index
            }
            return cell
        }
    }
    
    @objc func deleteCilck(sender:UIButton){
//        seleStrArray.remove(at: sender.tag)
        seleStrArray[sender.tag] = ""
//        tableView.reloadRows(at: [indexPath], with: .none)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            
        }else if indexPath.section == 1 {
            
        }else if indexPath.section == 2 {
            if indexPath.row == 1 {
                seleTimeHandle(indexPath: indexPath)
            }else if indexPath.row == 2{
                seleTimeHandle(indexPath: indexPath)
            }
        }

    }
}

