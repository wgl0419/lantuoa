//
//  ContractDetailsTableView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  各个类型的tableview 

import UIKit
import MJRefresh
import MBProgressHUD

class ContractDetailsTableView: UITableView {

    /// 变动回调
    var changeBlock: (() -> ())?
    /// cell类型
    enum CellStyle: Int {
        /// 发布内容
        case content = 0
        /// 回款情况
        case repayment = 1
        /// 业绩详情
        case performance = 2
        /// 备注信息
        case remarks = 3
    }
    /// 已经偏移高度
    var offsetY: CGFloat! {
        didSet {
            contentInset = UIEdgeInsets(top: offsetY + 40, left: 0, bottom: 0, right: 0)
            setContentOffset(CGPoint(x: 0, y: -offsetY - 40), animated: false)
            setTableFooterView()
        }
    }
    /// 合同数据
    var contractListData: ContractListData! {
        didSet {
            contractListSmallData = contractListData.data
            contractUsersData = contractListData.contractUsers
        }
    }
    /// 合同数据 （用于发布内容使用）
    var contractListSmallData = [ContractListSmallData]()
    /// 参与合同人员  （用于业绩详情）
    var contractUsersData = [ContractListContractUsers]()
    
    /// 滚动回调
    var scrollBlock: ((CGFloat) -> ())?
    
    /// cell类型
    private var cellStyle: CellStyle = .content
    /// 合同id
    private var contractId = 0
    /// 当前页码
    private var page = 1
    /// 回款情况
    private var repaymentData = [ContractPaybackListData]()
    /// 第一次加载
    private var isFirst = true
    //**************业绩****************//
    /// 业绩详情
    private var performanceData = [PerformListData]()
    /// 选择合同人位置
    private var seleContractUsers = 0
    /// 展开位置数组
    private var openArray = [Bool]()
    //**************备注****************//
    var contractDescData = [ContractDescListData]()
    
    /// 加载刷新
    func getData() {
        if isFirst {
            reload()
            isFirst = false
        }
    }
    
    /// 刷新数据
    func reload() {
        if cellStyle == .content { // 发布内容
            setTableFooterView()
        } else if cellStyle == .repayment { // 回款详情
            contractPaybackList()
        } else if cellStyle == .performance { // 业绩详情
            performList()
        } else { // 备注信息
            contractDescList()
        }
    }
    
    convenience init(style: CellStyle, height: CGFloat, contractId: Int) {
        self.init()
        cellStyle = style
        offsetY = height
        self.contractId = contractId
        setTableView()
    }

    // MARK: - 自定义私有方法
    /// 设置tableView
    private func setTableView() {
        delegate = self
        dataSource = self
        if cellStyle != .remarks {
            separatorStyle = .none
        } else {
            separatorStyle = .singleLine
        }
        
        estimatedRowHeight = 50
        
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
        
        register(ContractDetailsContentCell.self, forCellReuseIdentifier: "ContractDetailsContentCell")
        register(ContractRepaymentCell.self, forCellReuseIdentifier: "ContractRepaymentCell")
        register(ContractRepaymentHeaderCell.self, forCellReuseIdentifier: "ContractRepaymentHeaderCell")
        register(ContractPerformanceHeaderCell.self, forCellReuseIdentifier: "ContractPerformanceHeaderCell")
        register(ContractPerformanceCell.self, forCellReuseIdentifier: "ContractPerformanceCell")
        register(ContractRemarksCell.self, forCellReuseIdentifier: "ContractRemarksCell")
        
        if cellStyle == .repayment { // 回款详情
            setNoneData(str: "暂无回款记录！", imageStr: "noneData5")
        } else if cellStyle == .remarks { // 备注信息
            setNoneData(str: "暂无备注记录！", imageStr: "noneData")
        }
        
        if cellStyle == .content { // 发布内容
            setTableFooterView()
        } else {
            mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                self?.reload()
            })
        }
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
    }
    
    /// 设置尾视图
    @objc func setTableFooterView() {
        self.layoutIfNeeded()
        let old = self.tableFooterView?.height ?? 0
        let footerHeight = ScreenHeight - NavigationH - self.contentSize.height - 40 + old
        if footerHeight > 0 {
            self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: footerHeight))
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    /// 设置展开位置数组
    private func setOpenArray() {
        for _ in 0..<performanceData.count {
            openArray.append(false)
        }
    }
    
    /// 设置业绩头视图
    private func setPerformanceHeaderView() {
        let headerView = ContractPerformanceHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 98))
        headerView.contractUsersData = contractUsersData
        var totalPerformance: Float = 0 // 总业绩金额
        for model in performanceData {
            totalPerformance += model.money
        }
        // 发布总额 -> 减去制作费和支持
        let totalMoney = contractListData.totalMoney - contractListData.makeMoney - contractListData.rebate
        
        let model = contractUsersData[seleContractUsers]
        headerView.data = (totalMoney, model.realname ?? "", model.propPerform, totalPerformance)
        headerView.seleBlock = { [weak self] (seleIndex) in
            self?.seleContractUsers = seleIndex
            self?.performList()
        }
        self.tableHeaderView = headerView
    }
    
    /// 设置回款表尾
    private func setRepaymentFooter(title: String) -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 45))
        footerView.backgroundColor = .white
        
        _ = UIButton().taxi.adhere(toSuperView: footerView) // 添加按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle(title, for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setImage(UIImage(named: "add"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
            })
        
        for index in 0..<2 {
            _ = UIView().taxi.adhere(toSuperView: footerView) // 分割线
                .taxi.layout(snapKitMaker: { (make) in
                    if index == 0 {
                        make.top.equalToSuperview()
                    } else {
                        make.bottom.equalToSuperview()
                    }
                    make.left.right.equalToSuperview()
                    make.height.equalTo(1)
                })
                .taxi.config({ (view) in
                    view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                })
        }
        
        return footerView
    }
    
    // MARK: - Api
    /// 回款列表
    private func contractPaybackList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.contractPaybackList(contractId), t: ContractPaybackListModel.self, successHandle: { (result) in
            self.repaymentData = result.data
            self.mj_header.endRefreshing()
            self.reloadData()
            self.setTableFooterView()
            MBProgressHUD.dismiss()
            self.isNoData = self.repaymentData.count == 0
        }, errorHandle: { (error) in
            self.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取回款列表失败")
        })
    }
    
    /// 业绩列表
    private func performList() {
        MBProgressHUD.showWait("")
        guard contractUsersData.count != 0 else {
            return
        }
        let model = contractUsersData[seleContractUsers]
        _ = APIService.shared.getData(.performList(1, model.userId, nil, model.contractId), t: PerformListModel.self, successHandle: { (result) in
            self.performanceData = result.data
            self.setPerformanceHeaderView()
            self.mj_header.endRefreshing()
            self.setOpenArray()
            self.reloadData()
            self.setTableFooterView()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            self.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取业绩列表失败")
        })
    }
    
    /// 合同备注信息列表
    private func contractDescList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.contractDescList(contractId), t: ContractDescListModel.self, successHandle: { (result) in
            self.contractDescData = result.data
            self.mj_header.endRefreshing()
            self.reloadData()
            self.setTableFooterView()
            MBProgressHUD.dismiss()
            self.isNoData = self.contractDescData.count == 0
        }, errorHandle: { (error) in
            self.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取备注信息失败")
        })
    }
    
    /// 修改回款
    private func contractPaybackUpdate(paybackId: Int, desc: String, money: Float, payTime: Int) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.contractPaybackUpdate(paybackId, desc, money, payTime), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if self.changeBlock != nil {
                self.changeBlock!()
            }
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "修改回款失败")
        })
    }
    
    /// 添加回款
    private func contractPaybackAdd(desc: String, money: Float, payTime: Int) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.contractPaybackAdd(contractId, desc, money, payTime), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if self.changeBlock != nil {
                self.changeBlock!()
            }
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "添加回款失败")
        })
    }
    
    /// 添加备注
    private func contractDescCreate(desc: String) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.contractDescCreate(contractId, desc), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if self.changeBlock != nil {
                self.changeBlock!()
            }
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "添加备注失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击添加
    @objc private func addClick() {
        if cellStyle == .repayment { // 回款列表
            let showView = ContractRepaymentEjectView()
            showView.titleStr = "新增回款"
            showView.editBlock = { [weak self] (desc, money, payTime) in
                self?.contractPaybackAdd(desc: desc, money: money, payTime: payTime)
            }
            showView.show()
        } else { // 备注列表
            let showView = AddRemarksEjectView()
            showView.confirmBlock = { [weak self] (str) in
                self?.contractDescCreate(desc: str)
            }
            showView.show()
        }
    }
}

extension ContractDetailsTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellStyle == .performance {
            return performanceData.count > 0 ? performanceData.count * 2 : 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellStyle == .content { // 内容
            return contractListSmallData.count
        } else if cellStyle == .repayment { // 回款
            return repaymentData.count + 1
        } else if cellStyle == .performance { // 业绩
            if section % 2 == 0 { // 有箭头的cell
                return 1
            } else {
                let trueSection = section / 2
                let isOpen = openArray[trueSection]
                return isOpen ? performanceData[trueSection].children.count : 0
            }
        } else {
            return contractDescData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if cellStyle == .content {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContractDetailsContentCell", for: indexPath) as! ContractDetailsContentCell
            cell.data = contractListSmallData[indexPath.row]
            return cell
        } else if cellStyle == .repayment { // 回款详情
            if row == 0 { // 顶部cell -> 标题
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContractRepaymentHeaderCell", for: indexPath) as! ContractRepaymentHeaderCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContractRepaymentCell", for: indexPath) as! ContractRepaymentCell
                cell.backgroundColor = row % 2 == 1 ? .white : UIColor(hex: "#F3F3F3")
                cell.data = repaymentData[row - 1]
//                cell.editBlock = { [weak self] in
//                    let showView = ContractRepaymentEjectView()
//                    showView.titleStr = "修改回款"
//                    showView.data = self?.repaymentData[row - 1]
//                    showView.editBlock = { (desc, money, payTime) in
//                        let id = self?.repaymentData[row - 1].id ?? 0
//                        self?.contractPaybackUpdate(paybackId: id, desc: desc, money: money, payTime: payTime)
//                    }
//                    showView.show()
//                }
                return cell
            }
        } else if cellStyle == .performance { // 业绩详情
            if section % 2 == 0 { // 标题cell -> 年份
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContractPerformanceHeaderCell", for: indexPath) as! ContractPerformanceHeaderCell
                let trueSection = section / 2
                cell.data = (performanceData[trueSection].title ?? "", performanceData[trueSection].money, openArray[trueSection])
                return cell
            } else { // 月份数据
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContractPerformanceCell", for: indexPath) as! ContractPerformanceCell
                let trueSection = section / 2
                cell.data = (performanceData[trueSection].title ?? "", row + 1, performanceData[trueSection].children[row].money)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContractRemarksCell", for: indexPath) as! ContractRemarksCell
            cell.contentStr = contractDescData[row].desc ?? ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if cellStyle == .remarks && Jurisdiction.share.isManageContractDesc {
            return 45
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if cellStyle == .remarks && Jurisdiction.share.isManageContractDesc {
            return setRepaymentFooter(title: " 新增备注信息")
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section % 2
        if cellStyle == .performance && indexPath.row == 0 && section == 0 {
            let trueSection = indexPath.section / 2
            let cell = tableView.cellForRow(at: indexPath) as! ContractPerformanceHeaderCell
            cell.changeOpen()
            openArray[trueSection] = !openArray[trueSection]
            tableView.reloadSections(IndexSet(integer: indexPath.section + 1), with: .fade)
            setTableFooterView()
        }
    }
}

extension ContractDetailsTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollBlock != nil {
            scrollBlock!(scrollView.contentOffset.y)
        }
    }
}
