//
//  CustomerDetailsTableView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户详情 各个类型的tableview

import UIKit
import MJRefresh
import MBProgressHUD

class CustomerDetailsTableView: UITableView {

    /// cell类型
    enum CellStyle: Int {
        /// 在线项目
        case project = 0
        /// 参与人员
        case personnel = 1
        /// 拜访历史
        case history = 2
        /// 历史合同
        case contract = 3
        /// 拜访对象
        case visitor = 4
    }
    
    /// 滚动回调
    var scrollBlock: ((CGFloat) -> ())?
    /// 点击项目
    var projectBlock: ((ProjectListStatisticsData) -> ())?
    /// 点击历史拜访
    var visitBlock: ((VisitListData) -> ())?
    /// 点击合同
    var contractBlock: ((ContractListData) -> ())?
    /// 客户名称
    var customerName = ""
    
    /// 历史顶部选择时间按钮
    private var seleTimeBtn: UIButton!
    
    /// cell类型
    private var cellStyle: CellStyle = .project
    /// 已经偏移高度
    private var offsetY: CGFloat = 0
    /// 客户id
    private var customerId = 0
    /// 当前页码
    private var page = 1
    /// 在线项目
    private var projectData = [ProjectListStatisticsData]()
    /// 联系人
    private var contactListData = [CustomerContactListData]()
    /// 拜访历史
    private var visitData = [VisitListData]()
    /// 历史合同
    private var contractListData = [ContractListData]()
    /// 参与人员
    private var customerMembersData = [CustomerMembersData]()
    
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
        if cellStyle == .history { // 拜访历史
            mj_footer.isHidden = true
            visitList(isMore: false)
        } else if cellStyle == .project { // 在线项目
            projectListStatistics()
        } else if cellStyle == .visitor { // 联系人
            customerContactList()
        } else if cellStyle == .contract { // 合同
            contractList(isMore: false)
        } else { // 参与人员
            customerMembers()
        }
    }
    
    convenience init(style: CellStyle, height: CGFloat, customerId: Int) {
        self.init()
        cellStyle = style
        offsetY = height
        self.customerId = customerId
        setTableView()
    }
    
    // MARK: - 自定义私有方法
    /// 设置tableView
    private func setTableView() {
        delegate = self
        dataSource = self
        estimatedRowHeight = 50
        if cellStyle != .project {
            separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        
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
        
        register(CostomerDetailsProjectCell.self, forCellReuseIdentifier: "CostomerDetailsProjectCell")
        register(ProjectDetailsVisitCell.self, forCellReuseIdentifier: "ProjectDetailsVisitCell")
        register(CostomerDetailsVisitorCell.self, forCellReuseIdentifier: "CostomerDetailsVisitorCell")
        register(CostomerDetailsContractCell.self, forCellReuseIdentifier: "CostomerDetailsContractCell")
        register(ProjectDetailsPersonnelCell.self, forCellReuseIdentifier: "ProjectDetailsPersonnelCell")
        
        
        mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.reload()
        })
        if cellStyle == .history || cellStyle == .contract {
            mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                self?.mj_header.isHidden = true
                if self?.cellStyle == .history {
                    self?.visitList(isMore: true)
                } else {
                    self?.contractList(isMore: true)
                }
            })
        }
        
        if cellStyle == .history { // 拜访历史
            setNoneData(str: "暂无拜访历史！", imageStr: "noneData")
        } else if cellStyle == .project { // 在线项目
            setNoneData(str: "暂无在线项目！", imageStr: "noneData")
        } else if cellStyle == .visitor { // 联系人
            setNoneData(str: "暂无拜访！", imageStr: "noneData")
        } else if cellStyle == .contract { // 合同
            setNoneData(str: "暂无历史合同！", imageStr: "noneData")
        } else {
            setNoneData(str: "暂无参与人员！", imageStr: "noneData4")
        }
    }
    
    /// 设置尾视图
    @objc func setTableFooterView() {
        self.layoutIfNeeded()
        let old = self.tableFooterView?.height ?? 0
        let footerHeight = ScreenHeight - NavigationH - self.contentSize.height - SafeH + old
        if footerHeight > 0 {
            self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: footerHeight))
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    /// 添加类的尾视图
    private func addFooterViewHandle() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
        footerView.backgroundColor = .white
        _ = UIButton().taxi.adhere(toSuperView: footerView)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (btn) in
                var str =  " 添加项目"
                if cellStyle == .visitor {
                    str = " 新增拜访对象"
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
    /// 获取项目统计列表
    private func projectListStatistics() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.projectList("", customerId, 1, 9999), t: ProjectListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.projectData = result.data
            self.mj_header.endRefreshing()
            self.reloadData()
            self.isNoData = self.projectData.count == 0
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.mj_header.endRefreshing()
            self.isNoData = self.projectData.count == 0
            MBProgressHUD.showError(error ?? "获取在线项目失败")
        })
    }
    
    /// 客户联系人列表
    private func customerContactList() {
        _ = APIService.shared.getData(.customerContactList(customerId, 1, 9999), t: CustomerContactListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.contactListData = result.data
            self.mj_header.endRefreshing()
            self.reloadData()
            self.isNoData = self.contactListData.count == 0
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.mj_header.endRefreshing()
            self.isNoData = self.contactListData.count == 0
            MBProgressHUD.showError(error ?? "获取拜访对象失败")
        })
    }
    
    /// 获取拜访历史
    ///
    /// - Parameter isMore: 是否加载更多
    private func visitList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.visitList("", timeStamp, nil, 1, newPage, 10, customerId, nil, nil), t: VisitListModel.self, successHandle: { (result) in
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
            MBProgressHUD.showError(error ?? "获取历史拜访失败")
        })
    }
    
    /// 历史合同
    private func contractList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        let startTimeStamp = timeStamp == 0 ? nil : timeStamp
        _ = APIService.shared.getData(.contractList("", customerId, nil, nil, newPage, 10, startTimeStamp, nil, nil), t: ContractListModel.self, successHandle: { (result) in
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
    
    /// 客户跟进人员
    private func customerMembers() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.customerMembers(customerId), t: CustomerMembersModel.self, successHandle: { (result) in
            self.customerMembersData = result.data
            self.mj_header.endRefreshing()
            self.reloadData()
            self.setTableFooterView()
            self.isNoData = self.customerMembersData.count == 0
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取参与人员")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击添加按钮
    @objc private func addClick() {
        if cellStyle == .project {
            let ejectView = AddProjectEjectView()
            ejectView.customerId = customerId
            ejectView.customerName = customerName
            ejectView.addBlock = { // 添加成功 -> 刷新
                self.reload()
            }
            ejectView.show()
        } else if cellStyle == .visitor {
            let ejectView = AddVisitorEjectView()
            ejectView.customerId = customerId
            ejectView.addBlock = { // 添加成功 -> 刷新
                self.reload()
            }
            ejectView.show()
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

extension CustomerDetailsTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellStyle == .history {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellStyle == .project { // 在线项目
            return projectData.count
        } else if cellStyle == .visitor { // 拜访对象
            return contactListData.count
        } else if cellStyle == .history { // 拜访历史
            return section == 0 ? 0 : visitData.count
        } else if cellStyle == .contract { // 历史合同
            return contractListData.count
        } else {
            return customerMembersData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if cellStyle == .project { // 在线项目
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostomerDetailsProjectCell", for: indexPath) as! CostomerDetailsProjectCell
            cell.data = projectData[row]
            return cell
        } else if cellStyle == .visitor { // 拜访对象
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostomerDetailsVisitorCell", for: indexPath) as! CostomerDetailsVisitorCell
            let data = contactListData[row]
            cell.editBlock = {
                let ejectView = AddVisitorEjectView()
                let contentArray = [data.name ?? "", data.phone ?? "", data.position ?? ""]
                ejectView.modifyData = ("修改拜访对象信息", contentArray, data.id)
                ejectView.addBlock = { // 添加成功 -> 刷新
                    self.reload()
                }
                ejectView.show()
            }
            cell.data = data
            return cell
        } else if cellStyle == .history { // 拜访历史
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsVisitCell", for: indexPath) as! ProjectDetailsVisitCell
            cell.data = visitData[row]
            return cell
        } else if cellStyle == .contract { // 历史合同
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostomerDetailsContractCell", for: indexPath) as! CostomerDetailsContractCell
            cell.data = contractListData[row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsPersonnelCell", for: indexPath) as! ProjectDetailsPersonnelCell
            cell.lockState = 0
            cell.data = (customerMembersData[row].realname ?? "", customerMembersData[row].visitTime)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        } else if cellStyle == .history {
            return 30
        } else if cellStyle == .project {
            if Jurisdiction.share.isAddProject {
                return 40
            }
            return 0
        } else if cellStyle == .visitor {
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
        } else if cellStyle == .project {
            if Jurisdiction.share.isAddProject {
                return addFooterViewHandle()
            }
            return nil
        } else if cellStyle == .visitor {
            return addFooterViewHandle()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        if cellStyle == .project {
            if projectBlock != nil {
                projectBlock!(projectData[row])
            }
        } else if cellStyle == .history {
            if visitBlock != nil {
                visitBlock!(visitData[row])
            }
        } else if cellStyle == .contract {
            if contractBlock != nil {
                contractBlock!(contractListData[row])
            }
        }
    }
}


extension CustomerDetailsTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollBlock != nil {
            scrollBlock!(scrollView.contentOffset.y)
        }
    }
}
