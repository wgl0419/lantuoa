//
//  CustomerHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/15.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户首页 控制器

import UIKit
import MJRefresh
import MBProgressHUD

class CustomerHomeController: UIViewController {

    /// 主要tableview
    private var tableView: UITableView!
    /// 搜索框
    private var searchBar: UISearchBar!
    
    /// 数据
    private var data = [CustomerListStatisticsData]()
    /// 当前页码
    private var page = 1
    /// 是否还有下一页数据
    private var isUpdate = true
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        customerListStatistics(isMore: false)
    }

    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        navigationItem.title = "客户"
        let nav = navigationController as! MainNavigationController
        nav.backBtn.isHidden = false
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        if Jurisdiction.share.isAddCustomer {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增客户",
                                                                titleColor: .white,
                                                                titleFont: UIFont.medium(size: 15),
                                                                titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                                target: self,
                                                                action: #selector(rightClick))
        }
    }
    
    /// 初始化子控件
    private func initSubViews() {
        
        let barView = UIView().taxi.adhere(toSuperView: view) // bar背景view
            .taxi.layout { (make) in
                make.top.left.right.equalTo(view)
            }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        searchBar = UISearchBar().taxi.adhere(toSuperView: barView)
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(barView)
                make.top.left.equalTo(barView).offset(10)
                make.right.equalTo(barView).offset(-15)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = "项目名称/客户名称"
                searchBar.returnKeyType = .done
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // 主要tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(barView.snp.bottom)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 200
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(CustomerHomeCell.self, forCellReuseIdentifier: "CustomerHomeCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.customerListStatistics(isMore: false)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.customerListStatistics(isMore: true)
                })
            })
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            customerListStatistics(isMore: false)
        }
    }
    
    // MARK: - Api
    /// 获取项目统计列表
    ///
    /// - Parameters:
    ///   - isMore: 是否上拉
    ///   - show: 是否显示hud
    private func customerListStatistics(isMore: Bool, show: Bool = true) {
        if show { MBProgressHUD.showWait("") }
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.customerListStatistics(searchBar.text ?? "", nil, nil, newPage, 10), t: CustomerListStatisticsModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.data.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.data = result.data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            if newPage == result.max_page {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.tableView.reloadData()
        }, errorHandle: { (error) in
            if isMore {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
            } else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            if show { MBProgressHUD.showError(error ?? "获取失败") }
        })
    }
    
    // MARK: - 按钮点击
    /// 点击右按钮
    @objc private func rightClick() {
        UIApplication.shared.keyWindow?.endEditing(true)
        let ejectView = AddCustomerEjectView()
        ejectView.addBlock = { [weak self] in // 添加成功 -> 刷新
            self?.customerListStatistics(isMore: false)
        }
        ejectView.show()
    }
}

extension CustomerHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerHomeCell", for: indexPath) as! CustomerHomeCell
//        cell.editBlock = { [weak self] in
//            let vc = CustomerEditController()
//            vc.customerData = self?.data[indexPath.row]
//            vc.editBlock = { [weak self] in
//                self?.customerListStatistics(isMore: false, show: false)
//            }
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ProjectHomeController()
//        vc.customerId = data[indexPath.row].id
//        vc.customerName = data[indexPath.row].name ?? ""
//        navigationController?.pushViewController(vc, animated: true)
        let vc = CustomerEditController()
        vc.customerData = data[indexPath.row]
        vc.editBlock = { [weak self] in
            self?.customerListStatistics(isMore: false, show: false)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CustomerHomeController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
