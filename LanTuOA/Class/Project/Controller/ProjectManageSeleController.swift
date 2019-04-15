//
//  ProjectManageSeleController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/1.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目管理人 选择  控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ProjectManageSeleController: UIViewController {

    /// 返回回调 (用户id  用户名称)
    var backBlock: (([Int], [String]) -> ())?
    /// 是否可以多选
    var isMultiple = false
    
    /// 确认按钮
    private var determineBtn: UIButton!
    /// 搜索框
    private var searchBar: UISearchBar!
    /// tableview
    private var tableView: UITableView!
    
    /// 页码
    private var page = 1
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 选择内容 (位置：row   id  名称)
    private var seleContentArray = [(Int, Int, String)]()
    /// 数据
    private var data = [UsersData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        users(isMore: false)
    }
    
    // MARK: - 自定义私有方法
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
                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = "员工名称"
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
                    self?.users(isMore: false)
                    tableView.mj_footer.isHidden = true
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    self?.users(isMore: true)
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
    
    deinit {
        if backBlock != nil {
            backBlock!([], [])
        }
    }
    
    /// 点亮确认按钮
    private func determineHandle() {
        determineBtn.isEnabled = seleContentArray.count > 0
        determineBtn.backgroundColor = seleContentArray.count > 0 ? UIColor(hex: "#2E4695") : UIColor(hex: "#CCCCCC")
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            seleContentArray = []
            users(isMore: false)
            determineHandle()
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
    
    // MARK: - 按钮点击
    /// 点击确定
    @objc private func determineClick() {
        if backBlock != nil {
            var idArray = [Int]()
            var contentStrArray = [String]()
            for seleContent in seleContentArray {
                idArray.append(seleContent.1)
                contentStrArray.append(seleContent.2)
            }
            backBlock!(idArray, contentStrArray)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension ProjectManageSeleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildSeleCell", for: indexPath) as! NewlyBuildSeleCell
        if isMultiple {
            var isSele = false
            for seleContent in seleContentArray {
                let index = seleContent.0
                if index == indexPath.row {
                    isSele = true
                    break
                }
            }
            cell.data = (data[indexPath.row].realname ?? "", isSele)
        } else {
            let seleIndex = seleContentArray.first?.0 ?? -1
            cell.data = (data[indexPath.row].realname ?? "", seleIndex == indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        var seleIndex = -1
        if isMultiple {
            for index in 0..<seleContentArray.count {
                let seleRow = seleContentArray[index].0
                if row == seleRow {
                    seleIndex = index
                    break
                }
            }
            if seleIndex != -1 {
                seleContentArray.remove(at: seleIndex)
            } else {
                let seleContent = (row, data[row].id, data[row].realname ?? "")
                seleContentArray.append(seleContent)
            }
            tableView.reloadRows(at: [indexPath], with: .fade)
            determineHandle()
        } else {
            var seleContent = (-1, -1, "")
            if seleContentArray.count > 0 {
                seleContent = seleContentArray.first!
            } else {
                seleContentArray.append(seleContent) // 初始化第一个数据
            }
            
            if seleContent.0 != seleIndex { // 点击过
                seleIndex = seleContent.0
            }
            if seleIndex == row { // 点击的是选中cell
                return
            } else {
                seleContent = (row, data[row].id, data[row].realname ?? "")
                seleContentArray[0] = seleContent
                tableView.reloadRows(at: [indexPath], with: .fade)
                if seleIndex != -1 {
                    tableView.reloadRows(at: [IndexPath(row: seleIndex, section: 0)], with: .fade)
                }
                determineHandle()
            }
        }
    }
}

extension ProjectManageSeleController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
