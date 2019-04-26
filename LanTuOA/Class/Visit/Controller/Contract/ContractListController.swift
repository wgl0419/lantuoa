//
//  ContractListController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同列表    控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ContractListController: UIViewController {

    /// 搜索框
    private var searchBar: UISearchBar!
    /// tableview
    private var tableView: UITableView!
    
    
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 页码
    private var page = 1
    /// 合同数据
    private var data = [ContractListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        contractList(isMore: false)
    }
    
    // MARk: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "合同"
        view.backgroundColor = UIColor(hex: "#F3F3F3")
        
        let barView = UIView().taxi.adhere(toSuperView: view) // bar背景view
            .taxi.layout { (make) in
                make.top.left.right.equalTo(view)
            }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        searchBar = UISearchBar().taxi.adhere(toSuperView: barView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(5)
                make.left.equalTo(barView).offset(10)
                make.right.equalTo(barView).offset(-5)
                make.bottom.equalToSuperview().offset(-5)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = "项目名称/客户名称"
                searchBar.returnKeyType = .done
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.bottom.right.equalToSuperview()
                make.top.equalTo(barView.snp.bottom).offset(10)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(ContractListCell.self, forCellReuseIdentifier: "ContractListCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.contractList(isMore: false)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.contractList(isMore: true)
                })
            })
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            contractList(isMore: false)
        }
    }
    
    // MARK: - Api
    /// 历史合同
    private func contractList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.contractList(searchBar.text ?? "", nil, nil, nil, newPage, 10), t: ContractListModel.self, successHandle: { (result) in
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
            if result.data.count == 0 {
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
            MBProgressHUD.showError(error ?? "获取历史合同失败")
        })
    }
}

extension ContractListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContractListCell", for: indexPath) as! ContractListCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContractDetailsController()
        vc.contractListData = data[indexPath.row]
        vc.changeBlock = { [weak self] in
            self?.contractList(isMore: false)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ContractListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
