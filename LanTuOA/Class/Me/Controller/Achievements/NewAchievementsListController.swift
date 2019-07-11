//
//  NewAchievementsListController.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
class NewAchievementsListController: UIViewController {
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day ,.hour,.minute],   from: Date())
    /// tableview
    private var tableView: UITableView!
    /// 数据
    private var data = [NewPerformUnderData]()
    /// 搜索数据
    private var searchdata = [NewPerformUnderData]()
    private var isSeaech = 1
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 页码
    private var page = 1
    private var headView: NewAchievementsHeadView!
    var date :String!
    var year :String!
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        date = String(format: "%02ld%02ld", self.currentDateCom.year!, self.currentDateCom.month!)
        year = String(format: "%02ld-%02ld", self.currentDateCom.year!, self.currentDateCom.month!)
        performUnder(date: Int(date)!)

    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "业绩查询"
        view.backgroundColor = kMainBackColor

        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.bottom.right.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.performUnder(date: Int(self!.date)!)
                })
                tableView.register(NewAchievementsListCell.self, forCellReuseIdentifier: "NewAchievementsListCell")
            })
        headView = NewAchievementsHeadView()
        tableView.tableHeaderView = headView
        headView.placeholder = "项目名称"
        let ye = String(format: "%02ld", self.currentDateCom.year! )
        let mo = String(format:"%02ld",self.currentDateCom.month!)
        headView.timeDate = "\(ye)年-\(mo)月"
        headView.backDate = {[weak self] date ,years,monthsString in
            self!.year = String(format: "%02ld-%02ld",Int(years)!, Int(monthsString)!)
            self!.date = String(format: "%02ld",date)
            self!.performUnder(date: Int(date))
        }
        headView.searchBlck = {[weak self] searchStr ,state in
            self!.isSeaech = state
            if state == 1 {
                self!.searchdata.removeAll()
            }
            for index in 0..<self!.data.count {
                let model = self!.data[index]
                let stringResult = model.name!.contains(searchStr)
                if stringResult {
                     self!.searchdata.append(model)
                }
                self?.tableView.reloadData()
            }
        }
        let str = "暂无业绩！"
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: "noneData2")
    }
    
    // MARK: - Api
    private func performUnder(date:Int) {
        MBProgressHUD.showWait("")
        _ =  APIService.shared.getData(.newPerformUnder(date), t: NewPerformUnderModel.self, successHandle: { (result) in
            self.data.removeAll()
            self.data = result.data
            self.headView.data = result
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.isNoData = self.data.count == 0
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
}

extension NewAchievementsListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSeaech == 0 {
            return searchdata.count
        }else{
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewAchievementsListCell", for: indexPath) as! NewAchievementsListCell
        if isSeaech == 0 {
            cell.data = searchdata[indexPath.row]
        }else{
            cell.data = data[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = IndividualPerformanceController()
        vc.id = data[indexPath.row].id
        vc.month = Int(date)
        vc.year = year
        vc.titStr = data[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
