//
//  ToExamineController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审核 控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ToExamineController: UIViewController {

    /// 选择器
    private var segmentView: SegmentView!
    /// scrollView
    private var scrollView: UIScrollView!
    
    /// 待审核页码
    private var awaitingAuditPage = 1
    /// 已审核页码
    private var auditedPage = 1
    /// 待审核列表数据
    private var awaitingAuditData = [NotifyCheckListData]()
    /// 已审核列表数据
    private var auditedData = [NotifyCheckListData]()
    /// tableview
    private var tableViewArray = [UITableView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        notifyCheckList(status: 0, isMore: false)
        notifyCheckList(status: 1, isMore: false)
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "我的审批"
        view.backgroundColor = .white
        
        segmentView = SegmentView(title: ["待审批", "已审批"])
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
        
        var lastTableView: UITableView!
        for index in 0..<2 {
            let tableView = UITableView().taxi.adhere(toSuperView: scrollView) // tableview
                .taxi.layout { (make) in
                    make.top.height.width.equalToSuperview()
                    if index == 0 {
                        make.left.equalToSuperview()
                    } else {
                        make.left.equalTo(lastTableView.snp.right)
                        make.right.equalToSuperview()
                    }
            }
                .taxi.config { (tableView) in
                    tableView.tag = index
                    tableView.delegate = self
                    tableView.dataSource = self
                    tableView.separatorStyle = .none
                    tableView.estimatedRowHeight = 180
                    tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                    tableView.register(NoticeHomePendingCell.self, forCellReuseIdentifier: "NoticeHomePendingCell")
                    tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                        tableView.mj_footer.isHidden = true
                        self?.notifyCheckList(status: index, isMore: false)
                    })
                    tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                        tableView.mj_header.isHidden = true
                        self?.notifyCheckList(status: index, isMore: true)
                    })

            }
            
            let str = "暂无审批！"
            let attriMuStr = NSMutableAttributedString(string: str)
            attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
            attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
            tableView.noDataLabel?.attributedText = attriMuStr
            tableView.noDataImageView?.image = UIImage(named: "noneData1")

            lastTableView = tableView
            tableViewArray.append(tableView)
        }
    }
    
    /// 点击同意处理
    private func agreeHandle(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "提示", message: "是否同意该申请?", preferredStyle: .alert)
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
        let alertController = UIAlertController(title: "提示", message: "是否拒绝该申请?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "拒绝", style: .default, handler: { (_) in
            self.notifyCheckReject(index: indexPath)
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api
    /// 获取审核数据
    ///
    /// - Parameters:
    ///   - status: 状态 1或不传:未处理   2:已处理
    ///   - isMore: 是否加载更多
    private func notifyCheckList(status: Int, isMore: Bool) {
        MBProgressHUD.showWait("")
        let oldPage = status == 0 ? awaitingAuditPage : auditedPage
        let newPage = isMore ? oldPage + 1 : 1
        _ = APIService.shared.getData(.notifyCheckList(status + 1, newPage, 10), t: NotifyCheckListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            let data = result.data
            if isMore {
                for model in data {
                    if status == 0 {
                        self.awaitingAuditData.append(model)
                    } else {
                        self.auditedData.append(model)
                    }
                }
                self.tableViewArray[status].mj_footer.endRefreshing()
                self.tableViewArray[status].mj_header.isHidden = false
                if status == 0 {
                    self.awaitingAuditPage += 1
                    self.segmentView.setNumber(index: 0, number: self.awaitingAuditData.count)
                } else {
                    self.auditedPage += 1
                }
            } else {
                if status == 0 {
                    self.awaitingAuditPage = 1
                    self.awaitingAuditData = data
                    self.segmentView.setNumber(index: 0, number: self.awaitingAuditData.count)
                } else {
                    self.auditedPage = 1
                    self.auditedData = data
                }
                self.tableViewArray[status].mj_header.endRefreshing()
                self.tableViewArray[status].mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.tableViewArray[status].mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableViewArray[status].mj_footer.resetNoMoreData()
            }
            self.tableViewArray[status].isNoData = status == 0 ? self.awaitingAuditData.count == 0 : self.auditedData.count == 0
            self.tableViewArray[status].reloadData()
        }, errorHandle: { (error) in
            if isMore {
                self.tableViewArray[status].mj_footer.endRefreshing()
                self.tableViewArray[status].mj_header.isHidden = false
            } else {
                self.tableViewArray[status].mj_header.endRefreshing()
                self.tableViewArray[status].mj_footer.isHidden = false
            }
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 拒绝审批-非创建客户/项目
    private func notifyCheckReject(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = awaitingAuditData[index.row].id
        _ = APIService.shared.getData(.notifyCheckReject(checkId, ""), t: LoginModel.self, successHandle: { (result) in
//            self.awaitingAuditData.remove(at: index.row)
//            self.tableViewArray[0].deleteRows(at: [index], with: .fade)
            self.notifyCheckList(status: 0, isMore: false)
            self.notifyCheckList(status: 1, isMore: false)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝审核 填写弹出框
    ///
    /// - Parameters:
    ///   - type: 类型  0：已存在  1：有误
    ///   - index: 在tableView中的位置
    private func modifyEjectView(type: Int ,index: IndexPath) {
        let ejectView = ModifyNoticeEjectView()
        ejectView.data = awaitingAuditData[index.row]
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
    }
    
    /// 拒绝创建客户/项目-客户已存在
    private func notifyCheckCusRejectExist(index: IndexPath, id: [Int]) {
        MBProgressHUD.showWait("")
        let checkId = awaitingAuditData[index.row].id
        _ = APIService.shared.getData(.notifyCheckCusRejectExist(checkId, id[0], id[1]), t: LoginModel.self, successHandle: { (result) in
//            self.awaitingAuditData.remove(at: index.row)
//            self.tableViewArray[0].deleteRows(at: [index], with: .fade)
            self.notifyCheckList(status: 0, isMore: false)
            self.notifyCheckList(status: 1, isMore: false)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝创建客户/项目-名称有误
    private func notifyCheckCusRejectMistake(index: IndexPath, conten: [String]) {
        MBProgressHUD.showWait("")
        let checkId = awaitingAuditData[index.row].id
        _ = APIService.shared.getData(.notifyCheckCusRejectMistake(checkId, conten[0], conten[1]), t: LoginModel.self, successHandle: { (result) in
//            self.awaitingAuditData.remove(at: index.row)
//            self.tableViewArray[0].deleteRows(at: [index], with: .fade)
            self.notifyCheckList(status: 0, isMore: false)
            self.notifyCheckList(status: 1, isMore: false)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 同意审批
    private func notifyCheckAgree(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = awaitingAuditData[index.row].id
        _ = APIService.shared.getData(.notifyCheckAgree(checkId, ""), t: LoginModel.self, successHandle: { (result) in
//            self.awaitingAuditData.remove(at: index.row)
//            self.tableViewArray[0].deleteRows(at: [index], with: .fade)
            self.notifyCheckList(status: 0, isMore: false)
            self.notifyCheckList(status: 1, isMore: false)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }
}

extension ToExamineController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return awaitingAuditData.count
        } else {
            return auditedData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeHomePendingCell", for: indexPath) as! NoticeHomePendingCell
        if tableView.tag == 0 {
            cell.data = (awaitingAuditData[indexPath.row], true)
        } else {
            cell.data = (auditedData[indexPath.row], false)
        }
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ToExamineDetailsController()
        if tableView.tag == 0 {
            vc.checkListId = awaitingAuditData[indexPath.row].id
        } else {
            vc.checkListId = auditedData[indexPath.row].id
        }
        
        vc.changeBlock = { [weak self] in
            self?.notifyCheckList(status: 0, isMore: false)
            self?.notifyCheckList(status: 1, isMore: false)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ToExamineController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // 监听快速滑动，惯性慢慢停止
        if scrollView is UITableView {
            return
        }
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            let page = Int(scrollView.contentOffset.x / ScreenWidth)
            segmentView.changeBtn(page: page)
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
            }
        }
    }
}

extension ToExamineController: SegmentViewDelegate {
    func changeScrollView(page: Int) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(page) * ScreenWidth, y: 0), animated: true)
    }
}
