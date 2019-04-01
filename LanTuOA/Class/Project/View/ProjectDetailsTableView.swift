//
//  ProjectDetailsTableView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class ProjectDetailsTableView: UITableView {
    
    /// cell类型
    enum CellStyle: Int {
        /// 参与成员
        case personnel = 0
        /// 拜访历史
        case history = 1
        /// 工作组
        case workingGroup = 2
    }
    
    /// 滚动回调
    var scrollBlock: ((CGFloat) -> ())?
    /// 添加回调 （参与人员 和 工作组）
    var addBlock: (() -> ())?
    /// 锁定状态 （0：未锁定   1：锁定）
    var lockState = 1
    
    /// cell类型
    private var cellStyle: CellStyle = .personnel
    /// 已经偏移高度
    private var offsetY: CGFloat = 0
    /// 项目id
    private var projectId = 0
    /// 当前页码
    private var page = 1
    /// 成员数据
    private var memberData = [ProjectMemberListData]()
    /// 拜访历史
    private var visitData = [VisitListData]()
    /// 工作组
    private var groupData = [WorkGroupListData]()
    /// 第一次加载
    private var isFirst = true
    
    /// 获取数据
    func getData() {
        if isFirst {
            isFirst = false
            if cellStyle == .history {
                visitList(isMore: false)
            } else if cellStyle == .personnel {
                projectMemberList()
            } else {
                workGroupList()
            }
        }
    }
    
    convenience init(style: CellStyle, height: CGFloat, projectId: Int) {
        self.init()
        cellStyle = style
        offsetY = height
        self.projectId = projectId
        setTableView()
    }
    
    // MARK: - 自定义私有方法
    /// 设置tableView
    private func setTableView() {
        delegate = self
        dataSource = self
        estimatedRowHeight = 50
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        if cellStyle == .history || cellStyle == .workingGroup { // 添加底部安全区的白色背景 -> 防止出现尾视图在内容之上的问题
            _ = UIView().taxi.adhere(toSuperView: self)
                .taxi.layout(snapKitMaker: { (make) in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(SafeH)
                })
                .taxi.config({ (view) in
                    view.backgroundColor = .white
                })
        }
        contentInset = UIEdgeInsets(top: offsetY + 40, left: 0, bottom: 0, right: 0)
        setContentOffset(CGPoint(x: 0, y: -offsetY - 40), animated: false)
        setTableFooterView()
        
        register(ProjectDetailsPersonnelCell.self, forCellReuseIdentifier: "ProjectDetailsPersonnelCell")
        register(ProjectDetailsVisitCell.self, forCellReuseIdentifier: "ProjectDetailsVisitCell")
        register(WrokHomeCell.self, forCellReuseIdentifier: "WrokHomeCell")
        
        
        mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            if self?.cellStyle == .history {
                self?.mj_footer.isHidden = true
                self?.visitList(isMore: false)
            } else {
                self?.projectMemberList()
            }
            
        })
        if cellStyle == .history { // "参与成员" 没有上拉
            mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                self?.mj_header.isHidden = true
                self?.visitList(isMore: true)
            })
        }
        
    }
    
    /// 设置尾视图
    @objc func setTableFooterView() {
        self.layoutIfNeeded()
        let old = self.tableFooterView?.height ?? 0
        let footerHeight = ScreenHeight - NavigationH - self.contentSize.height - 40 - SafeH + old
        if footerHeight > 0 {
            self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: footerHeight))
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    // MARK: - Api
    /// 获取项目成员列表
    private func projectMemberList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.projectMemberList(projectId), t: ProjectMemberListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.memberData = result.data
            self.mj_header.endRefreshing()
            if result.data.count == 0 {
                MBProgressHUD.showError("该项目没有成员")
            }
            self.reloadData()
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 获取拜访历史
    ///
    /// - Parameter isMore: 是否加载更多
    private func visitList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.visitList("", nil, nil, 2, newPage, 10, nil, projectId), t: VisitListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.visitData.append(model)
                }
                self.mj_footer.endRefreshing()
                self.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.visitData = result.data
                self.mj_header.endRefreshing()
                self.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.mj_footer.resetNoMoreData()
            }
            self.reloadData()
            self.setTableFooterView()
        }, errorHandle: { (error) in
            if isMore {
                self.mj_footer.endRefreshing()
                self.mj_header.isHidden = false
            } else {
                self.mj_header.endRefreshing()
                self.mj_footer.isHidden = false
            }
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 获取项目工作组
    private func workGroupList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workGroupList(1, 9999, projectId), t: WorkGroupListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.setTableFooterView()
        }, errorHandle: { (error) in
            
        })
    }
    
    // MARK: - 按钮点击
    @objc private func addClick() {
        if addBlock != nil {
            addBlock!()
        }
    }
}

extension ProjectDetailsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellStyle == .personnel ? memberData.count : cellStyle == .history ? visitData.count : groupData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if cellStyle == .personnel {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsPersonnelCell", for: indexPath) as! ProjectDetailsPersonnelCell
            cell.lockState = lockState
            cell.data = memberData[row]
            return cell
        } else if cellStyle == .history {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsVisitCell", for: indexPath) as! ProjectDetailsVisitCell
            cell.data = visitData[row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WrokHomeCell", for: indexPath) as! WrokHomeCell
            cell.data = groupData[row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if cellStyle == .personnel && lockState == 1 || cellStyle == .workingGroup {
            return 40
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
        _ = UIButton().taxi.adhere(toSuperView: footerView)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (btn) in
                var str =  " 添加参与人员"
                if cellStyle == .workingGroup {
                    str = " 新增工作组"
                }
                btn.setTitle(str, for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setImage(UIImage(named: "add"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
            })
        
        for index in 0..<2 { // 添加分割线
            _ = UIView().taxi.adhere(toSuperView: footerView)
                .taxi.layout(snapKitMaker: { (make) in
                    make.height.equalTo(1)
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                    if index == 0 {
                        make.top.equalToSuperview()
                    } else {
                        make.bottom.equalToSuperview()
                    }
                })
                .taxi.config({ (view) in
                    view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                })
        }
        
        return footerView
    }
}

extension ProjectDetailsTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollBlock != nil {
            scrollBlock!(scrollView.contentOffset.y)
        }
    }
}
