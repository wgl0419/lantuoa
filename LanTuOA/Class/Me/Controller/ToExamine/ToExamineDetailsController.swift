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
    /// 状态图标
    private var statusImageView: UIImageView!
    /// 按钮框
    private var btnView: UIView!
    /// 同意按钮
    private var agreeBtn: UIButton!
    /// 拒绝按钮
    private var refuseBtn: UIButton!
    /// 评论
    private var commentBtn: UIButton!
    
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
        view.backgroundColor = .white
        
        btnView = UIView().taxi.adhere(toSuperView: view) // 按钮框
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(0)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
            })
        
        agreeBtn = UIButton().taxi.adhere(toSuperView: btnView) // 同意按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(18)
                make.height.equalTo(44)
                make.width.equalTo(80)
            })
            .taxi.config({ (btn) in
                btn.setTitle("同意", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.backgroundColor = UIColor(hex: "#2E4695")
                btn.addTarget(self, action: #selector(agreeClick), for: .touchUpInside)
            })
        
        refuseBtn = UIButton().taxi.adhere(toSuperView: btnView) // 拒绝按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalTo(agreeBtn.snp.left).offset(-15)
                make.top.equalToSuperview().offset(18)
                make.height.equalTo(44)
                make.width.equalTo(80)
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
        
        
        commentBtn = UIButton().taxi.adhere(toSuperView: btnView) // 评论按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(18)
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.setTitle("留言评论", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 10)
                btn.setImage(UIImage(named: "comment"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.setImage(UIImage(named: "comment"), for: .highlighted)
                btn.addTarget(self, action: #selector(commentClick), for: .touchUpInside)
            })
        commentBtn.setSpacing()
        
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
        
        statusImageView = UIImageView().taxi.adhere(toSuperView: tableView) // 状态图标
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalTo(view).offset(-7)
                make.top.equalToSuperview().offset(9)
            })
    }
    
    /// 修改处理
    private func changeHandle() {
        agreeBtn.isHidden = true
        refuseBtn.isHidden = true
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
        checkUserData = []
        openArray = []
        for index in 0...data.count { // 本来从1开始  但是如果没有审批人时会报错
            var checkUser = [NotifyCheckUserListData]()
            checkUser = data.filter({ (model) -> Bool in
                return model.sort == index && model.type == 1
            })
            if checkUser.count > 0 {
                checkUserData.append(checkUser)
                openArray.append(false)
            }
        }
        
        carbonCopyData = data.filter({ (model) -> Bool in
            return model.type == 2
        })
        judgeStage()
    }
    
    /// 状态图片处理
    private func statusHandle() {
        if checkListData.status == 1 {
            statusImageView.image = UIImage()
        } else if checkListData.status == 2 {
            statusImageView.image = UIImage(named: "approval_agree")
        } else {
            statusImageView.image = UIImage(named: "approval_refuse")
        }
    }
    
    // 判断是否是自己处理阶段
    private func judgeStage() {
        if checkListData != nil && checkUserData.count != 0 { // 顶部数据和审核人数据并存状态
            let currentData = checkUserData.filter { (model) -> Bool in // 当前的数据
                return model[0].sort == checkListData.step
            }
            if currentData.count > 0 {
                let currentModel = currentData[0].filter { (model) -> Bool in
                    return model.`self` == 1
                }
                if currentModel.count != 0 && checkListData.status != 2 && checkListData.status != 3 { // 到自己处理的阶段   展开同意拒绝按钮
                    
                } else {
                    agreeBtn.isHidden = true
                    refuseBtn.isHidden = true
                }
            }
        }
    }
    
    // MARK: - APi
    /// 获取审批详情
    private func notifyCheckDetail() {
        _ = APIService.shared.getData(.notifyCheckDetail(checkListId), t: NotifyCheckDetailModel.self, successHandle: { (result) in
            self.checkListData = result.data
            self.title = result.data?.processName ?? ""
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
            self.statusHandle()
            self.judgeStage()
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
            let view = SeleVisitModelView(title: "拒绝原因", content: ["已存在项目/客户/拜访对象", "名字不合理"])
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
    
    @objc private func commentClick() {
        let vc = ToExamineCommentController()
        navigationController?.pushViewController(vc, animated: true)
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
        if section == 0 { // 顶部信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsHeaderCell", for: indexPath) as! ToExamineDetailsHeaderCell
            cell.data = checkListData
            return cell
        } else if section == 1 { // 业务人员信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsCell", for: indexPath) as! ToExamineDetailsCell
            cell.notifyCheckListData = checkListData
            return cell
        } else if section > checkUserData.count + 1 { // 抄送人信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsCarbonCopyCell", for: indexPath) as! ToExamineDetailsCarbonCopyCell
            cell.carbonCopyData = carbonCopyData
            return cell
        } else {
            if row == 0 { // 审核人信息 or 多人审批
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsCell", for: indexPath) as! ToExamineDetailsCell
                let step = checkListData != nil ? checkListData.step : 0
                cell.data = (checkUserData[section - 2], step >= checkUserData[section - 2][0].sort, section - 1 == checkUserData.count, openArray[section - 2])
                return cell
            } else { // 展开的审核人
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsSmallCell", for: indexPath) as! ToExamineDetailsSmallCell
                let userListModel = checkUserData[section - 2]
                cell.data = (userListModel[row - 1], row == userListModel.count, checkListData.step >= userListModel[0].sort)
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
            footerView.backgroundColor = .clear
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section >= 2 && section < checkUserData.count + 2 && indexPath.row == 0 {
            let model = checkUserData[section - 2]
            if model.count > 1 {
                let processedModel = model.filter { (model1) -> Bool in // 处理过数据
                    return model1.status == 2 || model1.status == 3
                }
                if processedModel.count == 0 {
                    openArray[section - 2] = !openArray[section - 2]
                    tableView.reloadSections(IndexSet(integer: section), with: .fade)
                }
            }
        }
    }
}
