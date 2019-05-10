//
//  AchievementsListController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  绩效查询  控制器

import UIKit
import MBProgressHUD

class AchievementsListController: UIViewController {

    /// 搜索框
    private var searchBar: UISearchBar!
    /// tableview
    private var tableView: UITableView!
    
    /// 数据
    private var data = [PerformUnderData]()
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 页码
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        performUnder()
    }
    

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "绩效查询"
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
                tableView.register(AchievementsListCell.self, forCellReuseIdentifier: "AchievementsListCell")
            })
        
        let str = "暂无绩效！"
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: "noneData2")
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            performUnder()
        }
    }
    
    // MARK: - Api
    private func performUnder() {
        MBProgressHUD.showWait("")
        _ =  APIService.shared.getData(.performUnder(searchBar.text ?? ""), t: PerformUnderModel.self, successHandle: { (result) in
            self.data = result.data
            self.tableView.reloadData()
            self.tableView.isNoData = self.data.count == 0
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
}


extension AchievementsListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsListCell", for: indexPath) as! AchievementsListCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = AchievementsDetailsController()
        vc.performUnderData = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension AchievementsListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
