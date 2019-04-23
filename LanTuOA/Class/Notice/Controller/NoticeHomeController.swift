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
    /// 是否加载过系统数据
    private var isSystem = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
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
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
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
        notifyCheckList(isMore: false) // 获取待处理的初始数据
        
        
        systemTableView = UITableView().taxi.adhere(toSuperView: scrollView) // 系统信息 tableView
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(pendingTableView.snp.right)
                make.top.right.height.width.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
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
    
    /// 点击同意处理
    private func agreeHandle(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "提示", message: "是否同意该信息?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "同意", style: .default, handler: { (_) in
            self.notifyCheckAgree(index: indexPath)
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 点击拒绝处理
    private func refuseHandle(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "提示", message: "是否拒绝该信息?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "拒绝", style: .default, handler: { (_) in
            self.notifyCheckReject(index: indexPath)
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api
    /// 审核列表
    private func notifyCheckList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? pendingPage + 1 : 1
        _ = APIService.shared.getData(.notifyCheckList(newPage, 10), t: NotifyCheckListModel.self, successHandle: { (result) in
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
            self.segmentView.setTips(index: 0, showTips: self.pendingData.count > 0)
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
        }, errorHandle: { (error) in
            if isMore {
                self.systemTableView.mj_footer.endRefreshing()
                self.systemTableView.mj_header.isHidden = false
            } else {
                self.systemTableView.mj_header.endRefreshing()
                self.systemTableView.mj_footer.isHidden = false
            }
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 拒绝审批-非创建客户/项目
    private func notifyCheckReject(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = pendingData[index.row].id
        _ = APIService.shared.getData(.notifyCheckReject(checkId, ""), t: LoginModel.self, successHandle: { (result) in
            self.pendingData.remove(at: index.row)
            self.pendingTableView.deleteRows(at: [index], with: .fade)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝创建客户/项目-客户已存在
    private func notifyCheckCusRejectExist(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = pendingData[index.row].id
        _ = APIService.shared.getData(.notifyCheckCusRejectExist(checkId), t: LoginModel.self, successHandle: { (result) in
            self.pendingData.remove(at: index.row)
            self.pendingTableView.deleteRows(at: [index], with: .fade)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝创建客户/项目-名称有误
    private func notifyCheckCusRejectMistake(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = pendingData[index.row].id
        _ = APIService.shared.getData(.notifyCheckCusRejectMistake(checkId), t: LoginModel.self, successHandle: { (result) in
            self.pendingData.remove(at: index.row)
            self.pendingTableView.deleteRows(at: [index], with: .fade)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 同意审批
    private func notifyCheckAgree(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = pendingData[index.row].id
        _ = APIService.shared.getData(.notifyCheckAgree(checkId, ""), t: LoginModel.self, successHandle: { (result) in
            self.pendingData.remove(at: index.row)
            self.pendingTableView.deleteRows(at: [index], with: .fade)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
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
            cell.data = pendingData[indexPath.row]
            cell.agreeBlock = { [weak self] in // 同意
                self?.agreeHandle(indexPath: indexPath)
            }
            cell.refuseBlock = { [weak self] (type) in // 拒绝
                if type == nil {
                    self?.refuseHandle(indexPath: indexPath)
                } else {
                    switch type {
                    case 1: self?.notifyCheckCusRejectExist(index: indexPath)
                    case 2: self?.notifyCheckCusRejectMistake(index: indexPath)
                    default: break
                    }
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
            if page == 1 && !isSystem {
                isSystem = true
                notifyList(isMore: false) // 获取系统的初始数据
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
                if page == 1 && !isSystem {
                    isSystem = true
                    notifyList(isMore: false) // 获取系统的初始数据
                }
            }
        }
    }
}

extension NoticeHomeController: SegmentViewDelegate {
    func changeScrollView(page: Int) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(page) * ScreenWidth, y: 0), animated: true)
        if page == 1 && !isSystem {
            isSystem = true
            notifyList(isMore: false) // 获取系统的初始数据
        }
    }
}
