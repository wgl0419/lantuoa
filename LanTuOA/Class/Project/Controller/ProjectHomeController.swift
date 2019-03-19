//
//  ProjectHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目 首页 控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ProjectHomeController: UIViewController {

    /// 客户id
    var customerId = 0
    /// 客户名称
    var customerName = ""
    
    /// tableView
    private var tableView: UITableView!
    
    /// 数据
    private var data = [ProjectListStatisticsData]()
    /// 当前页码
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        projectListStatistics(isMore: false)
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        title = customerName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增项目",
                                                            titleColor: .white,
                                                            titleFont: UIFont.medium(size: 15),
                                                            titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                            target: self,
                                                            action: #selector(rightClick))
    }
    
    /// 初始化子控件
    private func initSubViews() {
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableView
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalTo(view)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 200
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(ProjectListCell.self, forCellReuseIdentifier: "ProjectListCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.projectListStatistics(isMore: false)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.projectListStatistics(isMore: true)
                })
            })
    }
    
    // MARK: - Api
    /// 获取项目统计列表
    ///
    /// - Parameter isMore: 是否上拉
    private func projectListStatistics(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.projectListStatistics("", customerId, newPage, 10, nil), t: ProjectListStatisticsModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.data.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                if result.data.count == 0 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self.tableView.mj_footer.resetNoMoreData()
                }
                self.page += 1
            } else {
                self.page = 1
                self.data = result.data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
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
    
    // MARK: - 按钮点击
    /// 点击新增项目
    @objc private func rightClick() {
        
    }
}


extension ProjectHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectListCell", for: indexPath) as! ProjectListCell
        cell.data = data[indexPath.row]
        return cell
    }
    
}
