//
//  CheckReportDetailsViewController.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit
import MBProgressHUD

class CheckReportDetailsViewController: UIViewController {

    /// 审批数据
    var checkListId = 0
    /// 修改回调
    var changeBlock: (() -> ())?
    /// tableview
    private var tableView: UITableView!
    /// 按钮框
    private var btnView: UIView!
    /// 评论
    private var commentBtn: UIButton!
    
    /// 汇报数据
    private var checkListData: NotifyCheckListData!
    /// 汇报评论数据
    private var commentListData = [NotifyCheckCommentListData]()
    /// 汇报详情中的图片数据
    private var imagesData = [NotifyCheckListValue]()
    /// 汇报详情中的文件数据
    private var filesData = [NotifyCheckListValue]()
    /// 汇报人数据
    private var checkUserData = [[NotifyCheckUserListData]]()
    /// 是否展开
    private var openArray = [Bool]()
    /// 抄送人数据
    private var carbonCopyData = [NotifyCheckUserListData]()
    /// 按钮视图高度约束
    private var btnConstraint: Constraint!
    
    let headview = ToExamineDetailsHeaderView()
    private var totalData = [NotifyCheckListSmallData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        notifyCheckDetail()
//        notifyCheckHaveRead()
        notifyCheckUserList()
        notifyCheckCommentList()
        
    }
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = .white
        
        btnView = UIView().taxi.adhere(toSuperView: view) // 按钮框
            .taxi.layout(snapKitMaker: { (make) in
                btnConstraint = make.height.equalTo(80).constraint
                make.bottom.left.right.equalToSuperview()
            })
            .taxi.config({ (view) in
                btnConstraint.activate()
                view.backgroundColor = .white
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
        
        _ = UIView().taxi.adhere(toSuperView: btnView)
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(5)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
        
        tableView = UITableView(frame: .zero, style: .grouped).taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 30
                tableView.sectionHeaderHeight = 0.01
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
//                tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
                tableView.tableHeaderView = headview
//                tableView.register(ToExamineDetailsHeaderCell.self, forCellReuseIdentifier: "ToExamineDetailsHeaderCell")
                tableView.register(ToExamineDetailsCell.self, forCellReuseIdentifier: "ToExamineDetailsCell")
                tableView.register(ToExamineDetailsSmallCell.self, forCellReuseIdentifier: "ToExamineDetailsSmallCell")
                tableView.register(ToExamineDetailsCarbonCopyCell.self, forCellReuseIdentifier: "ToExamineDetailsCarbonCopyCell")
                tableView.register(ToExamineImagesCell.self, forCellReuseIdentifier: "ToExamineImagesCell")
                tableView.register(ToExamineTitleCell.self, forCellReuseIdentifier: "ToExamineTitleCell")
                tableView.register(ToExamineEnclosureCell.self, forCellReuseIdentifier: "ToExamineEnclosureCell")
                tableView.register(ToExamineCommentNameCell.self, forCellReuseIdentifier: "ToExamineCommentNameCell")
                tableView.register(CheckReportDetailsReadCell.self, forCellReuseIdentifier: "CheckReportDetailsReadCell")
                
                tableView.register(ToExamineDetailsTitleCell.self, forCellReuseIdentifier: "ToExamineDetailsTitleCell")
                tableView.register(ToExamineFileImagesCell.self, forCellReuseIdentifier: "ToExamineFileImagesCell")
//                tableView.register(ToExamineDetailsCell.self, forCellReuseIdentifier: "ToExamineDetailsCell")
                tableView.register(WorkreportLocationCell.self, forCellReuseIdentifier: "WorkreportLocationCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.notifyCheckUserList()
                    self?.notifyCheckCommentList()
                })
            })
    }

    /// 修改处理
    private func changeHandle() {
        notifyCheckDetail()
        notifyCheckUserList()
        if changeBlock != nil {
            changeBlock!()
        }
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
    }
    
    /// 显示内容
    private func notifyCheckHandle() {
        if checkListData == nil {
            return
        }
        let smallData = checkListData.data
        totalData = checkListData.data
        headview.ishiddenNuber = true
        headview.data = checkListData
        
        let strData = smallData.filter { (model) -> Bool in
            return model.type < 4 && model.type > 0
        }
        checkListData.data = strData
        let imageData = smallData.filter { (model) -> Bool in
            return model.type == 4
        }
        
        for model in imageData {
            let imageValue = model.fileArr
            for value in imageValue {
                imagesData.append(value)
            }
        }
        
        let fileData = smallData.filter { (model) -> Bool in
            return model.type == 5
        }
        for model in fileData {
            let fileValue = model.fileArr
            for value in fileValue {
                filesData.append(value)
            }
        }


    }
    
    /// 过滤文档、图片数据
    private func filterData(_ data: [NotifyCheckListValue]) -> ([NotifyCheckListValue], [NotifyCheckListValue]) {
        let images = data.filter { (model) -> Bool in
            return model.fileType == 1
        }
        let files = data.filter { (model) -> Bool in
            return model.fileType == 2
        }
        return (images, files)
    }
    
    /// 打开文件
    private func openFile(_ model: NotifyCheckListValue) {
        let objectName = model.objectName ?? ""
        let fileName = model.fileName ?? ""
        let type = fileName.components(separatedBy: ".").last ?? ""
        if type == "docx" || type == "png" || type == "jpg" || type == "jpeg" {
            MBProgressHUD.showWait("")
            let path = "/Approval/\(model.fileId)/" + fileName
            AliOSSClient.shared.download(url: objectName, path: path, isCache: true) { (data) in
                DispatchQueue.main.async(execute: {
                    if data != nil {
                        if #available(iOS 9.0, *) {
                            MBProgressHUD.dismiss()
                            let vc = WebController()
                            vc.enclosure = path
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            MBProgressHUD.showError("系统版本过低，无法预览")
                        }
                    } else {
                        MBProgressHUD.showError("打开失败，请重试")
                    }
                })
                
            }
        } else {
            MBProgressHUD.showError("不支持浏览该类型文件")
        }
    }
    
    
    // MARK: - APi
    /// 获取汇报详情
    private func notifyCheckDetail() {
        _ = APIService.shared.getData(.WorkReporCheckListDetail(checkListId), t: NotifyCheckDetailModel.self, successHandle: { (result) in
            self.checkListData = result.data
            self.notifyCheckHandle()
            self.title = result.data?.processName ?? ""
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取审批人失败")
        })
    }

    /// 审批人列表
    private func  notifyCheckUserList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.WorkReporCheckListDetailRecipient(checkListId), t: NotifyCheckUserListModel.self, successHandle: { (result) in
            self.checkUserListHandle(data: result.data)
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取审批人失败")
        })
    }
    
    /// 审批评论列表
    private func notifyCheckCommentList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckCommentList(checkListId), t: NotifyCheckCommentListModel.self, successHandle: { (result) in
            self.commentListData = result.data
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取评论列表失败")
        })
    }
    
    /// 拒绝审核 填写弹出框
    ///
    /// - Parameter type: 0：已存在  1：有误  2：其他
    private func modifyEjectView(type: Int) {
        if type != 2 { // 0：已存在  1：有误
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
        } else { // 其他
            let ejectView = ReasonsRefusalEjectView()
            ejectView.checkId = checkListData.id
            ejectView.changeBlock = { [weak self] in // 刷新审核列表
                self?.notifyCheckUserList()
            }
            ejectView.show()
        }
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
        _ = APIService.shared.getData(.notifyCheckAgree(checkId, [], [], ""), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.changeHandle()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }

    /// MARK: - 按钮点击
    /// 点击拒绝
    @objc private func refuseClick() {
        if checkListData.processType == 1 || checkListData.processType == 2 {
            let view = SeleVisitModelView(title: "拒绝原因", content: ["已存在项目/客户", "名字不合理", "其它原因"])
            view.didBlock = { [weak self] (seleIndex) in
                self?.modifyEjectView(type: seleIndex)
            }
            view.show()
        } else {
            let vc = ToExamineCommentController()
            vc.title = (checkListData.createdUserName ?? "") + "提交的《" + (checkListData.processName ?? "") + "》"
            vc.checkListId = checkListId
            vc.descType = .refuse
            vc.commentBlock = { [weak self] in
                self?.changeHandle()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func commentClick() {
        let vc = ToExamineCommentController()
        vc.title = (checkListData.createdUserName ?? "") + "提交的《" + (checkListData.processName ?? "") + "》"
        vc.checkListId = checkListId
        vc.descType = .approval
        vc.commentBlock = { [weak self] in
            self?.tableView.mj_header.beginRefreshing()
            self?.changeHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension CheckReportDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if checkListData == nil { // 没有获取到详情 不显示
            return 0
        }
//        return checkUserData.count + (checkListData != nil ? 2 : 0) + commentListData.count + (carbonCopyData.count > 0 ? 1 : 0)//原始
        return (checkListData != nil ? 1 : 0) + commentListData.count + checkUserData.count + (carbonCopyData.count > 0 ? 1 : 0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 { // 评论详情
            return totalData.count
        }else if section == commentListData.count + checkUserData.count + 1 {
            return 1
        }
        else if section < checkUserData.count + 1 { /// 中间评论人
            let datas = checkUserData[section - 1]
            var data = checkUserData[section - 1][0]
            if datas.count > 1 {
                let processedModel = datas.filter { (model1) -> Bool in // 处理过数据
                    return model1.status == 2 || model1.status == 3
                }
                if processedModel.count != 0 {
                    data = processedModel[0]
                }
            }
            let model = filterData(data.files)
            let imageArray = model.0
            let fileArray = model.1
            let isOpen = openArray[section - 1]
            return isOpen ? (checkUserData[section - 1].count + 1) : (1 + (imageArray.count > 0 ? 1 : 0) + fileArray.count)
        }
        else  { // 评论
            let files = commentListData[section - 1 - checkUserData.count].commentsFiles
            let model = filterData(files)
            let imageArray = model.0
            let fileArray = model.1
            return 1 + fileArray.count + (imageArray.count > 0 ? 1 : 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 { // 顶部信息
            if totalData[row].type == 4 && totalData[row].fileArr.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineTitleCell", for: indexPath) as! ToExamineTitleCell
                cell.titleStr = totalData[row].title
                cell.isApproval = true
                let imageValue = totalData[row].fileArr
                var img = [NotifyCheckListValue]()
                for value in imageValue {
                    img.append(value)
                }
                cell.datas = img
                return cell
            } else if totalData[row].type == 5 && totalData[row].fileArr.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineFileImagesCell", for: indexPath) as! ToExamineFileImagesCell
                cell.titleStr = totalData[row].title
                cell.isApproval = true
                let filesValue = totalData[row].fileArr
                var files = [NotifyCheckListValue]()
                for value in filesValue {
                    files.append(value)
                }
                cell.datas = files
                return cell
            }else if totalData[row].type == 6 {//定位信息
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkreportLocationCell", for: indexPath) as! WorkreportLocationCell
                cell.addressStr = totalData[row].value
                cell.titleStr = totalData[row].title
                return cell
            }

            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsTitleCell", for: indexPath) as! ToExamineDetailsTitleCell
                cell.data = totalData[row]
                return cell
            }
        }
        else if section == checkUserData.count + 1 + commentListData.count { // 已读，未读
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckReportDetailsReadCell", for: indexPath) as! CheckReportDetailsReadCell
            cell.carbonCopyData = carbonCopyData
            cell.moreBlock = {
                NSLog("更多")
            }
            return cell
        }
        else if section < checkUserData.count + 1  {
            let isOpen = openArray[section - 1]
            if row == 0 { // 审核人信息 or 多人审批
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsCell", for: indexPath) as! ToExamineDetailsCell
                let step = checkListData != nil ? checkListData.step : 0
                cell.data = (checkUserData[section - 1], step >= checkUserData[section - 1][0].sort, section - 0 == checkUserData.count, openArray[section - 1])
                return cell
            } else if isOpen { // 展开的审核人
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsSmallCell", for: indexPath) as! ToExamineDetailsSmallCell
                let userListModel = checkUserData[section - 1]
                cell.data = (userListModel[row - 1], row == userListModel.count, checkListData.step >= userListModel[0].sort)
                return cell
            } else { // 图片和附件cell
                let datas = checkUserData[section - 1]
                var data = checkUserData[section - 1][0]
                if datas.count > 1 {
                    let processedModel = datas.filter { (model1) -> Bool in // 处理过数据
                        return model1.status == 2 || model1.status == 3
                    }
                    if processedModel.count != 0 {
                        data = processedModel[0]
                    }
                }
                let model = filterData(data.files)
                let imageArray = model.0
                let fileArray = model.1
                if imageArray.count > 0 && row == 1 { // 显示图片
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineImagesCell", for: indexPath) as! ToExamineImagesCell
                    cell.isApproval = true
                    cell.datas = imageArray
                    cell.isComment = false
                    return cell
                } else { // 显示附件
                    let index = imageArray.count > 0 ? 1 : 0
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineEnclosureCell", for: indexPath) as! ToExamineEnclosureCell
                    cell.data = fileArray[row - index - 1]
                    cell.isDelete = false
                    cell.isComment = false
                    return cell
                }
            }
        }
        else {
            let files = commentListData[section - 1 - checkUserData.count ].commentsFiles
            let model = filterData(files)
            let imageArray = model.0
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineCommentNameCell", for: indexPath) as! ToExamineCommentNameCell
                cell.data = commentListData[section - 1 - checkUserData.count]
                return cell
            } else if row == 1 && imageArray.count > 0 { // 图片
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineImagesCell", for: indexPath) as! ToExamineImagesCell
                cell.isApproval = true
                cell.datas = imageArray
                cell.isComment = true
                return cell
            }
            else {
                let index = imageArray.count > 0 ? 1 : 0
                let fileArray = model.1
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineEnclosureCell", for: indexPath) as! ToExamineEnclosureCell
                cell.data = fileArray[row - index - 1]
                cell.isDelete = false
                cell.isComment = true
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if commentListData.count > 0 {
                return 40
            } else {
                return 10
            }
        } else if section == 1 { // 审批人尾部
            return 10
        } else if section == checkUserData.count + 1 + commentListData.count { // 评论尾部
            return 10
        } else if section == checkUserData.count + commentListData.count { // 抄送人尾部
            return 10
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            if commentListData.count > 0 {
                return commentFooterView()
            } else {
                return grayFooterView()
            }
        } else if section == 1 { // 审批人尾部
           return grayFooterView()
        } else if section == checkUserData.count + 1 + commentListData.count { // 评论尾部
            return grayFooterView()
        } else if section == checkUserData.count + 2 + commentListData.count { // 抄送人尾部
            return grayFooterView()
        }
        return nil
    }
    
    func grayFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        return footerView
    }
    
    func commentFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
        footerView.backgroundColor = .clear
        _ = UILabel().taxi.adhere(toSuperView: footerView)
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "评论"
                label.font = UIFont.regular(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        if section == 0 { // 评论详情
//            let index = imagesData.count > 0 ? 3 : 1
//            if row > index {
//                openFile(filesData[row - index - 1])
//            }
        }else if section == commentListData.count + checkUserData.count + 1 {
            
        }else if section < checkUserData.count + 1 { /// 中间评论人
            let isOpen = openArray[section - 1]
            if indexPath.row == 0 {
                let model = checkUserData[section - 1]
                if model.count > 1 {
                    let processedModel = model.filter { (model1) -> Bool in // 处理过数据
                        return model1.status == 2 || model1.status == 3
                    }
                    if processedModel.count == 0 {
                        openArray[section - 1] = !openArray[section - 1]
                        tableView.reloadSections(IndexSet(integer: section), with: .fade)
                    }
                }
            } else if !isOpen { // 点击图片或文件
                let datas = checkUserData[section - 1]
                var data = checkUserData[section - 1][0]
                if datas.count > 1 {
                    let processedModel = datas.filter { (model1) -> Bool in // 处理过数据
                        return model1.status == 2 || model1.status == 3
                    }
                    if processedModel.count != 0 {
                        data = processedModel[0]
                    }
                }
                let model = filterData(data.files)
                let imageArray = model.0
                let fileArray = model.1
                if imageArray.count > 0 && row == 1 { // 显示图片
                } else { // 点击文件
                    let index = imageArray.count > 0 ? 2 : 1
                    openFile(fileArray[row - index])
                }
            }
        }
        else  { // 评论
            let files = commentListData[section - 1 - checkUserData.count].commentsFiles
            let model = filterData(files)
            let imageArray = model.0
            let fileArray = model.1
            let index = imageArray.count > 0 ? 2 : 1
            if row >= index {
                openFile(fileArray[row - index])
            }
        }
    }
}
