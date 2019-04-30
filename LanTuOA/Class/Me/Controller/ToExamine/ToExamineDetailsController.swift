//
//  ToExamineDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审核详情   控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ToExamineDetailsController: UIViewController {

    /// 审批数据
    var checkListId = 0
    /// 修改回调
    var changeBlock: (() -> ())?
    
    
    /// tableview
    private var tableView: UITableView!
    /// 按钮框
    private var btnView: UIView!
    
    /// 审批数据
    private var checkListData: NotifyCheckListData!
    /// 审批人数据
    private var checkUserData = [[NotifyCheckUserListData]]()
    /// 是否展开
    private var openArray = [Bool]()
    /// 抄送人数据
    private var carbonCopyData = [NotifyCheckUserListData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        notifyCheckDetail()
        notifyCheckUserList()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "审核详情"
        view.backgroundColor = .white
        
        btnView = UIView().taxi.adhere(toSuperView: view) // 按钮框
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(62 + (isIphoneX ? SafeH : 18))
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
            })
        
        _ = UIButton().taxi.adhere(toSuperView: btnView) // 拒绝按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo((ScreenWidth - 45) / 2).priority(800)
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(18)
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.setTitle("拒绝", for: .normal)
                btn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
                
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor(hex: "#2E4695").cgColor
                btn.addTarget(self, action: #selector(refuseClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: btnView) // 同意按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo((ScreenWidth - 45) / 2).priority(800)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(18)
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.setTitle("同意", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.backgroundColor = UIColor(hex: "#2E4695")
                btn.addTarget(self, action: #selector(agreeClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(ToExamineDetailsHeaderCell.self, forCellReuseIdentifier: "ToExamineDetailsHeaderCell")
                tableView.register(ToExamineDetailsCell.self, forCellReuseIdentifier: "ToExamineDetailsCell")
                tableView.register(ToExamineDetailsSmallCell.self, forCellReuseIdentifier: "ToExamineDetailsSmallCell")
                tableView.register(ToExamineDetailsCarbonCopyCell.self, forCellReuseIdentifier: "ToExamineDetailsCarbonCopyCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.notifyCheckUserList()
                })
            })
    }
    
    /// 修改处理
    private func changeHandle() {
        btnView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        notifyCheckDetail()
        notifyCheckUserList()
        if changeBlock != nil {
            changeBlock!()
        }
    }
    
    /// 点击同意处理
    private func agreeHandle() {
        let alertController = UIAlertController(title: "提示", message: "是否同意该申请?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "同意", style: .default, handler: { (_) in
            self.notifyCheckAgree()
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 审批人列表数据处理
    private func checkUserListHandle(data: [NotifyCheckUserListData]) {
        for index in 1...data.count {
            var checkUser = [NotifyCheckUserListData]()
            checkUser = data.filter({ (model) -> Bool in
                return model.sort == index && model.type == 1
            })
            if checkUser.count > 0 {
                checkUserData.append(checkUser)
                openArray.append(false)
            }
        }
        let aa = data.filter({ (model) -> Bool in
            return model.type == 2
        })
        print(aa)
        carbonCopyData = data.filter({ (model) -> Bool in
            return model.type == 2
        })
    }
    
    // MARK: - APi
    /// 获取审批详情
    private func notifyCheckDetail() {
        _ = APIService.shared.getData(.notifyCheckDetail(checkListId), t: NotifyCheckDetailModel.self, successHandle: { (result) in
            self.checkListData = result.data
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取审批人失败")
        })
    }
    
    /// 审批人列表
    private func  notifyCheckUserList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckUserList(checkListId), t: NotifyCheckUserListModel.self, successHandle: { (result) in
            self.checkUserListHandle(data: result.data)
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取审批人失败")
        })
    }
    
    /// 拒绝审核 填写弹出框
    ///
    /// - Parameter type: 0：已存在  1：有误
    private func modifyEjectView(type: Int) {
        let ejectView = ModifyNoticeEjectView()
        ejectView.data = checkListData
        if type == 0 {
            ejectView.modifyType = .alreadyExist
        } else {
            ejectView.modifyType = .unreasonable
        }
        ejectView.alreadyExistBlock = { [weak self] (idArray) in
            self?.notifyCheckCusRejectExist(id: idArray)
        }
        ejectView.unreasonableBlock = { [weak self] (contentArray) in
            self?.notifyCheckCusRejectMistake(conten: contentArray)
        }
        ejectView.show()
    }
    
    /// 拒绝创建客户/项目-客户已存在
    private func notifyCheckCusRejectExist(id: [Int]) {
        MBProgressHUD.showWait("")
        let checkId = checkListData.id
        _ = APIService.shared.getData(.notifyCheckCusRejectExist(checkId, id[0], id[1]), t: LoginModel.self, successHandle: { (result) in
            self.changeHandle()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝创建客户/项目-名称有误
    private func notifyCheckCusRejectMistake(conten: [String]) {
        MBProgressHUD.showWait("")
        let checkId = checkListData.id
        _ = APIService.shared.getData(.notifyCheckCusRejectMistake(checkId, conten[0], conten[1]), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.changeHandle()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    
    
    /// 同意审批
    private func notifyCheckAgree() {
        MBProgressHUD.showWait("")
        let checkId = checkListData.id
        _ = APIService.shared.getData(.notifyCheckAgree(checkId, ""), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.changeHandle()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }
    
    
    // MARK: - 按钮点击
    /// 点击拒绝
    @objc private func refuseClick() {
        if checkListData.processType == 1 || checkListData.processType == 2 {
            let view = SeleVisitModelView(title: "拒绝原因", content: ["已存在项目/客户/拜访人", "名字不合理"])
            view.didBlock = { [weak self] (seleIndex) in
                self?.modifyEjectView(type: seleIndex)
            }
            view.show()
        } else {
            let vc = ToExamineDescController()
            vc.checkId = checkListData.id
            vc.descType = .refuse
            vc.changeBlock = { [weak self] in
                self?.changeHandle()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// 点击同意
    @objc private func agreeClick() {
        if checkListData.processType == 1 || checkListData.processType == 2 {
            agreeHandle()
        } else {
            let vc = ToExamineDescController()
            vc.checkId = checkListData.id
            vc.descType = .agree
            vc.changeBlock = { [weak self] in
                self?.changeHandle()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ToExamineDetailsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if checkListData == nil { // 没有获取到详情 不显示
            return 0
        }
        return (checkUserData.count > 0 ? checkUserData.count + 1 : 0) + (checkListData != nil ? 2 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 || section > checkUserData.count + 1 {
            return 1
        } else {
            let isOpen = openArray[section - 2]
            return isOpen ? checkUserData[section - 2].count + 1 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsHeaderCell", for: indexPath) as! ToExamineDetailsHeaderCell
            cell.data = checkListData
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsCell", for: indexPath) as! ToExamineDetailsCell
            cell.notifyCheckListData = checkListData
            return cell
        } else if section > checkUserData.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsCarbonCopyCell", for: indexPath) as! ToExamineDetailsCarbonCopyCell
            cell.carbonCopyData = carbonCopyData
            return cell
        } else {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsCell", for: indexPath) as! ToExamineDetailsCell
                let step = checkListData != nil ? checkListData.step : 0
                cell.data = (checkUserData[section - 2], step <= checkUserData[section - 2][0].sort, section - 1 == checkUserData.count, openArray[section - 2])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsSmallCell", for: indexPath) as! ToExamineDetailsSmallCell
                let userListModel = checkUserData[section - 2]
                cell.data = (userListModel[row - 1], row == userListModel.count, checkListData.step <= userListModel[0].sort)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 || section == checkUserData.count + 1 ? 10 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 || section == checkUserData.count + 1 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
            footerView.backgroundColor = UIColor(hex: "#F3F3F3")
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section >= 2 && section < checkUserData.count + 2 && indexPath.row == 0 {
            let model = checkUserData[section - 2]
            if model.count > 1 { // 多人或签
                openArray[section - 2] = !openArray[section - 2]
                tableView.reloadSections(IndexSet(integer: section), with: .fade)
            }
        }
    }
}
