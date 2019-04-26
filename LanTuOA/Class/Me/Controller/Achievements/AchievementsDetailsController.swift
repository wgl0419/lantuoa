//
//  AchievementsDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  绩效详情

import UIKit
import MBProgressHUD

class AchievementsDetailsController: UIViewController {

    /// 用户id
    var performUnderData: PerformUnderData!
    
    /// tableview
    private var tableView: UITableView!
    
    /// 业绩详情
    private var data = [PerformListData]()
    /// 展开数据
    private var openArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        performList()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "绩效"
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.register(AchievementsDetailsHeaderCell.self, forCellReuseIdentifier: "AchievementsDetailsHeaderCell")
                tableView.register(ContractPerformanceHeaderCell.self, forCellReuseIdentifier: "ContractPerformanceHeaderCell")
                tableView.register(AchievementsDetailsCell.self, forCellReuseIdentifier: "AchievementsDetailsCell")
            })
    }
    
    // MARK: - Api
    /// 业绩列表
    private func performList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.performList(2, performUnderData.id, nil, nil), t: PerformListModel.self, successHandle: { (result) in
            self.data = result.data
            for _ in result.data {
                self.openArray.append(false)
            }
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取业绩列表失败")
        })
    }
    
    /// 查询绩效-详情-月份绩效
    private func performDetail(setion: Int, row: Int) {
        MBProgressHUD.showWait("")
        let month = data[setion].children[row].title ?? ""
        _ = APIService.shared.getData(.performDetail(performUnderData.id, nil, month), t: PerformDetailModel.self, successHandle: { (result) in
            let showView = AchievementsDetailsEjectView(year: self.data[setion].title ?? "", month: row + 1, data: result.data)
            showView.show()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
}

extension AchievementsDetailsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count * 2 + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if (section - 1) % 2 == 0 { // 标题cell -> 年份
            return 1
        } else {
            let trueSection = section / 2 - 1
            return openArray[trueSection] ? data[trueSection].children.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsDetailsHeaderCell", for: indexPath) as! AchievementsDetailsHeaderCell
            cell.data = performUnderData
            return cell
        } else if (section - 1) % 2 == 0 { // 标题cell -> 年份
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContractPerformanceHeaderCell", for: indexPath) as! ContractPerformanceHeaderCell
            let trueSection = (section - 1) / 2
            cell.data = (data[trueSection].title ?? "", data[trueSection].money, openArray[trueSection])
            return cell
        } else { // 月份数据
            let row = indexPath.row
            let trueSection = section / 2 - 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsDetailsCell", for: indexPath) as! AchievementsDetailsCell
            cell.data = (data[trueSection].title ?? "", row + 1, data[trueSection].children[row].money)
            cell.detailsBlock = { [weak self] in
                self?.performDetail(setion: trueSection, row: row)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && (indexPath.section - 1) % 2 == 0 {
            let trueSection = indexPath.section / 2
            let cell = tableView.cellForRow(at: indexPath) as! ContractPerformanceHeaderCell
            cell.changeOpen()
            openArray[trueSection] = !openArray[trueSection]
            tableView.reloadSections(IndexSet(integer: indexPath.section + 1), with: .fade)
        }
    }
    
}
