//
//  ProjectDetailsTableView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情

import UIKit
import SnapKit
import MJRefresh
import MBProgressHUD

class ProjectDetailsTableView: UIView {
    
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
    /// tableview
    var tableView: UITableView!
    /// 底部视图
    private var footerView: UIView!
    /// 添加按钮
    private var addBtn: UIButton!
    /// 灰色块
    private var grayView: UIView!
    /// 提示内容
    private var tipsLabel: UILabel!
    
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
    /// 尾部视图约束
    private var footerConstraint: Constraint!
    
    /// 加载刷新
    func getData() {
        if isFirst {
            reload()
            isFirst = false
        }
    }
    
    /// 刷新数据
    func reload() {
        setFooterView()
        if cellStyle == .history {
            tableView.mj_footer.isHidden = true
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
        initFooterViews()
        setTableView()
    }
    
    // MARK: - 自定义私有方法
    /// 底部按钮控件初始化
    private func initFooterViews() {
        footerView = UIView().taxi.adhere(toSuperView: self) // 底部视图
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview().priority(800)
                footerConstraint = make.height.equalTo(0).priority(800).constraint
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : 0).priority(800)
            })
            .taxi.config({ (view) in
                footerConstraint.deactivate()
                view.backgroundColor = .white
            })
        
        addBtn = UIButton().taxi.adhere(toSuperView: footerView) // 添加按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(40)
            })
            .taxi.config({ (btn) in
                btn.setTitle("测试", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setImage(UIImage(named: "add"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
            })
        
        grayView = UIView().taxi.adhere(toSuperView: footerView) // 灰色块
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(10)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(addBtn.snp.top)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
        
        tipsLabel = UILabel().taxi.adhere(toSuperView: footerView)
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalTo(addBtn.snp.top).offset(-15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(10)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textAlignment = .center
                label.font = UIFont.regular(size: 12)
                label.textColor = UIColor(hex: "#FF4444")
            })
        setFooterView()
    }
    
    /// 设置tableView
    private func setTableView() {
        tableView = UITableView().taxi.adhere(toSuperView: self) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(footerView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                tableView.contentInset = UIEdgeInsets(top: offsetY + 40, left: 0, bottom: 0, right: 0)
                tableView.setContentOffset(CGPoint(x: 0, y: -offsetY - 40), animated: false)
                
                tableView.register(ProjectDetailsPersonnelCell.self, forCellReuseIdentifier: "ProjectDetailsPersonnelCell")
                tableView.register(ProjectDetailsVisitCell.self, forCellReuseIdentifier: "ProjectDetailsVisitCell")
                tableView.register(WrokHomeCell.self, forCellReuseIdentifier: "WrokHomeCell")
                tableView.register(CostomerDetailsContractCell.self, forCellReuseIdentifier: "CostomerDetailsContractCell")
                
                
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.reload()
                })
                if cellStyle == .history || cellStyle == .contract { // "拜访历史" 有上拉
                    tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                        self?.tableView.mj_header.isHidden = true
                        if self?.cellStyle == .history {
                            self?.visitList(isMore: true)
                        } else {
                            self?.contractList(isMore: true)
                        }
                    })
                }
            })
        setTableFooterView()
        
        
        _ = UIView().taxi.adhere(toSuperView: self) // 添加底部安全区的白色背景 -> 防止出现尾视图在内容之上的问题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(SafeH)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
            })
        
        if cellStyle == .history {
            setNoneData(str: "暂无拜访！", imageStr: "noneData")
        } else if cellStyle == .personnel {
            setNoneData(str: "暂无参与人员！", imageStr: "noneData")
        } else if cellStyle == .workingGroup {
            setNoneData(str: "暂无工作组！", imageStr: "noneData")
        } else {
            setNoneData(str: "暂无历史合同！", imageStr: "noneData")
        }
        
    }
    
    /// 设置尾视图
    @objc func setTableFooterView() {
        self.layoutIfNeeded()
        let old = tableView.tableFooterView?.height ?? 0
        var footerHeight = ScreenHeight - NavigationH - tableView.contentSize.height - 40 - SafeH + old
        footerHeight = footerHeight - footerView.height
        if footerHeight > 0 {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: footerHeight))
            _ = UIView().taxi.adhere(toSuperView: footer)
                .taxi.layout(snapKitMaker: { (make) in
                    make.height.equalTo(1)
                    make.top.right.equalToSuperview()
                    make.left.equalToSuperview().offset(15).priority(800)
                })
                .taxi.config({ (view) in
                    view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                })
            tableView.tableFooterView = footer
        } else {
            tableView.tableFooterView = UIView()
        }
    }
    
    /// 设置尾视图
    private func setFooterView() {
        if cellStyle == .history {
            addBtn.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            grayView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            addBtn.isHidden = true
            tipsLabel.text = "注：可看到您和您的下级的拜访，您接手的拜访，\n以及您工作组中其他成员的拜访"
        } else if cellStyle == .personnel {
            addBtn.setTitle(" 添加参与人员", for: .normal)
            addBtn.snp.updateConstraints { (make) in
                make.height.equalTo(lockState == 1 ? 40 : 0)
            }
            grayView.snp.updateConstraints { (make) in
                make.height.equalTo(lockState == 1 ? 10 : 0)
            }
            addBtn.isHidden = lockState != 1
            tipsLabel.text = "注：若您不是项目管理员，本页面您只能看到您和您的下级"
        } else if cellStyle == .workingGroup {
            addBtn.setTitle(" 新增工作组", for: .normal)
            tipsLabel.text = "注：仅项目管理员可看到所有参与人"
        } else {
            footerConstraint.activate()
            footerView.isHidden = true
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
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: imageStr)
        
        tableView.noDataLabel?.snp.updateConstraints({ (make) in
            make.bottom.equalTo(self.tableView.snp.centerY).offset(-offsetY / 2)
        })
        tableView.noDataImageView?.snp.updateConstraints({ (make) in
            make.bottom.equalTo(self.tableView.snp.centerY).offset(-55 + spacing * 2 - offsetY / 2)
        })
    }
    
    // MARK: - Api
    /// 获取项目成员列表
    private func projectMemberList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.projectMemberList(projectId), t: ProjectMemberListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.memberData = result.data
            self.tableView.mj_header.endRefreshing()
            if result.data.count == 0 {
                MBProgressHUD.showError("该项目没有成员")
            }
            self.tableView.isNoData = self.memberData.count == 0
            self.tableView.reloadData()
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.isNoData = self.memberData.count == 0
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
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.visitData = result.data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.tableView.isNoData = self.visitData.count == 0
            self.tableView.reloadData()
            self.setTableFooterView()
        }, errorHandle: { (error) in
            if isMore {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
            } else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            self.tableView.isNoData = self.visitData.count == 0
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 获取项目工作组
    private func workGroupList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workGroupList(1, 9999, projectId), t: WorkGroupListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.groupData = result.data
            self.tableView.mj_header.endRefreshing()
            if result.data.count == 0 {
                MBProgressHUD.showError("该项目没有工作组")
            }
            self.tableView.reloadData()
            self.tableView.isNoData = self.groupData.count == 0
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.isNoData = self.groupData.count == 0
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 历史合同
    private func contractList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        let startTimeStamp = timeStamp == 0 ? nil : timeStamp
        _ = APIService.shared.getData(.contractList("", nil, projectId, nil, newPage, 10, startTimeStamp, nil, nil,nil,nil,nil), t: ContractListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.contractListData.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.contractListData = result.data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.tableView.isNoData = self.contractListData.count == 0
            self.tableView.reloadData()
            self.setTableFooterView()
        }, errorHandle: { (error) in
            if isMore {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
            } else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            self.tableView.isNoData = self.contractListData.count == 0
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
            return cellStyle == .personnel ? memberData.count : cellStyle == .history ? 0 : cellStyle == .workingGroup ? groupData.count : contractListData.count
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
        if cellStyle == .history && section == 0 {
            return 30
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if cellStyle == .history && section == 0 {
            return timeFooterViewHandle()
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
