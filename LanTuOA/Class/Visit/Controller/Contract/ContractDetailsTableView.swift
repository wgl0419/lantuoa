//
//  ContractDetailsTableView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  各个类型的tableview  //TODO:业绩详情界面点击缩小时会

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
        } else { // 业绩详情
            performList()
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
        separatorStyle = .none
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
        
        if cellStyle == .repayment { // 回款详情
            
        } else if cellStyle == .performance { // 业绩详情
            
        }
        mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.reload()
        })
//        mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
//            self?.reload()
//        })
    }
    
    /// 设置尾视图
    @objc func setTableFooterView() {
        self.layoutIfNeeded()
        let old = self.tableFooterView?.height ?? 0
        let footerHeight = ScreenHeight - NavigationH - self.contentSize.height - 40 + old
        if footerHeight > 0 {
            self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: footerHeight))
//            self.footer
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
        var totalMoney: Float = 0
        for model in performanceData {
            totalMoney += model.money
        }
        
        let model = contractUsersData[seleContractUsers]
        headerView.data = (contractListData.totalMoney, model.realname ?? "", model.propPerform, totalMoney)
        headerView.seleBlock = { [weak self] (seleIndex) in
            self?.seleContractUsers = seleIndex
            self?.performList()
        }
        self.tableHeaderView = headerView
    }
    
    /// 设置回款表尾
    private func setRepaymentFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 45))
        footerView.backgroundColor = .white
        
        _ = UIButton().taxi.adhere(toSuperView: footerView) // 添加按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle(" 新增回款", for: .normal)
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
        }
        
        return footerView
    }
    
    // MARK: - Api
    /// 回款列表
    private func contractPaybackList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.contractPaybackList(contractId), t: ContractPaybackListModel.self, successHandle: { (result) in
            self.repaymentData = result.data
            self.reloadData()
            self.setTableFooterView()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
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
            self.setOpenArray()
            self.reloadData()
            self.setTableFooterView()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取业绩列表失败")
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
    
    // MARK: - 按钮点击
    /// 点击添加回款
    @objc private func addClick() {
        let showView = ContractRepaymentEjectView()
        showView.titleStr = "新增回款"
        showView.editBlock = { [weak self] (desc, money, payTime) in
            self?.contractPaybackAdd(desc: desc, money: money, payTime: payTime)
        }
        showView.show()
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
        if cellStyle == .content {
            return contractListSmallData.count
        } else if cellStyle == .repayment {
            return repaymentData.count > 0 ? repaymentData.count + 1 : 0
        } else {
            
            if section % 2 == 0 { // 有箭头的cell
                return 1
            } else {
                let trueSection = section / 2
                let isOpen = openArray[trueSection]
                return isOpen ? performanceData[trueSection].children.count : 0
            }
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
                cell.editBlock = { [weak self] in
                    let showView = ContractRepaymentEjectView()
                    showView.titleStr = "修改回款"
                    showView.data = self?.repaymentData[row - 1]
                    showView.editBlock = { (desc, money, payTime) in
                        let id = self?.repaymentData[row - 1].id ?? 0
                        self?.contractPaybackUpdate(paybackId: id, desc: desc, money: money, payTime: payTime)
                    }
                    showView.show()
                }
                return cell
            }
        } else { // 业绩详情
            
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if cellStyle == .repayment {
            return 45
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if cellStyle == .repayment {
            return setRepaymentFooter()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trueSection = indexPath.section / 2
        if cellStyle == .performance && indexPath.row == 0 && trueSection == 0 {
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
