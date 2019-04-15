//
//  SelePersonnelController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  选择成员  控制器

import UIKit
import MJRefresh
import MBProgressHUD

class SelePersonnelController: UIViewController {
    
    /// 选择方式
    enum SeleMode {
        /// 部门添加人员 （部门id）
        case departmentAddUsers(Int)
    }
    
    /// 确定回调
    var determineBlock: (() -> ())?
    /// 多选
    var isMultiple = true
    /// 禁止选ids
    var prohibitIds = [Int]()
    /// 显示数据 (标题   确认按钮文本  调用接口)
    var displayData = ("邀请成员", "邀请", SeleMode.departmentAddUsers(0))
    
    /// 搜索框
    private var searchBar: UISearchBar!
    /// tableview
    private var tableView: UITableView!
    /// 确定按钮
    private var determineBtn: UIButton!
    /// 已选
    private var selectedLabel: UILabel!
    
    /// 数据
    private var data = [UsersData]()
    /// 选中数据
    private var seleData = [UsersData]()
    /// 源数据
    private var sourceData = [UsersData]()
    /// 页码
    private var page = 1
    /// 选中的id
    private var selectedIds = [Int]()
    /// 选中的位置 (用于单选)
    private var seleRows = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        users(isMore: false)
    }
    

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = displayData.0
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
                make.top.equalTo(searchView).offset(10)
                make.left.equalTo(searchView).offset(15)
                make.right.equalTo(searchView).offset(-15)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
//                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.returnKeyType = .done
            })
        
        determineBtn = UIButton().taxi.adhere(toSuperView: view) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(44)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : -18)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitleColor(.white, for: .normal)
                btn.setTitle(displayData.1, for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(searchView.snp.bottom)
                make.bottom.equalTo(determineBtn.snp.top).offset(-18)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.register(SelePersonnelCell.self, forCellReuseIdentifier: "SelePersonnelCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.users(isMore: false)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.users(isMore: true)
                })
            })
    }
    
    /// 初始化顶部视图
    private func initHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 37))
        headerView.backgroundColor = UIColor(hex: "#F3F3F3")
        
        selectedLabel = UILabel().taxi.adhere(toSuperView: headerView) // 已选
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "已选 \(selectedIds.count)/\(data.count)"
                label.textColor = UIColor(hex: "#999999")
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        return headerView
    }
    
    /// 多选处理
    ///
    /// - Parameter row: 点击的行数
    private func multipleHandle(row: Int) {
        let id = data[row].id
        var seleIndex = -1 // 选择位置
        for index in 0..<selectedIds.count {
            let selectedId = selectedIds[index]
            if selectedId == id {
                seleIndex = index
                break
            }
        }
        if seleIndex == -1 { // 之前没有勾选
            selectedIds.append(id)
            seleData.append(data[row])
        } else { // 之前有勾选
            selectedIds.remove(at: seleIndex)
            seleData.remove(at: seleIndex)
        }
        selectedLabel.text = "已选 \(selectedIds.count)/\(data.count)"
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
    
    /// 单选处理
    ///
    /// - Parameter row: 点击的行数
    private func singleHandle(row: Int) {
        let id = data[row].id
        if selectedIds.count == 0 {
            seleRows.append(row)
            selectedIds.append(id)
            seleData.append(data[row])
        } else if id != selectedIds[0] {
            let oldRow = seleRows[0]
            seleRows[0] = row
            selectedIds[0] = id
            seleData[0] = data[row]
            tableView.reloadRows(at: [IndexPath(row: oldRow, section: 0)], with: .fade)
        } else {
            return
        }
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
    
    /// 数据处理 -> 搜索状态：把点击的数据放在顶部
    private func dataHandle(isMore: Bool) {
        for id in prohibitIds { // 去除数据源中已经 禁止选中 的数据
            sourceData = sourceData.filter { (sourceModel) -> Bool in
                return sourceModel.id != id
            }
        }
        
        for model in seleData { // 去除数据源中 已经选中 的数据
            sourceData = sourceData.filter { (sourceModel) -> Bool in
                return sourceModel.id != model.id
            }
        }
        
        if !isMore { // 如果是下拉 就把 选中数据 放在最前面
            data = seleData
        }
        for model in sourceData {
            data.append(model)
        }
    }
    
    
    // MARK: - Api
    /// 获取用户列表
    private func users(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.users(newPage, 10, searchBar.text ?? "", 1), t: UsersModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.sourceData.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.sourceData = result.data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            if newPage == result.max_page {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.dataHandle(isMore: isMore)
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
    
    /// 新增部门人员
    private func departmentsAddUsers() {
        MBProgressHUD.showWait("")
        var deptId = 0
        switch displayData.2 {
        case .departmentAddUsers(let id): deptId = id
        }
        _ = APIService.shared.getData(.departmentsAddUsers(deptId, selectedIds), t: LoginModel.self, successHandle: { (result) in
            if self.determineBlock != nil {
               self.determineBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "新增人员失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击确定
    @objc private func determineClick() {
        departmentsAddUsers()
    }

}

extension SelePersonnelController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelePersonnelCell", for: indexPath) as! SelePersonnelCell
        let row = indexPath.row
        let seleModel = data[row]
        var isSele = selectedIds.count != 0
        if isSele { // 有数据
            if isMultiple {
                isSele = false
                for index in 0..<selectedIds.count {
                    let selectedId = selectedIds[index]
                    if selectedId == seleModel.id {
                        isSele = true
                        break
                    }
                }
            } else {
                isSele = selectedIds[row] == seleModel.id
            }
        }
        cell.data = (seleModel.realname ?? "", isSele)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isMultiple {
            return initHeaderView()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isMultiple {
            return 37
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        if isMultiple {
            multipleHandle(row: row)
        } else {
            singleHandle(row: row)
        }
        determineBtn.isEnabled = seleData.count > 0 // 处理按钮可否点击
        determineBtn.backgroundColor = seleData.count > 0 ? UIColor(hex: "#2E4695") : UIColor(hex: "#999999")
    }
}
