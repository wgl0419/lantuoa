//
//  CheckReportListViewController.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
class CheckReportListViewController: UIViewController {

    var tableView: UITableView!
    private var data = [NotifyCheckListData]()
    private var numberData = unreadValueModel()
    private var isNotRead = 0
    private var page = 1
    let headView = CheckReportListView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        CheckReportList(isMore: false, notRead: isNotRead,processId: 0,commitUser: [],startTime: 0,endTime: 0)
        CheckListNumberUnread()

    }
    
    // MAKR: - 自定义自有方法
    /// 设置导航栏
    private func setNav() {
        title = "查看汇报"
        view.backgroundColor = .white
        let nav = navigationController as! MainNavigationController
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "筛选",
                                                            titleColor: .white,
                                                            titleFont: UIFont.medium(size: 15),
                                                            titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                            target: self,
                                                            action: #selector(rightClick))
    }
    
    /// 初始化子控件
    private func initSubViews() {
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout { (make) in
                make.top.height.width.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            .taxi.config { (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 180
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(CheckReportListCell.self, forCellReuseIdentifier: "CheckReportListCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.CheckReportList(isMore: false,notRead: self!.isNotRead,processId: 0,commitUser: [],startTime: 0,endTime: 0)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.CheckReportList(isMore: true,notRead: self!.isNotRead,processId: 0,commitUser: [],startTime: 0,endTime: 0)
                })
                tableView.tableHeaderView = headView
                
                headView.readBlck = {[weak self] number in
                    self!.isNotRead = number
                    self!.CheckReportList(isMore: false, notRead: self!.isNotRead,processId: 0,commitUser: [],startTime: 0,endTime: 0)
                }
        }
        
        let str = "暂无审批！"
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: "noneData1")
    }
    
    /// 点击筛选
    @objc func rightClick(){
        let vc = ReportScreeningViewController()
        vc.screeningBlack = { [weak self] processId, commitUser, startTime, endTime, notRead in
            self!.isNotRead = notRead
            self!.CheckReportList(isMore: false, notRead: self!.isNotRead,processId: processId,commitUser: commitUser,startTime: startTime,endTime: endTime)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Api
    /// 获取汇报数据
    ///
    /// - Parameters:
    ///   - status: 状态 1或不传:未处理   2:已处理
    ///   - isMore: 是否加载更多
    private func CheckReportList(isMore: Bool,notRead: Int, processId:Int,commitUser:Array<Any>,startTime:Int,endTime:Int) {
        MBProgressHUD.showWait("")
        let oldPage = page
        let newPage = isMore ? oldPage + 1 : 1
        _ = APIService.shared.getData(.WorkReporCheckList(newPage,10,notRead,processId,commitUser as! [String],startTime,endTime), t: NotifyCheckListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            let data = result.data
            if isMore {
                for model in data {
                    self.data.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.data = data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            self.tableView.mj_footer.resetNoMoreData()
            self.tableView.isNoData = self.data.count == 0
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
    
    
    // MARK: - Api
    ///获取未读数量
    func CheckListNumberUnread(){
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.WorkReporCheckListNumberUnread, t: unreadValueModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.numberData = result
            self.headView.data = self.numberData
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    // MARK: - Api
    ///设置已读
    func CheckListHaveRead(index:Int){
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.WorkReporCheckListHaveRead(index), t: unreadValueModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.CheckListNumberUnread()//重新获取未读数量
            self.tableView.reloadData()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "设置失败")
        })
        
    }

}
extension CheckReportListViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckReportListCell", for: indexPath) as! CheckReportListCell
        cell.data = (data[indexPath.row], false)
        cell.haveReadBlock = {[weak self] index in
            self!.CheckListHaveRead(index: index!)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CheckReportDetailsViewController()
        vc.checkListId = data[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}
