//
//  ProjectDetailsTableView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情

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
        /// 历史合同
        case contract = 3
    }
    
    /// 滚动回调
    var scrollBlock: ((CGFloat) -> ())?
    /// 添加回调 (CellStyle类型 —> personnel == 0)
    var addBlock: ((Int) -> ())?
    /// 点击cell回调 (工作组->组id  人员、历史->row         选择方式)
    var cellBlock: ((Int, Int) -> ())?
    /// 点击拜访历史
    var visitBlock: ((VisitListData) -> ())?
    /// 点击合同
    var contractBlock: ((ContractListData) -> ())?
    /// 修改回调 (删除的id)
    var editBlock: ((Int) -> ())?
    /// 锁定状态 （0：未锁定   1：锁定）
    var lockState = 1
    /// 能否编辑项目
    var canManage = 0
    
    /// 历史顶部选择时间按钮
    private var seleTimeBtn: UIButton!
    
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
    /// 历史合同
    private var contractListData = [ContractListData]()
    /// 第一次加载
    private var isFirst = true
    /// 历史选择的时间戳
    private var timeStamp = 0
    
    /// 加载刷新
    func getData() {
        if isFirst {
            reload()
            isFirst = false
        }
    }
    
    /// 刷新数据
    func reload() {
        if cellStyle == .history {
            mj_footer.isHidden = true
            visitList(isMore: false)
        } else if cellStyle == .personnel {
            projectMemberList()
        } else if cellStyle == .workingGroup {
            workGroupList()
        } else {
            contractList(isMore: false)
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
        _ = UIView().taxi.adhere(toSuperView: self) // 添加底部安全区的白色背景 -> 防止出现尾视图在内容之上的问题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(SafeH)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
            })
        
        contentInset = UIEdgeInsets(top: offsetY + 40, left: 0, bottom: 0, right: 0)
        setContentOffset(CGPoint(x: 0, y: -offsetY - 40), animated: false)
        setTableFooterView()
        
        register(ProjectDetailsPersonnelCell.self, forCellReuseIdentifier: "ProjectDetailsPersonnelCell")
        register(ProjectDetailsVisitCell.self, forCellReuseIdentifier: "ProjectDetailsVisitCell")
        register(WrokHomeCell.self, forCellReuseIdentifier: "WrokHomeCell")
        register(CostomerDetailsContractCell.self, forCellReuseIdentifier: "CostomerDetailsContractCell")
        
        
        mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.reload()
        })
        if cellStyle == .history || cellStyle == .contract { // "拜访历史" 有上拉
            mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                self?.mj_header.isHidden = true
                if self?.cellStyle == .history {
                    self?.visitList(isMore: true)
                } else {
                    self?.contractList(isMore: true)
                }
            })
        }
        
        
        if cellStyle == .history {
            setNoneData(str: "暂无拜访历史", imageStr: "noneData")
        } else if cellStyle == .personnel {
            setNoneData(str: "暂无参与人员", imageStr: "noneData")
        } else if cellStyle == .workingGroup {
            setNoneData(str: "暂无工作组", imageStr: "noneData")
        } else {
            setNoneData(str: "暂无历史合同", imageStr: "noneData")
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
    
    /// 添加类的尾视图
    private func addFooterViewHandle() -> UIView {
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
        footerView.backgroundColor = .white
        return footerView
    }
    
    /// 选择时间尾视图
    private func timeFooterViewHandle() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 30))
        footerView.backgroundColor = .white
        let timeStr = timeStamp == 0 ? "选择日期" : Date(timeIntervalSince1970: TimeInterval(timeStamp)).yearTimeStr()
        seleTimeBtn = UIButton().taxi.adhere(toSuperView: footerView) // 选择日期
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (btn) in
                btn.setTitle(timeStr, for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(seleTimeClick), for: .touchUpInside)
            })
        return footerView
    }
    
    /// 设置无数据信息
    ///
    /// - Parameters:
    ///   - str: 提示内容
    ///   - imageStr: 提示图片名称
    private func setNoneData(str: String, imageStr: String) {
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        noDataLabel?.attributedText = attriMuStr
        noDataImageView?.image = UIImage(named: imageStr)
        
        noDataLabel?.snp.updateConstraints({ (make) in
            make.bottom.equalTo(self.snp.centerY).offset(-offsetY / 2)
        })
        noDataImageView?.snp.updateConstraints({ (make) in
            make.bottom.equalTo(self.snp.centerY).offset(-55 + spacing * 2 - offsetY / 2)
        })
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
            self.isNoData = self.memberData.count == 0
            self.reloadData()
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.mj_header.endRefreshing()
            self.isNoData = self.memberData.count == 0
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 获取拜访历史
    ///
    /// - Parameter isMore: 是否加载更多
    private func visitList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.visitList("", timeStamp, nil, 1, newPage, 10, nil, projectId, nil), t: VisitListModel.self, successHandle: { (result) in
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
            self.isNoData = self.visitData.count == 0
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
            self.isNoData = self.visitData.count == 0
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 获取项目工作组
    private func workGroupList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workGroupList(1, 9999, projectId), t: WorkGroupListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.groupData = result.data
            self.mj_header.endRefreshing()
            if result.data.count == 0 {
                MBProgressHUD.showError("该项目没有工作组")
            }
            self.reloadData()
            self.isNoData = self.groupData.count == 0
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.mj_header.endRefreshing()
            self.isNoData = self.groupData.count == 0
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 历史合同
    private func contractList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        let startTimeStamp = timeStamp == 0 ? nil : timeStamp
        _ = APIService.shared.getData(.contractList("", nil, projectId, nil, newPage, 10, startTimeStamp, nil), t: ContractListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.contractListData.append(model)
                }
                self.mj_footer.endRefreshing()
                self.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.contractListData = result.data
                self.mj_header.endRefreshing()
                self.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.mj_footer.resetNoMoreData()
            }
            self.isNoData = self.contractListData.count == 0
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
            self.isNoData = self.contractListData.count == 0
            MBProgressHUD.showError(error ?? "获取历史合同失败")
        })
    }
    
    /// 删除项目成员
    ///
    /// - Parameter userId: 要删除成员的Id
    private func projectMemberDelete(userId: Int) {
        if editBlock != nil {
            editBlock!(userId)
        }
    }
    
    // MARK: - 按钮点击
    /// 点击添加按钮
    @objc private func addClick() {
        if addBlock != nil {
            let type = cellStyle.rawValue
            addBlock!(type)
        }
    }
    
    /// 点击选择日期
    @objc private func seleTimeClick() {
        let view = SeleVisitTimeView(limit: true)
        view.seleBlock = { (timeStr) in
            self.seleTimeBtn.setTitle(timeStr, for: .normal)
            self.timeStamp = timeStr.getTimeStamp(customStr: "yyyy-MM-dd HH:mm")
            self.visitList(isMore: false)
        }
        view.show()
    }
}

extension ProjectDetailsTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellStyle == .history ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cellStyle == .personnel ? memberData.count : cellStyle == .history ? 0 : groupData.count
        } else {
            return visitData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if cellStyle == .personnel { // 参与人员
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsPersonnelCell", for: indexPath) as! ProjectDetailsPersonnelCell
            cell.deleteBlock = {
                self.projectMemberDelete(userId: self.memberData[row].userId)
            }
            cell.lockState = lockState == 1 && canManage == 1 ? 1 : 0
            cell.data = (memberData[row].userName ?? "", memberData[row].visitTime)
            return cell
        } else if cellStyle == .history { // 拜访历史
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsVisitCell", for: indexPath) as! ProjectDetailsVisitCell
            cell.accessoryType = .disclosureIndicator
            cell.data = visitData[row]
            return cell
        } else if cellStyle == .workingGroup { // 工作组
            let cell = tableView.dequeueReusableCell(withIdentifier: "WrokHomeCell", for: indexPath) as! WrokHomeCell
            cell.data = groupData[row]
            return cell
        } else { // 合同历史
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostomerDetailsContractCell", for: indexPath) as! CostomerDetailsContractCell
            cell.data = contractListData[row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        } else if cellStyle == .history {
            return 30
        } else if cellStyle == .contract {
            return 0
        } else if cellStyle == .personnel && lockState == 1 && Jurisdiction.share.isEditProject || canManage == 1 || cellStyle == .workingGroup {
            return 40
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return nil
        } else if cellStyle == .history {
            return timeFooterViewHandle()
        } else if cellStyle == .contract {
            return nil
        } else if cellStyle == .personnel && lockState == 1 && Jurisdiction.share.isEditProject || canManage == 1 || cellStyle == .workingGroup {
            return addFooterViewHandle()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if cellStyle == .workingGroup { // 工作组
            let view = SeleVisitModelView(title: "选择操作", content: ["添加成员", "退出工作组"])
            view.didBlock = { [weak self] (seleIndex) in
                if self?.cellBlock != nil {
                    let id = self?.groupData[indexPath.row].id ?? 0
                    self?.cellBlock!(id, seleIndex)
                }
            }
            view.show()
        } else if cellStyle == .history { // 拜访历史
            if visitBlock != nil {
                visitBlock!(visitData[indexPath.row])
            }
        } else if cellStyle == .contract {
            if contractBlock != nil {
                contractBlock!(contractListData[indexPath.row])
            }
        }
    }
}

extension ProjectDetailsTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollBlock != nil {
            scrollBlock!(scrollView.contentOffset.y)
        }
    }
}
