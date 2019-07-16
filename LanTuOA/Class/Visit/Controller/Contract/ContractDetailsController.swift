//
//  ContractDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  控制器

import UIKit
import MBProgressHUD

class ContractDetailsController: UIViewController {
    
    /// 修改回调
    var changeBlock: (() -> ())?
    
    /// 合同数据
    var contractListData: ContractListData!
    /// 合同id
    var contractId: Int!

    /// 顶部视图
    private var headerView: ContractDetailsHeaderView!
    /// 选择器
    private var segment: ProjectDetailsSegmentedView!
    /// 填充多个tableview的滚动视图
    private var scrollView: UIScrollView!
    
    /// 顶部视图的高度
    private var headerHeight: CGFloat = 235
    /// tableview滚动offsetY
    private var offsetY: CGFloat = 0
    /// tableview数组
    private var tableViewArray = [ContractDetailsTableView]()
    /// 记录上一次scrollView滚动的位置
    private var offsetX: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contractListData != nil {
            initSubViews()
            contractId = contractListData.id
        } else {
            contractDetail()
        }
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "合同详情"
        view.backgroundColor = .white
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: view) // 滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.width.height.equalToSuperview()
            })
            .taxi.config({ (scrollView) in
                scrollView.bounces = false
                scrollView.delegate = self
                scrollView.isPagingEnabled = true
            })
        
        headerView = ContractDetailsHeaderView().taxi.adhere(toSuperView: view) // 顶部视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
            })
            .taxi.config({ (view) in
                view.data = contractListData
                view.editBlock = { [weak self] in
                    self?.contractDetail()
                }
            })
        
        headerView.layoutIfNeeded() // 立即获得layout后的真实view尺寸
        headerHeight = headerView.height // 并保存
        
        let titleArray = ["发布内容", "付款情况", "业绩详情","补充说明"]
//        if Jurisdiction.share.isViewContractDesc {
//            titleArray.append("补充说明")
//        }
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
        addTableView()
    }
    
    /// 添加tableview
    private func addTableView() {
        offsetY = -headerHeight - 40
        var lastTableView: ContractDetailsTableView!
        var maxCount = 3
        if Jurisdiction.share.isViewContractDesc {
            maxCount = 4
        }
        for index in 0..<maxCount {
            let tableView = ContractDetailsTableView(style: ContractDetailsTableView.CellStyle(rawValue: index)!, height: headerHeight, contractId: contractListData.id).taxi.adhere(toSuperView: scrollView) // tableview
                .taxi.layout { (make) in
                    if index == 0 {
                        make.left.equalToSuperview()
                    } else {
                        make.left.equalTo(lastTableView.snp.right)
                    }
                    make.width.top.height.equalToSuperview()
                    if index == maxCount - 1 {
                        make.right.equalToSuperview()
                    }
            }
                .taxi.config { (tableView) in
                    tableView.contractListData = contractListData
                    tableView.scrollBlock = { (offsetY) in
                        let changeY = offsetY < -self.headerHeight - 40 ? 0 : offsetY >= -40 ? -self.headerHeight : -self.headerHeight - offsetY - 40
                        self.headerView.snp.updateConstraints({ (make) in
                            make.top.equalToSuperview().offset(changeY)
                        })
                        self.offsetY = offsetY
                    }
                    tableView.changeBlock = { [weak self] in
                        self?.contractDetail()
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
    private func setTableViewOffsetY(tableView: ContractDetailsTableView) {
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
    
    /// 刷新内容
    private func reloadData() {
        if headerView != nil {
            headerView.data = contractListData
            headerView.layoutIfNeeded() // 立即获得layout后的真实view尺寸
            headerHeight = headerView.height // 并保存
            
            if self.changeBlock != nil {
                self.changeBlock!()
            }
            
            for index in 0..<3 {
                let tableView = tableViewArray[index]
                tableView.offsetY = headerHeight
                tableView.reload()
            }
        } else {
            initSubViews()
        }
    }
    
    // MAKR: - Api
    /// 合同详情
    private func contractDetail() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.contractDetail(contractId), t: ContractDetailModel.self, successHandle: { (result) in
            self.contractListData = result.data
            self.reloadData()
            MBProgressHUD.dismiss()
        }) { (error) in
            MBProgressHUD.showError(error ?? "获取合同详情失败")
        }
    }
}

extension ContractDetailsController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = Int(offsetX / ScreenWidth)
        var tableView: ContractDetailsTableView!
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
