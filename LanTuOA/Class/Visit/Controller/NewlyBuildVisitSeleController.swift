//
//  NewlyBuildVisitSeleController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  新建拜访  选择  控制器

import UIKit
import MJRefresh
import MBProgressHUD

class NewlyBuildVisitSeleController: UIViewController {

    /// 选择类型
    enum SeleType {
        /// 客户
        case customer
        /// 拜访人
        case visitor(Int)
        /// 项目
        case project(Int)
    }
    
    /// 选中回调 (id + 文本)
    var seleBlock: (([(Int, String)]) -> ())?
    /// 选择类型
    var type: SeleType = .customer
    
    
    /// 搜索框
    private var searchBar: UISearchBar!
    /// tableview
    private var tableView: UITableView!
    /// 确定按钮
    private var determineBtn: UIButton!
    
    /// 是否可多选
    private var isMultiple = false
    /// 选择数组（可多选 so是数组）
    private var seleArray = [(Int, String)]()
    /// 选择数据位置（可多选 so是数组）
    private var seleIndexArray = [Int]()
    /// 搜索框提示文本
    private var searchStr = ""
    /// 页码
    private var page = 1
    /// 客户id (拜访人，项目使用)
    private var customerId = -1
    /// 客户数据
    private var customerData = [CustomerListStatisticsData]()
    /// 拜访人数据
    private var visitorData = [CustomerContactListData]()
    /// 项目数据
    private var projectData = [ProjectListData]()
    /// 拜访位置数据
    private var positionData = [CustomerListStatisticsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
    }

    // MARK: - 自定义私有方法
    /// 设置标题栏
    private func setNav() {
        var titleStr = ""
        var rightStr = ""
        switch type {
        case .customer:
            titleStr = "客户"
            rightStr = "新增客户"
            searchStr = "客户名称"
        case .visitor(let id):
            customerId = id
            isMultiple = true
            titleStr = "拜访人"
            rightStr = "新增拜访人"
            searchStr = "拜访人名称"
        case .project(let id):
            customerId = id
            titleStr = "项目"
            rightStr = "新增项目"
            searchStr = "项目名称"
        }
        getData(isMore: false) // 获取一页数据
        title = titleStr
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightStr,
                                                                titleColor: .white,
                                                                titleFont: UIFont.medium(size: 15),
                                                                titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                                target: self,
                                                                action: #selector(rightClick))
    }
    
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = .white
        
        searchBar = UISearchBar().taxi.adhere(toSuperView: view) // 搜索框
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
//                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = searchStr
                searchBar.returnKeyType = .done
            })
        
        determineBtn = UIButton().taxi.adhere(toSuperView: view) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(44)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : -18)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitle("选定", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // 显示数据tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(searchBar.snp.bottom).offset(10)
                make.bottom.equalTo(determineBtn.snp.top).offset(-18)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 44
                tableView.tableFooterView = UIView()
                tableView.register(NewlyBuildSeleCell.self, forCellReuseIdentifier: "NewlyBuildSeleCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.getData(isMore: false)
                    tableView.mj_footer.isHidden = true
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    self?.getData(isMore: true)
                    tableView.mj_header.isHidden = true
                })
            })
        
        _ = UIView().taxi.adhere(toSuperView: view) // 灰色块
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(10)
                make.left.right.equalToSuperview()
                make.top.equalTo(searchBar.snp.bottom)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
    }
    
    /// 获取数据处理
    ///
    /// - Parameter isMore: 是否是加载更多
    private func getData(isMore: Bool) {
        switch type {
        case .customer:
            customerListStatistics(isMore: isMore)
        case .visitor:
            customerContactList(isMore: isMore)
        case .project:
            projectList(isMore: isMore)
        }
    }
    
    /// 点亮确认按钮
    private func determineHandle() {
        determineBtn.isEnabled = seleIndexArray.count > 0
        determineBtn.backgroundColor = seleIndexArray.count > 0 ? UIColor(hex: "#2E4695") : UIColor(hex: "#CCCCCC")
    }
    
    // MARK: - Api
    /// 获取客户列表
    ///
    /// - Parameter isMore: 是否是加载更多
    private func customerListStatistics(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.customerListStatistics("", 1, nil, newPage, 10), t: CustomerListStatisticsModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.customerData.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.customerData = result.data
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
    
    /// 获取客户联系人列表
    ///
    /// - Parameter isMore: 是否是加载更多
    private func customerContactList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.customerContactList(customerId, newPage, 10), t: CustomerContactListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.visitorData.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.visitorData = result.data
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
    
    /// 获取项目列表
    ///
    /// - Parameter isMore: 是否是加载更多
    private func projectList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.projectList("", customerId, newPage, 10), t: ProjectListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.projectData.append(model)
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
                self.projectData = result.data
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
    /// 点击导航栏右按钮
    @objc private func rightClick() {
        
    }
    
    /// 点击确认
    @objc private func determineClick() {
        if seleBlock != nil {
            seleBlock!(seleArray)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension NewlyBuildVisitSeleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .customer: return customerData.count
        case .visitor: return visitorData.count
        case .project: return projectData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var name = ""
        var seleIndex = -1
        let row = indexPath.row
        switch type {
        case .customer: // 客户
            name = customerData[row].name ?? ""
            if seleArray.count > 0 { // 防止报错
                seleIndex = seleIndexArray.first ?? -1
            }
        case .visitor: // 拜访人 多选
            name = visitorData[row].name ?? ""
            for index in seleIndexArray {
                if row == index {
                    seleIndex = row
                    break
                }
            }
        case .project: // 项目
            name = projectData[row].name ?? ""
            if seleArray.count > 0 { // 防止报错
                seleIndex = seleIndexArray.first ?? -1
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildSeleCell", for: indexPath) as! NewlyBuildSeleCell
        cell.data = (name, seleIndex == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if isMultiple { // 可多选 (必定是选择拜访人)
            var isSele = false // 是否已经选择过
            for index in seleIndexArray {
                if row == index {
                    isSele = true
                    break
                }
            }
            if isSele {
                seleArray.remove(at: row)
                seleIndexArray.remove(at: row)
            } else {
                let id = visitorData[row].id
                let str = visitorData[row].name ?? ""
                seleArray.append((id, str))
                seleIndexArray.append(row)
            }
            tableView.reloadRows(at: [indexPath], with: .fade)
        } else { // 不可多选 （客户、项目、所在位置）
            var seleIndex = -1
            if seleArray.count > 0 { // 防止报错
                seleIndex = seleIndexArray.first ?? -1
            } else { // 没有点击过 初始化数据
                seleArray.append((-1, ""))
                seleIndexArray.append(-1)
            }
            if seleIndex == row { // 点击已经选中的cell
                return
            } else {
                var id = 0
                var name = ""
                switch type {
                case .customer:
                    id = customerData[indexPath.row].id
                    name = customerData[indexPath.row].name ?? ""
                case .visitor: break
                case .project:
                    id = projectData[indexPath.row].id
                    name = projectData[indexPath.row].name ?? ""
                }
                seleArray[0] = (id, name)
                seleIndexArray[0] = row
            }
            tableView.reloadRows(at: [indexPath], with: .fade)
            if seleIndex != -1 {
                tableView.reloadRows(at: [IndexPath(row: seleIndex, section: 0)], with: .fade)
            }
        }
        determineHandle()
    }
}
