//
//  ProjectDetailsCollectionCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ProjectDetailsCollectionCell: UICollectionViewCell {
    
    /// tableview滚动回调
    var scrollBlock: ((CGFloat) -> ())?
    /// 顶部高度
    var headerHeight: CGFloat = 235
    
    /// cell类型
    var setCell: (ProjectDetailsTableView.CellStyle, CGFloat, Int, Bool)? {
        didSet {
            if let cell = setCell {
                if !isRefresh || cell.3 {
                    isRefresh = true
                    initSubViews(style: cell.0, offsetY: cell.1, projectId: cell.2)
                }
            }
        }
    }
    
    /// 显示数据的tableview
    private var tableView: ProjectDetailsTableView!
    /// 是否已经加载过
    private var isRefresh = false
    
    // MARK: - 自定义公有方法
    /// 设置tableview的顶部位置
    func setTableOffsetY(_ y: CGFloat) {
        let contentY = tableView.contentOffset.y
        if y >= -headerHeight - 41 && y <= 0 { // SegmentedView不在顶部
            tableView.setContentOffset(CGPoint(x: 0, y: y), animated: false)
        } else if contentY < -40 { // SegmentedView在顶部 而自身没有吧内容放在顶部
            tableView.setContentOffset(CGPoint(x: 0, y: -40), animated: false)
        }
    }
    
    // MARK: - 自定义初始化方法
    /// 初始化子控件
    private func initSubViews(style: ProjectDetailsTableView.CellStyle, offsetY: CGFloat, projectId: Int) {
        let y = offsetY > 0 ? 0 : offsetY
        tableView = ProjectDetailsTableView(style: style, height: headerHeight, projectId: projectId) // 显示数据的tableview
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.scrollBlock = { [weak self] (offsetY) in
                    if self?.scrollBlock != nil {
                        self?.scrollBlock!(offsetY + 40 + (self?.headerHeight ?? 235))
                    }
                }
            })
    }
}
