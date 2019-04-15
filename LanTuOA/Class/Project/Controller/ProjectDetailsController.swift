//
//  ProjectDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情 控制器

import UIKit
import MBProgressHUD

class ProjectDetailsController: UIViewController {

    /// 数据修改
    var editBlock: ((ProjectListStatisticsData) -> ())?
    /// 锁定状态 （1：显示锁图标  2：无状态）
    var lockState = 1
    /// 项目id
    var projectData: ProjectListStatisticsData!
    
    /// 顶部视图
    private var headerView: ProjectDetailsHeaderView!
    /// 展示tableview的滚动视图
    private var scrollView: UIScrollView!
    /// 选择器
    private var segment: ProjectDetailsSegmentedView!
    
    
    /// 顶部视图的高度
    private var headerHeight: CGFloat = 235
    /// tableview滚动offsetY
    private var offsetY: CGFloat = 0
    /// tableview数组
    private var tableViewArray = [ProjectDetailsTableView]()
    /// 记录上一次scrollView滚动的位置
    private var offsetX: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav(_ titleStr: String) {
        title = "项目详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: titleStr,
                                                            titleColor: .white,
                                                            titleFont: UIFont.medium(size: 15),
                                                            titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                            target: self,
                                                            action: #selector(rightClick))
    }
    
    /// 初始化子控件
    private func initSubViews() {
        
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: view) // 滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (scrollView) in
                scrollView.bounces = false
                scrollView.delegate = self
                scrollView.isPagingEnabled = true
            })
        
        headerView = ProjectDetailsHeaderView(state: lockState)
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
            })
            .taxi.config({ (view) in
                let lock = lockState == 1 ? projectData.isLock : 2
                view.data = (projectData, lock)
                view.modifyBlock = { // 点击修改
                    let ejectView = EditProjectEjectView()
                    ejectView.projectData = self.projectData
                    ejectView.pushBlock = { [weak self] in
                        ejectView.isHidden = true
                        let vc = ProjectManageSeleController()
                        vc.title = "选择主管"
                        vc.backBlock = { (idArray, nameArray) in
                            ejectView.isHidden = false
                            if idArray.count != 0 {
                                ejectView.manage = (idArray.first!, nameArray.first!)
                            }
                        }
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    ejectView.eidtBlock = { (address, manageName, manageId) in
                        self.projectData.address = address
                        self.projectData.manageUser = manageId
                        self.projectData.manageUserName = manageName
                        view.data = (self.projectData, lock)
                        self.block()
                    }
                    ejectView.show()
                }
            })
        
        headerView.layoutIfNeeded() // 立即获得layout后的真实view尺寸
        headerHeight = headerView.height // 并保存
        
        if lockState != 2 {
            setNav(projectData.isLock == 0 ? "锁定项目" : "解锁项目")
        }
        let titleArray = lockState == 2 ? ["历史拜访"] : ["参与人员", "历史拜访", "工作组"]
        segment = ProjectDetailsSegmentedView(title: titleArray)
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(headerView.snp.bottom)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (segment) in
                segment.changeBlock = { [weak self] (page) in
                    self?.scrollView.setContentOffset(CGPoint(x: ScreenWidth * CGFloat(page), y: 0), animated: true)
                    self?.setTableViewOffsetY(tableView: (self?.tableViewArray[page])!)
                }
            })
        
        addTableView()
    }
    
    /// 添加tableview
    private func addTableView() {
        var lastTableView: ProjectDetailsTableView!
        for index in 0..<3 { // 添加3个tableview
            let tableView = ProjectDetailsTableView(style: ProjectDetailsTableView.CellStyle(rawValue: index)!, height: headerHeight, projectId: projectData.id) // tableview
                .taxi.adhere(toSuperView: scrollView)
                .taxi.layout { (make) in
                    if index == 0 {
                        make.left.equalToSuperview()
                    } else {
                        make.left.equalTo(lastTableView.snp.right)
                    }
                    make.width.top.height.equalToSuperview()
                    if index == 2 {
                        make.right.equalToSuperview()
                    }
                }
                .taxi.config { (tableView) in
                    tableView.lockState = projectData.isLock
                    tableView.scrollBlock = { (offsetY) in
                        let changeY = offsetY < -self.headerHeight - 40 ? 0 : offsetY >= -40 ? -self.headerHeight : -self.headerHeight - offsetY - 40
                        self.headerView.snp.updateConstraints({ (make) in
                            make.top.equalToSuperview().offset(changeY)
                        })
                        self.offsetY = offsetY
                    }
                    tableView.cellBlock = { [weak self] (id, type) in
                        switch type {
                        case 0:
                            let vc = ProjectManageSeleController()
                            vc.title = "选择成员"
                            vc.isMultiple = true
                            vc.backBlock = { (idArray, _) in
                                if idArray.count != 0 {
                                    self?.workGroupInvite(groupId: id, idArray: idArray)
                                }
                            }
                            self?.navigationController?.pushViewController(vc, animated: true)
                        default: break
                        }
                    }
                    tableView.addBlock = { [weak self] (type) in
                        switch type {
                        case 0: // 添加成员
                            let vc = ProjectManageSeleController()
                            vc.title = "选择成员"
                            vc.isMultiple = true
                            vc.backBlock = { (idArray, _) in
                                if idArray.count > 0 { // 有选中
                                    self?.projectMemberAdd(users: idArray)
                                }
                            }
                            self?.navigationController?.pushViewController(vc, animated: true)
                        case 2: // 添加工作组
                            let vc = NewWorkingGroupController()
                            vc.projectData = (self?.projectData.id ?? 0, self?.projectData.name ?? "")
                            vc.addBlock = {
                                tableView.reload() // 重新获取数据
                            }
                            self?.navigationController?.pushViewController(vc, animated: true)
                        default: break
                        }
                    }
                    tableView.editBlock = { [weak self] (userId) in
                        self?.projectMemberDelete(userId: userId)
                    }
            }
            lastTableView = tableView
            tableViewArray.append(tableView)
        }
        
        tableViewArray[0].getData()
    }
    
    /// 设置tableview的顶部距离
    ///
    /// - Parameter tableView: 要设置的tableview
    private func setTableViewOffsetY(tableView: ProjectDetailsTableView) {
        let contentY = tableView.contentOffset.y
        if offsetY < -40 { // SegmentedView不在顶部
            if offsetY != contentY { // 没有设置过
                tableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            }
        } else if contentY < -40 { // SegmentedView在顶部 而自身没有吧内容放在顶部 并且没有设置过
            tableView.setContentOffset(CGPoint(x: 0, y: -40), animated: false)
        }
        tableView.getData()
    }
    
    
    /// 刷新数据 -> 修改锁定状态时调用
    private func reloadData() {
        setNav(projectData.isLock == 0 ? "锁定项目" : "解锁项目")
        for tableView in tableViewArray {
            tableView.lockState = projectData.isLock
            tableView.setTableFooterView()
            tableView.reloadData()
        }
        let lock = lockState == 1 ? projectData.isLock : 2
        headerView.data = (projectData, lock)
    }
    
    /// 数据回调
    private func block() {
        if editBlock != nil {
            editBlock!(projectData)
        }
    }
    
    // MARK: - Api
    /// 修改项目
    private func projectUpdate(isLock: Int) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.projectUpdate(nil, projectData.id, nil, isLock, nil), t: LoginModel.self, successHandle: { (result) in
            self.projectData.isLock = isLock
            self.reloadData()
            self.block()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "")
        })
    }
    
    /// 新增项目成员
    ///
    /// - Parameter users: 用户id数组
    private func projectMemberAdd(users: [Int]) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.projectMemberAdd(projectData.id, users), t: LoginModel.self, successHandle: { (result) in
            self.tableViewArray[0].reload()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "添加失败")
        })
    }
    
    /// 邀请他人进入工作组
    ///
    /// - Parameters:
    ///   - groupId: 组id
    ///   - idArray: id数组
    private func workGroupInvite(groupId: Int, idArray: [Int]) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workGroupInvite(groupId, idArray), t: LoginModel.self, successHandle: { (result) in
            self.tableViewArray[2].reload()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "邀请失败")
        })
    }
    
    /// 删除项目成员
    ///
    /// - Parameter userId: 要删除成员的Id
    private func projectMemberDelete(userId: Int) {
        let alertController = UIAlertController(title: "提示", message: "是否删除该参与人员", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "删除", style: .default, handler: { (_) in
            MBProgressHUD.showWait("")
            _ = APIService.shared.getData(.projectMemberDelete(self.projectData.id, userId), t: LoginModel.self, successHandle: { (result) in
                self.tableViewArray[0].reload()
                MBProgressHUD.dismiss()
            }, errorHandle: { (error) in
                MBProgressHUD.showError(error ?? "删除失败")
            })
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - 按钮点击
    /// 点击新增项目
    @objc private func rightClick() {
        let isLock = projectData.isLock == 0 ? 1 : 0
        projectUpdate(isLock: isLock)
    }
}

extension ProjectDetailsController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = Int(offsetX / ScreenWidth)
        var tableView: ProjectDetailsTableView!
        if offsetX < x {
            tableView = tableViewArray[page + 1]
        } else if offsetX > x {
            tableView = tableViewArray[page - 1]
        } else {
            return
        }
        setTableViewOffsetY(tableView: tableView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        offsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // 监听快速滑动，惯性慢慢停止
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            let page = Int(scrollView.contentOffset.x / ScreenWidth)
            segment.changeBtn(page: page)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { // 手指控制直接停止
        if !decelerate {
            let dragToDragStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if dragToDragStop {
                let page = Int(scrollView.contentOffset.x / ScreenWidth)
                segment.changeBtn(page: page)
            }
        }
    }
}
