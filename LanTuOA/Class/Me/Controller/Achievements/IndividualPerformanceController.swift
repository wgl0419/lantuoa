//
//  IndividualPerformanceController.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh
class IndividualPerformanceController: UIViewController {
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day ,.hour,.minute],   from: Date())
    private var tableView: UITableView!
    /// 数据
    private var data = [NewPerformUnderData]()
    private var data1 = [NewPerformDetailModel]()
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 页码
    private var page = 1
    /// 搜索数据
    private var searchdata = [NewPerformUnderData]()
    private var isSeaech = 1
    private var headView: NewAchievementsHeadView!
    var id : Int!
    var month : Int!
    var titStr: String!
    var year : String!
    ///返回去改变月份
    var monthBack:((Int) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titStr
        initSubViews()
    }

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = kMainBackColor
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.bottom.right.equalToSuperview()
                //                make.top.equalTo(view.snp.bottom).offset(0)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.performUnder(id: self!.id, date: self!.month)
                })
                tableView.register(NewAchievementsListCell.self, forCellReuseIdentifier: "NewAchievementsListCell")
            })
        headView = NewAchievementsHeadView()
        tableView.tableHeaderView = headView
        headView.placeholder = "搜索名字"
        headView.timeDate = "\(year.prefix(4))年-\(year.suffix(2))月"
        headView.backDate = {[weak self] date ,years, monthsString in
            self!.year = String(format: "%02ld-%02ld",Int(years)!, Int(monthsString)!)
            self!.performUnder(id:self!.id,date: date)
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
        self.performUnder(id:id,date: month)
        let str = "暂无绩效！"
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: "noneData2")
    }
    
    // MARK: - Api
    private func performUnder(id:Int,date:Int) {
        MBProgressHUD.showWait("")
        _ =  APIService.shared.getData(.IndividualNewPerformUnder(id,date), t: NewPerformUnderModel.self, successHandle: { (result) in
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
    /// 绩效查询-详情-月份绩效
    private func performDetail(setion: Int, row: Int) {
        MBProgressHUD.showWait("")
        let sub = year.prefix(4)
        let str = year.suffix(2)
        _ = APIService.shared.getData(.performDetail(id, nil,year ), t: NewPerformDetailModel.self, successHandle: { (result) in
            let showView = AchievementsDetailsEjectView(year: String(sub), month: String(str),name:self.data[row].name!, data: result.data)
            showView.show()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }

}

extension IndividualPerformanceController: UITableViewDelegate, UITableViewDataSource {
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
         self.performDetail(setion: indexPath.section, row: indexPath.row)
    }
    
}

