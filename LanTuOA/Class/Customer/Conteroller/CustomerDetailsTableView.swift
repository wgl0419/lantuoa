//
//  CustomerDetailsTableView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户详情 各个类型的tableview

import UIKit
import SnapKit
import MJRefresh
import MBProgressHUD

class CustomerDetailsTableView: UIView {

    /// cell类型
    enum CellStyle: Int {
        /// 在线项目
        case project = 0
//        /// 参与人员
//        case personnel = 1
        /// 拜访历史
        case history = 1
        /// 历史合同
        case contract = 2
        /// 联系人
        case visitor = 3
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
    func reload(height: CGFloat = 0) {
        if height != 0 {
            offsetY = height
            tableView.contentInset = UIEdgeInsets(top: offsetY + 40, left: 0, bottom: 0, right: 0)
            tableView.setContentOffset(CGPoint(x: 0, y: -offsetY - 40), animated: false)
        }
        setFooterView()
        if cellStyle == .history { // 拜访历史
            tableView.mj_footer.isHidden = true
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
        initFooterViews()
        setTableView()
    }
    
    // MARK: - 自定义私有方法
    /// 底部按钮控件初始化
    private func initFooterViews() {
        footerView = UIView().taxi.adhere(toSuperView: self) // 底部视图
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview().priority(800)
                footerConstraint = make.height.equalTo(0).constraint
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
                if cellStyle != .project {
                    tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                }
                
                tableView.contentInset = UIEdgeInsets(top: offsetY + 40, left: 0, bottom: 0, right: 0)
                tableView.setContentOffset(CGPoint(x: 0, y: -offsetY - 40), animated: false)
                
                
                tableView.register(CostomerDetailsProjectCell.self, forCellReuseIdentifier: "CostomerDetailsProjectCell")
                tableView.register(ProjectDetailsVisitCell.self, forCellReuseIdentifier: "ProjectDetailsVisitCell")
                tableView.register(CostomerDetailsVisitorCell.self, forCellReuseIdentifier: "CostomerDetailsVisitorCell")
                tableView.register(CostomerDetailsContractCell.self, forCellReuseIdentifier: "CostomerDetailsContractCell")
                tableView.register(ProjectDetailsPersonnelCell.self, forCellReuseIdentifier: "ProjectDetailsPersonnelCell")
                
                
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.reload()
                })
                if cellStyle == .history || cellStyle == .contract {
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
    private func setFooterView() {
        if cellStyle == .history { // 拜访历史
            addBtn.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            grayView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            addBtn.isHidden = true
            tipsLabel.text = "注：可看到您和您的下级的拜访，您接手的拜访，\n以及您工作组中其他成员的拜访"
        } else if cellStyle == .project { // 在线项目
            addBtn.setTitle(" 添加项目", for: .normal)
        } else if cellStyle == .visitor { // 联系人
            tipsLabel.text = "注：可看到您和您的下级的拜访对象"
            addBtn.setTitle(" 添加联系人", for: .normal)
        } else if cellStyle == .contract { // 合同
            addBtn.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            grayView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            addBtn.isHidden = true
            tipsLabel.text = "注：可看到您和您的下级参与的合同以及您接手的合同"
        } else { // 参与人员
            footerConstraint.activate()
            footerView.isHidden = true
        }
    }
    
    /// 设置尾视图
    @objc func setTableFooterView() {
        self.layoutIfNeeded()
        let old = self.tableView.tableFooterView?.height ?? 0
        var footerHeight = ScreenHeight - NavigationH - self.tableView.contentSize.height - 40 - SafeH + old
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
            self.tableView.tableFooterView = UIView()
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
                    str = " 新增联系人"
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
    /// 获取项目统计列表
    private func projectListStatistics() {
        MBProgressHUD.showWait("")
        let customerIdStr = "\(customerId)"
        _ = APIService.shared.getData(.projectList("", customerIdStr, 1, 9999), t: ProjectListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.projectData = result.data
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            self.tableView.isNoData = self.projectData.count == 0
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.isNoData = self.projectData.count == 0
            MBProgressHUD.showError(error ?? "获取在线项目失败")
        })
    }
    
    /// 客户联系人列表
    private func customerContactList() {
        _ = APIService.shared.getData(.customerContactList(customerId, 1, 9999), t: CustomerContactListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.contactListData = result.data
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            self.tableView.isNoData = self.contactListData.count == 0
            self.setTableFooterView()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.isNoData = self.contactListData.count == 0
            MBProgressHUD.showError(error ?? "获取联系人失败")
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
            MBProgressHUD.showError(error ?? "获取历史拜访失败")
        })
    }
    
    /// 历史合同
    private func contractList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        let startTimeStamp = timeStamp == 0 ? nil : timeStamp
        _ = APIService.shared.getData(.contractList("", customerId, nil, nil, newPage, 10, startTimeStamp, nil, nil,nil,nil,nil), t: ContractListModel.self, successHandle: { (result) in
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
    
    /// 客户跟进人员
    private func customerMembers() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.customerMembers(customerId), t: CustomerMembersModel.self, successHandle: { (result) in
            self.customerMembersData = result.data
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            self.setTableFooterView()
            self.tableView.isNoData = self.customerMembersData.count == 0
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取参与人员失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击添加按钮
    @objc private func addClick() {
        if cellStyle == .project {
            let ejectView = AddProjectEjectView()
            ejectView.customerId = customerId
            ejectView.isApply = false
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
        } else if cellStyle == .visitor { // 联系人
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
        } else if cellStyle == .visitor { // 联系人
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostomerDetailsVisitorCell", for: indexPath) as! CostomerDetailsVisitorCell
            let data = contactListData[row]
            cell.editBlock = {
                let ejectView = AddVisitorEjectView()
                let contentArray = [data.name ?? "", data.phone ?? "", data.position ?? ""]
                ejectView.modifyData = ("修改联系人信息", contentArray, data.id)
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
//        if section == 1 {
//            return nil
//        } else if cellStyle == .history {
//            return timeFooterViewHandle()
//        } else if cellStyle == .project {
//            if Jurisdiction.share.isAddProject {
//                return addFooterViewHandle()
//            }
//            return nil
//        } else if cellStyle == .visitor {
//            return addFooterViewHandle()
//        } else {
//            return nil
//        }
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
