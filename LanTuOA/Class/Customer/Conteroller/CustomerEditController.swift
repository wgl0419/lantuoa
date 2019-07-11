//
//  CustomerEditController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户编辑 -> 客户详情 控制器

import UIKit
import MBProgressHUD

class CustomerEditController: UIViewController {
    
    /// 客户信息数据
    var customerData: CustomerListStatisticsData!
    /// 有修改回调
    var editBlock: (() -> ())?
    
    
    /// 顶部视图
    private var headerView: CustomerDetailsHeaderView!
    /// 选择器
    private var segment: ProjectDetailsSegmentedView!
    /// 填充多个tableview的滚动视图
    private var scrollView: UIScrollView!
    
    
    /// 顶部视图的高度
    private var headerHeight: CGFloat = 235
    /// tableview滚动offsetY
    private var offsetY: CGFloat = 0
    /// tableview数组
    private var tableViewArray = [CustomerDetailsTableView]()
    /// 记录上一次scrollView滚动的位置
    private var offsetX: CGFloat = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = customerData.name ?? "客户详情"
        view.backgroundColor = .white
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: view) // 滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.width.height.equalToSuperview()
            })
            .taxi.config({ (scrollView) in
                scrollView.bounces = false
                scrollView.delegate = self
                scrollView.isPagingEnabled = true
                scrollView.showsHorizontalScrollIndicator = false
            })
        
         headerView = CustomerDetailsHeaderView().taxi.adhere(toSuperView: view) // 顶部视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
            })
            .taxi.config({ (headerView) in
                headerView.data = customerData
                headerView.modifyBolck = {
                    let contentArray = ["修改客户信息", "修改客户类型"]
                    let view = SeleVisitModelView(title: "选择修改内容", content: contentArray)
                    view.didBlock = { [weak self] (seleIndex) in
                        switch seleIndex {
                        case 0: self?.modifyInformation()
                        case 1: self?.modifyType()
                        default: break
                        }
                    }
                    view.show()
                }
            })
        
        headerView.layoutIfNeeded() // 立即获得layout后的真实view尺寸
        headerHeight = headerView.height // 并保存
//        let titleArray = ["在线项目", "参与人员", "历史拜访", "历史合同", "联系人"]
        let titleArray = ["在线项目", "历史拜访", "历史合同", "联系人"]
        segment = ProjectDetailsSegmentedView(title: titleArray) // 选择器
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
        segment.layoutIfNeeded()
        addTableView()
    }
    
    
    /// 添加tableview
    private func addTableView() {
        var lastTableView: CustomerDetailsTableView!
        self.offsetY = -headerHeight - 40
        for index in 0..<4 { // 添加4个tableview
            let tableView = CustomerDetailsTableView(style: CustomerDetailsTableView.CellStyle(rawValue: index)!, height: headerHeight, customerId: customerData.id) // tableview
                .taxi.adhere(toSuperView: scrollView)
                .taxi.layout { (make) in
                    if index == 0 {
                        make.left.equalToSuperview()
                    } else {
                        make.left.equalTo(lastTableView.snp.right)
                    }
                    make.width.top.height.equalToSuperview()
                    if index == 3 {
                        make.right.equalToSuperview()
                    }
                }
                .taxi.config { (tableView) in
                    tableView.customerName = customerData.name ?? ""
                    tableView.scrollBlock = { (offsetY) in
                        let changeY = offsetY < -self.headerHeight - 40 ? 0 : offsetY >= -40 ? -self.headerHeight : -self.headerHeight - offsetY - 40
                        self.headerView.snp.updateConstraints({ (make) in
                            make.top.equalToSuperview().offset(changeY)
                        })
                        self.offsetY = offsetY
                    }
                    tableView.projectBlock = { [weak self] (model) in
                        let vc = ProjectDetailsController()
                        vc.lockState = 1
                        vc.projectData = model
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    tableView.visitBlock = { [weak self] (model) in
                        let vc = VisitDetailsController()
                        vc.visitListData = model
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    tableView.contractBlock = { [weak self] (model) in
                        let vc = ContractDetailsController()
                        vc.contractListData = model
                        self?.navigationController?.pushViewController(vc, animated: true)
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
    private func setTableViewOffsetY(tableView: CustomerDetailsTableView) {
        let contentY = tableView.tableView.contentOffset.y
        if offsetY < -40 { // SegmentedView不在顶部
            if offsetY != contentY { // 没有设置过
                tableView.tableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            }
        } else if contentY < -40 { // SegmentedView在顶部 而自身没有吧内容放在顶部 并且没有设置过
            tableView.tableView.setContentOffset(CGPoint(x: 0, y: -40), animated: false)
        }
        tableView.getData()
    }
    
    /// 修改客户类型
    private func modifyType() {
        let ejectView = ModifyCustomerTypeEjectView(data: customerData)
        ejectView.changeBlock = { [weak self] in // 修改成功 -> 刷新
            self?.customerDetail(isChange: true)
        }
        ejectView.show()
    }
    
    /// 刷新tab的数据
    private func reloadTable() {
        headerView.layoutIfNeeded() // 立即获得layout后的真实view尺寸
        headerHeight = headerView.height // 并保存
        for tableView in tableViewArray {
            tableView.reload(height: headerHeight)
        }
    }
    
    /// 修改客户信息
    private func modifyInformation() {
        let ejectView = AddCustomerEjectView()
        ejectView.modifyData = ("修改客户信息", self.customerData)
        ejectView.addBlock = { [weak self] in // 修改成功 -> 刷新
            self?.customerDetail()
        }
        ejectView.show()
    }
    
    // MARK: - Api
    /// 客户详情
    private func customerDetail(isChange: Bool = false) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.customerDetail(customerData.id), t: CustomerDetailModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.customerData = result.data
            self.headerView.data = self.customerData
            if self.editBlock != nil {
                self.editBlock!()
            }
            if isChange {
                self.reloadTable()
            }
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取最新数据失败")
        })
    }

}


extension CustomerEditController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = Int(offsetX / ScreenWidth)
        var tableView: CustomerDetailsTableView!
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
