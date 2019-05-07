//
//  HandoverStaffSeleController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作接手(工作交接 选择员工)  控制器

import UIKit
import MJRefresh
import MBProgressHUD

class HandoverStaffSeleController: UIViewController {

    /// 交接成功回调
    var workExtendBlock: (() -> ())?
    /// 原员工数据
    var oldUserId = 0
    /// 要交接项目的id
    var projectId = 0
    
    
    /// tableview
    private var tableView: UITableView!
    /// 搜索框
    private var searchBar: UISearchBar!
    /// 选定按钮
    private var selectedBtn: UIButton!
    
    
    /// 数据
    private var data = [WorkExtendListData]()
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 选中cell的row
    private var seleRow = -1
    /// 页码
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        workExtendList()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "工作接手"
        view.backgroundColor = UIColor(hex: "#F3F3F3")
        
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
        
        selectedBtn = UIButton().taxi.adhere(toSuperView: view) // 选定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : -18)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitle("选定", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.addTarget(self, action: #selector(selectedClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(searchView.snp.bottom).offset(10)
                make.bottom.equalTo(selectedBtn.snp.top).offset(-18)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.register(HandoverStaffSeleCell.self, forCellReuseIdentifier: "HandoverStaffSeleCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.workExtendList()
                })
            })
        
        self.perform(#selector(addClipRectCorner), with: nil, afterDelay: 0.01)
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            workExtendList()
        }
    }
    
    /// 使按钮能高亮
    private func setSelectedBtn() {
        selectedBtn.isEnabled = true
        selectedBtn.backgroundColor = UIColor(hex: "#2E4695")
        
    }
    
    /// 添加圆角
    @objc private func addClipRectCorner() {
        let rectCorner = UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue
        tableView.clipRectCorner(UIRectCorner(rawValue: rectCorner), cornerRadius: 4)
    }
    
    // MARK: - Api
    /// 获取下级成员列表
    private func workExtendList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workExtendList(searchBar.text ?? "", 1), t: WorkExtendListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.data = result.data
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 交接工作
    private func workExtendExtend() {
        MBProgressHUD.showWait("")
        let newUserId = data[seleRow].id
        _ = APIService.shared.getData(.workExtendExtend(projectId, oldUserId, newUserId), t: LoginModel.self, successHandle: { (result) in
            if self.workExtendBlock != nil {
                self.workExtendBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取员工列表失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击选定
    @objc private func selectedClick() {
        workExtendExtend()
    }
}

extension HandoverStaffSeleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HandoverStaffSeleCell", for: indexPath) as! HandoverStaffSeleCell
        let row = indexPath.row
        cell.data = (data[row], seleRow == row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = seleRow
        seleRow = indexPath.row
        if row != -1 { // 有选中过
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        } else {
            setSelectedBtn()
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}


extension HandoverStaffSeleController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
