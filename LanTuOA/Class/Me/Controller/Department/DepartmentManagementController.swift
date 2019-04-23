//
//  DepartmentManagementController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  部门管理 控制器

import UIKit
import MJRefresh
import MBProgressHUD

class DepartmentManagementController: UIViewController {

    /// 搜索框
    private var searchBar: UISearchBar!
    /// tableview
    private var tableView: UITableView!
    
    /// 部门列表数据
    private var data = [DepartmentsData]()
    /// 部门列表源数据
    private var sourceData = [DepartmentsData]()
    /// 当前页码
    private var page = 1
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 父部门id // TODO:可能后期会使用
    private var parentId = -1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        departments()
    }

    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        title = "部门管理"
        view.backgroundColor = UIColor(hex: "#F3F3F3")
        if Jurisdiction.share.isAddDepartment {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增部门",
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
                searchBar.placeholder = "部门名称"
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
                tableView.backgroundColor = .white
                tableView.estimatedRowHeight = 200
                tableView.tableFooterView = UIView()
                tableView.register(DepartmentManagementCell.self, forCellReuseIdentifier: "DepartmentManagementCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.departments()
                })
            })
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            screenData()
        }
    }
    
    /// 筛选数据
    private func screenData() {
        let searchStr = searchBar.text ?? ""
        if searchStr.count > 0 {
            data = []
            for model in sourceData {
                let name = model.name ?? ""
                if name.contains(searchStr) {
                    data.append(model)
                }
            }
        } else {
            data = sourceData
        }
        tableView.reloadData()
    }
    
    // MARK: - Api
    /// 部门列表
    private func departments() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.departments(nil), t: DepartmentsModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.data = result.data
            self.tableView.reloadData()
            self.sourceData = result.data
            self.tableView.mj_header.endRefreshing()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取部门列表失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击添加部门
    @objc private func rightClick() {
        let ejectView = DepartmentEjectView()
        ejectView.createBlock = { [weak self] in
            self?.departments()
        }
        ejectView.show()
    }
}

extension DepartmentManagementController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentManagementCell", for: indexPath) as! DepartmentManagementCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DepartmentalStaffController()
        vc.departmentsData = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DepartmentManagementController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
