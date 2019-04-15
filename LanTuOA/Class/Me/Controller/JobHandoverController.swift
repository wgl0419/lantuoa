//
//  JobHandoverController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作交接 控制器

import UIKit
import MJRefresh
import MBProgressHUD

class JobHandoverController: UIViewController {
    
    /// 搜索框
    private var searchBar: UISearchBar!
    /// tableview
    private var tableview: UITableView!
    
    /// 数据
    private var data = [WorkExtendListData]()
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        workExtendList()
    }
    
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "工作交接"
        view.backgroundColor = .white
        
        let searchView = UIView().taxi.adhere(toSuperView: view) // 搜索框背景
            .taxi.layout { (make) in
                make.left.right.top.equalToSuperview()
            }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        searchBar = UISearchBar()
            .taxi.adhere(toSuperView: searchView) // 搜索框
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(searchView)
                make.top.left.equalTo(searchView).offset(10)
                make.right.equalTo(searchView).offset(-15)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = "员工名称"
                searchBar.returnKeyType = .done
            })
        
        tableview = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 110
                tableView.tableFooterView = UIView()
                tableView.register(JobHandoverCell.self, forCellReuseIdentifier: "JobHandoverCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.workExtendList()
                })
            })
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            workExtendList()
        }
    }
    
    // MARK: - Api
    /// 获取下级成员列表
    private func workExtendList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workExtendList(searchBar.text ?? ""), t: WorkExtendListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.data = result.data
            self.tableview.mj_header.endRefreshing()
            self.tableview.reloadData()
        }, errorHandle: { (error) in
            self.tableview.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
}

extension JobHandoverController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobHandoverCell", for: indexPath) as! JobHandoverCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = HandoverStaffController()
        vc.userData = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension JobHandoverController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
