//
//  NoticeHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  通知首页  控制器

import UIKit
import MJRefresh
import MBProgressHUD

class NoticeHomeController: UIViewController {

    /// 选择器
    private var segmentView: SegmentView!
    /// 装载tableview的滚动视图
    private var scrollView: UIScrollView!
    /// 待处理信息 tableview
    private var pendingTableView: UITableView!
    /// 系统信息 tableview
    private var systemTableView: UITableView!
    
    
    /// 审核数据
    private var pendingData = [NotifyCheckListData]()
    /// 系统数据
    private var systemData = [NotifyListData]()
    /// 审核页码
    private var pendingPage = 1
    /// 系统页码
    private var systemPage = 1
    /// 查看系统信息
    private var isCheckSystem = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.isNotification {
            AppDelegate.isNotification = false
            relaodData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        relaodData(show: false)
        notifyNumber()
    }
    
    func relaodData(show: Bool = true) {
        if show {
            segmentView.changeBtn(page: 1)
            scrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
        }
        notifyCheckList(isMore: false) // 获取待处理的初始数据
        notifyList(isMore: false) // 获取系统的初始数据
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        navigationItem.title = "通知"
        let nav = navigationController as! MainNavigationController
        nav.backBtn.isHidden = false
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
    }
    
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = .white
        edgesForExtendedLayout = .top
        
        segmentView = SegmentView(title: ["待处理", "系统消息"])
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(44)
                make.top.left.right.equalToSuperview()
            })
            .taxi.config({ (segmentView) in
                segmentView.delegate = self
//                segmentView.backgroundColor = UIColor.red
            })
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: view) // 装载tableview的滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(segmentView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
            .taxi.config({ (scrollView) in
                scrollView.backgroundColor = UIColor(hex: "#F3F3F3")
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.isPagingEnabled = true
                scrollView.delegate = self
            })
        
        pendingTableView = UITableView().taxi.adhere(toSuperView: scrollView) // 待处理信息 tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.height.width.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                
                let str = "暂无审批！"
                let attriMuStr = NSMutableAttributedString(string: str)
                attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
                attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
                tableView.noDataLabel?.attributedText = attriMuStr
                tableView.noDataImageView?.image = UIImage(named: "noneData1")
                
                tableView.register(NoticeHomePendingCell.self, forCellReuseIdentifier: "NoticeHomePendingCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.notifyCheckList(isMore: false)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.notifyCheckList(isMore: true)
                })
            })
        
        
        systemTableView = UITableView().taxi.adhere(toSuperView: scrollView) // 系统信息 tableView
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(pendingTableView.snp.right)
                make.top.right.height.width.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = kMainBackColor
                
                let str = "暂无通知！"
                let attriMuStr = NSMutableAttributedString(string: str)
                attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
                attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
                tableView.noDataLabel?.attributedText = attriMuStr
                tableView.noDataImageView?.image = UIImage(named: "noneData3")
                
                tableView.register(NoticeHomeSystemCell.self, forCellReuseIdentifier: "NoticeHomeSystemCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.notifyList(isMore: false)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.notifyList(isMore: true)
                })
            })
    }
    
//    @objc private func refuseClick() {
//        if checkListData.processType == 1 || checkListData.processType == 2 {
//            let view = SeleVisitModelView(title: "拒绝原因", content: ["已存在项目/客户", "名字不合理", "其它原因"])
//            view.didBlock = { [weak self] (seleIndex) in
//                self?.modifyEjectView(type: seleIndex)
//            }
//            view.show()
//        } else {
    
//        }
//    }
//
//    /// 点击同意
//    @objc private func agreeClick() {
//        if checkListData.processType == 1 || checkListData.processType == 2 {
//            agreeHandle()
//        } else {
//        }
//    }
    
    /// 点击同意处理
    private func agreeHandle(indexPath: IndexPath) {
//        let alertController = UIAlertController(title: "提示", message: "是否同意该信息?", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
//        alertController.addAction(cancelAction)
//        let agreeAction = UIAlertAction(title: "同意", style: .default, handler: { (_) in
//
//        })
//        alertController.addAction(agreeAction)
//        present(alertController, animated: true, completion: nil)
        let model = self.pendingData[indexPath.row]
        let vc = ToExamineCommentController()
        vc.title = (model.createdUserName ?? "") + "提交的《" + (model.processName ?? "") + "》"
        vc.checkListId = model.id
        vc.descType = .agree
        vc.commentBlock = { [weak self] in
            self?.notifyCheckList(isMore: false)
            self?.notifyList(isMore: false)
            self?.notifyNumber()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击拒绝处理
    private func refuseHandle(indexPath: IndexPath) {
//        let alertController = UIAlertController(title: "提示", message: "是否拒绝该信息?", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
//        alertController.addAction(cancelAction)
//        let agreeAction = UIAlertAction(title: "拒绝", style: .default, handler: { (_) in
//
//
//        })
//        alertController.addAction(agreeAction)
//        present(alertController, animated: true, completion: nil)
        let model = self.pendingData[indexPath.row]
        let vc = ToExamineCommentController()
        vc.title = (model.createdUserName ?? "") + "提交的《" + (model.processName ?? "") + "》"
        vc.checkListId = model.id
        vc.descType = .refuse
        vc.commentBlock = { [weak self] in
            self?.notifyCheckList(isMore: false)
            self?.notifyList(isMore: false)
            self?.notifyNumber()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 处理提示
    private func setTips() {
//        segmentView.setNumber(index: 0, number: pendingData.count)
        
//        tabBarController?.tabBar.items?[3].badgeValue = pendingData.count > 0 ? "\(pendingData.count)" : nil
        let isNotRead = tabBarController?.tabBar.itemStatus ?? false
        if isNotRead && !isCheckSystem { // 有数量  并且未读
            segmentView.setTips(index: 1, show: isNotRead)
            if pendingData.count == 0 {
                tabBarController?.tabBar.showBadgeOnItemIndex(index: 3)
            } else {
                tabBarController?.tabBar.hideBadgeOnItemIndex(index: 3)
            }
        } else {
            tabBarController?.tabBar.hideBadgeOnItemIndex(index: 3)
            segmentView.setTips(index: 1, show: false)
        }
        
        pendingTableView.isNoData = pendingData.count == 0
        systemTableView.isNoData = systemData.count == 0
    }
    
    // MARK: - Api
    /// 审核列表
    private func notifyCheckList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? pendingPage + 1 : 1
        _ = APIService.shared.getData(.notifyCheckList(nil, newPage, 10), t: NotifyCheckListModel.self, successHandle: { (result) in
            if isMore {
                for model in result.data {
                    self.pendingData.append(model)
                }
                self.pendingTableView.mj_footer.endRefreshing()
                self.pendingTableView.mj_header.isHidden = false
                self.pendingPage += 1
            } else {
                self.pendingPage = 1
                self.pendingData = result.data
                self.pendingTableView.mj_header.endRefreshing()
                self.pendingTableView.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.pendingTableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.pendingTableView.mj_footer.resetNoMoreData()
            }
            self.setTips()
            self.pendingTableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            if isMore {
                self.pendingTableView.mj_footer.endRefreshing()
                self.pendingTableView.mj_header.isHidden = false
            } else {
                self.pendingTableView.mj_header.endRefreshing()
                self.pendingTableView.mj_footer.isHidden = false
            }
            self.setTips()
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 系统通知
    private func notifyList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? systemPage + 1 : 1
        _ = APIService.shared.getData(.notifyList(newPage, 10), t: NotifyListModel.self, successHandle: { (result) in
            if isMore {
                for model in result.data {
                    self.systemData.append(model)
                }
                self.systemTableView.mj_footer.endRefreshing()
                self.systemTableView.mj_header.isHidden = false
                self.systemPage += 1
            } else {
                self.systemPage = 1
                self.systemData = result.data
                self.systemTableView.mj_header.endRefreshing()
                self.systemTableView.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.systemTableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.systemTableView.mj_footer.resetNoMoreData()
            }
            self.systemTableView.reloadData()
            MBProgressHUD.dismiss()
            self.setTips()
        }, errorHandle: { (error) in
            if isMore {
                self.systemTableView.mj_footer.endRefreshing()
                self.systemTableView.mj_header.isHidden = false
            } else {
                self.systemTableView.mj_header.endRefreshing()
                self.systemTableView.mj_footer.isHidden = false
            }
            self.setTips()
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 拒绝审批-非创建客户/项目
    private func notifyCheckReject(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = pendingData[index.row].id
        _ = APIService.shared.getData(.notifyCheckReject(checkId, [], [], ""), t: LoginModel.self, successHandle: { (result) in
            self.pendingTableView.beginUpdates()
            self.pendingData.remove(at: index.row)
            self.pendingTableView.deleteRows(at: [index], with: .fade)
            self.pendingTableView.endUpdates()
            MBProgressHUD.dismiss()
            self.setTips()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝审核 填写弹出框
    ///
    /// - Parameters:
    ///   - type: 类型  0：已存在  1：有误  2：其他
    ///   - index: 在tableView中的位置
    private func modifyEjectView(type: Int ,index: IndexPath) {
        if type != 2 { // 0：已存在  1：有误
            let ejectView = ModifyNoticeEjectView()
            ejectView.data = pendingData[index.row]
            if type == 0 {
                ejectView.modifyType = .alreadyExist
            } else {
                ejectView.modifyType = .unreasonable
            }
            ejectView.alreadyExistBlock = { [weak self] (idArray) in
                self?.notifyCheckCusRejectExist(index: index, id: idArray)
            }
            ejectView.unreasonableBlock = { [weak self] (contentArray) in
                self?.notifyCheckCusRejectMistake(index: index, conten: contentArray)
            }
            ejectView.show()
        } else { // 其他
            let ejectView = ReasonsRefusalEjectView()
            ejectView.checkId = pendingData[index.row].id
            ejectView.changeBlock = { [weak self] in // 刷新审核列表
                self?.notifyCheckList(isMore: false)
                self?.notifyList(isMore: false)
            }
            ejectView.show()
        }
    }
    
    /// 拒绝创建客户/项目-客户已存在
    private func notifyCheckCusRejectExist(index: IndexPath, id: [Int]) {
        MBProgressHUD.showWait("")
        let checkId = pendingData[index.row].id
        _ = APIService.shared.getData(.notifyCheckCusRejectExist(checkId, id[0], id[1]), t: LoginModel.self, successHandle: { (result) in
            self.pendingTableView.beginUpdates()
            self.pendingData.remove(at: index.row)
            self.pendingTableView.deleteRows(at: [index], with: .fade)
            self.pendingTableView.endUpdates()
            MBProgressHUD.dismiss()
            self.setTips()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝创建客户/项目-名称有误
    private func notifyCheckCusRejectMistake(index: IndexPath, conten: [String]) {
        MBProgressHUD.showWait("")
        let checkId = pendingData[index.row].id
        _ = APIService.shared.getData(.notifyCheckCusRejectMistake(checkId, conten[0], conten[1]), t: LoginModel.self, successHandle: { (result) in
            self.pendingTableView.beginUpdates()
            self.pendingData.remove(at: index.row)
            self.pendingTableView.deleteRows(at: [index], with: .fade)
            self.pendingTableView.endUpdates()
            MBProgressHUD.dismiss()
            self.setTips()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 同意审批
    private func notifyCheckAgree(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = pendingData[index.row].id
        _ = APIService.shared.getData(.notifyCheckAgree(checkId, [], [], ""), t: LoginModel.self, successHandle: { (result) in
            self.pendingData.remove(at: index.row)
            self.pendingTableView.reloadData()
            MBProgressHUD.dismiss()
            self.setTips()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }
    
    /// 全部已读
//    private func notifyReadAll() {
//        _ = APIService.shared.getData(.notifyReadAll, t: LoginModel.self, successHandle: { (_) in
//            self.setTips()
//        }, errorHandle: nil)
//    }
    
    // MARK: - Api
    ///设置已读
    func notifyCheckHaveRead(id:Int){
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckHaveRead(id), t: unreadValueModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.notifyList(isMore: false)
            self.systemTableView.reloadData()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "设置失败")
        })
    }
    
    /// 未读信息数
    private func notifyNumber() {
        _ = APIService.shared.getData(.notifyNumber, t: NotifyNumberModel.self, successHandle: { (result) in
            let checkNum = result.data?.checkNum ?? 0
            let notReadNum = result.data?.notReadNum ?? 0
            self.tabBarController?.tabBar.itemStatus = checkNum > 0
            if checkNum > 0 {
                self.segmentView.setNumber(index: 0, number: checkNum)
                
                self.tabBarController?.tabBar.items?[3].badgeValue = "\(checkNum)"
            } else if notReadNum > 0 {
                self.tabBarController?.tabBar.showBadgeOnItemIndex(index: 3)
            }
        }, errorHandle: nil)
    }
}

extension NoticeHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == pendingTableView {
            return pendingData.count
        } else {
            return systemData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == pendingTableView { // 待处理tableview
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeHomePendingCell", for: indexPath) as! NoticeHomePendingCell
            cell.data = (pendingData[indexPath.row], true)
            cell.agreeBlock = { [weak self] in // 同意
                self?.agreeHandle(indexPath: indexPath)
            }
            cell.refuseBlock = { [weak self] (type) in // 拒绝
                if type == nil {
                    self?.refuseHandle(indexPath: indexPath)
                } else {
                    self?.modifyEjectView(type: type!, index: indexPath)
                }
            }
            return cell
        } else { // 系统通知tableview
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeHomeSystemCell", for: indexPath) as! NoticeHomeSystemCell
            cell.data = systemData[indexPath.row]
            cell.isSystem = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == pendingTableView {
            let vc = ToExamineDetailsController()
            vc.checkListId = pendingData[indexPath.row].id
            vc.changeBlock = { [weak self] in
                self?.notifyCheckList(isMore: false)
                self?.notifyList(isMore: false)
            }
            navigationController?.pushViewController(vc, animated: true)
        } else {

            let model = systemData[indexPath.row]
            if model.type != "1" {
                if model.status == 0 {
                    notifyCheckHaveRead(id: model.id)
                }
            }
            switch model.type {
            case "1": break // 系统通知 无跳转
            case "2": // 审批通知 -> 审批详情
                
                let vc = ToExamineDetailsController()
                vc.checkListId = systemData[indexPath.row].checkId
                vc.changeBlock = { [weak self] in
                    self?.notifyCheckList(isMore: false)
                    self?.notifyList(isMore: false)
                }
                navigationController?.pushViewController(vc, animated: true)
            case "3": break // 工作交接 无跳转
            case "4": // 工作组 -> 项目详情，工作组选项卡
                let vc = ProjectDetailsController()
                vc.lockState = 1
                vc.projectId = systemData[indexPath.row].checkId
                navigationController?.pushViewController(vc, animated: true)
            case "5": // 拜访 -> 拜访详情
                let vc = VisitDetailsController()
                vc.visitListId = systemData[indexPath.row].checkId
                navigationController?.pushViewController(vc, animated: true)
            case "6":
                let vc = ContractDetailsController()
                vc.contractId = systemData[indexPath.row].checkId
                navigationController?.pushViewController(vc, animated: true)
            case "7"://汇报
                let vc = CheckReportDetailsViewController()
                vc.checkListId = systemData[indexPath.row].checkId
                navigationController?.pushViewController(vc, animated: true)
                
            case "8"://公告
                UIApplication.shared.keyWindow?.endEditing(true)
                let announcement = AnnouncementView()
                announcement.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
//                announcement.data = self.announcementData[indexPath.row]
                let data = systemData[indexPath.row]
//                announcement.data = data
                UIApplication.shared.delegate?.window??.addSubview(announcement)
            default: break
            }
        }
    }
}


extension NoticeHomeController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // 监听快速滑动，惯性慢慢停止
        if scrollView is UITableView {
            return
        }
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            let page = Int(scrollView.contentOffset.x / ScreenWidth)
            segmentView.changeBtn(page: page)
            if page == 1 && !isCheckSystem {
                isCheckSystem = true
//                notifyReadAll()
                setTips()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { // 手指控制直接停止
        if scrollView is UITableView {
            return
        }
        if !decelerate {
            let dragToDragStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if dragToDragStop {
                let page = Int(scrollView.contentOffset.x / ScreenWidth)
                segmentView.changeBtn(page: page)
                if page == 1 && !isCheckSystem {
                    isCheckSystem = true
//                    notifyReadAll()
                    setTips()
                }
            }
        }
    }
}

extension NoticeHomeController: SegmentViewDelegate {
    func changeScrollView(page: Int) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(page) * ScreenWidth, y: 0), animated: true)
        if page == 1 && !isCheckSystem {
            isCheckSystem = true
//            notifyReadAll()
            setTips()
        }
    }
}
