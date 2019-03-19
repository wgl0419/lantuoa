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
    
    /// 数据
    private var data = [CustomerListStatisticsData]()
    /// 当前页码
    private var page = 1
    /// 是否还有下一页数据
    private var isUpdate = true
    
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
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        nav.backBtn.isHidden = false
    }
    
    /// 初始化子控件
    private func initSubViews() {
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // 主要tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
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
    
    // MARK: - Api
    /// 获取项目统计列表
    ///
    /// - Parameter isMore: 是否上拉
    private func customerListStatistics(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.customerListStatistics("", 1, nil, newPage, 10), t: CustomerListStatisticsModel.self, successHandle: { (result) in
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
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
}

extension CustomerHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerHomeCell", for: indexPath) as! CustomerHomeCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProjectHomeController()
        vc.customerId = data[indexPath.row].id
        vc.customerName = data[indexPath.row].name ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
