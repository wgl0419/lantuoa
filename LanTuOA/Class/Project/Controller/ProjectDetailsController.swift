//
//  ProjectDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情 控制器

import UIKit

class ProjectDetailsController: UIViewController {

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
        setNav()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        title = "项目详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "解锁项目",
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
            })
        
        headerView.layoutIfNeeded() // 立即获得layout后的真实view尺寸
        headerHeight = headerView.height // 并保存
        
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
                    tableView.lockState = lockState
                    tableView.scrollBlock = { (offsetY) in
                        let changeY = offsetY < -self.headerHeight - 40 ? 0 : offsetY >= -40 ? -self.headerHeight : -self.headerHeight - offsetY - 40
                        self.headerView.snp.updateConstraints({ (make) in
                            make.top.equalToSuperview().offset(changeY)
                        })
                        self.offsetY = offsetY
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
        
    }
    
    // MARK: - 按钮点击
    /// 点击新增项目
    @objc private func rightClick() {
        
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
