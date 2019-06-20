//
//  HomePageController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  首页 控制器

import UIKit
import MJRefresh
import MBProgressHUD
import Alamofire

class HomePageController: UIViewController {

    /// 主要tableview
    private var tableView: UITableView!
    
    
    /// 项目数据
    private var data = [ProjectListStatisticsData]()
    /// 首页统计数据
    private var startupSumData: StartupSumData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        getData()
        loginUser()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        navigationItem.title = "蓝图OA"
        let nav = navigationController as! MainNavigationController
        nav.setNavConfigure(type: .dark, color: kMainColor, isShadow: false)
        nav.backBtn.isHidden = false
    }
    
    /// 获取数据
    private func getData() {
        if AppDelegate.netWorkState == .notReachable {
            if data.count == 0 {
                view.noDataImageView?.image = UIImage(named: "notReachable")
                let str = "网络异常！请检查您的网络状态"
                let attriMuStr = NSMutableAttributedString(string: str)
                attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
                attriMuStr.changeColor(str: str, color: kMainSelectedColor)
                view.noDataLabel?.attributedText = attriMuStr
                view.isNoData = true
                return
            }
        }
        projectList()
        startupSum()
        notifyNumber()
    }
    
    /// 设置重新加载
    private func setReload() {
        if data.count == 0 {
            view.noDataImageView?.image = UIImage(named: "lostData")
            view.isNoData = true
            
            let str = "数据加载失败！点击重新加载"
            let attriMuStr = NSMutableAttributedString(string: str)
            attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
            attriMuStr.changeColor(str: str, color: kMainSelectedColor)
            attriMuStr.yy_setTextHighlight(NSRange(location: 7, length: 6),
                                           color: UIColor(hex: "#6B83D1"),
                                           backgroundColor: .clear) { (_, text, _, _) in
                                            self.getData()
            }
            view.noDataLabel?.attributedText = attriMuStr
        }
    }
    
    /// 添加无数据view
    private func addNoDataView() {
        self.tableView.tableFooterView = UIView()
        if data.count == 0 {
            view.layoutIfNeeded()
            let height = ScreenHeight - tableView.contentSize.height - NavigationH - TabbarH
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: height))
            footerView.backgroundColor = .white
            footerView.noDataImageView?.image = UIImage(named: "noneData")
            footerView.isNoData = true
            
            let str = "您目前没有跟进的项目！"
            let attriMuStr = NSMutableAttributedString(string: str)
            attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
            attriMuStr.changeColor(str: str, color: kMainSelectedColor)
            footerView.noDataLabel?.attributedText = attriMuStr
            self.tableView.tableFooterView = footerView
        }
    }
    
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = kMainBackColor
        
        tableView = UITableView(frame: .zero, style: .grouped)
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = kMainBackColor
                tableView.separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
                tableView.register(HomePageVisitCell.self, forCellReuseIdentifier: "HomePageVisitCell")
                tableView.register(HomePageNoticeCell.self, forCellReuseIdentifier: "HomePageNoticeCell")
                tableView.register(CostomerDetailsProjectCell.self, forCellReuseIdentifier: "CostomerDetailsProjectCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.projectList()
                    self?.startupSum()
                })
            })
    }
    
    // MARK: - Api
    /// 项目信息列表
    private func projectList() {
        MBProgressHUD.showWait("")
        
        _ = APIService.shared.getData(.projectList("", "", 1, 9999), t: ProjectListModel.self, successHandle: { (result) in
            self.data = result.data
            self.view.isNoData = false
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.addNoDataView()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            self.setReload()
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取我的项目失败")
        })
    }
    
    /// 获取个人信息 -> 更新权限
    private func loginUser() {
        _ = APIService.shared.getData(.loginUser, t: LoginUserModel.self, successHandle: { (result) in
            Jurisdiction.share.setJurisdiction(data: result.data?.privilegeList ?? [])
            UserInfo.share.setUserName(result.data?.realname ?? "")
        }, errorHandle: nil)
    }
    
    /// 首页统计
    private func startupSum() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.startupSum, t: StartupSumModel.self, successHandle: { (result) in
            self.startupSumData = result.data
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取本月统计失败")
        })
    }
    
    /// 未读信息数
    private func notifyNumber() {
        _ = APIService.shared.getData(.notifyNumber, t: NotifyNumberModel.self, successHandle: { (result) in
            let checkNum = result.data?.checkNum ?? 0
            let notReadNum = result.data?.notReadNum ?? 0
            self.tabBarController?.tabBar.itemStatus = checkNum > 0
            if checkNum > 0 {
                self.tabBarController?.tabBar.items?[3].badgeValue = "\(checkNum)"
            } else if notReadNum > 0 {
                self.tabBarController?.tabBar.showBadgeOnItemIndex(index: 3)
            }
        }, errorHandle: nil)
    }
}

extension HomePageController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count == 0 && startupSumData == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageVisitCell", for: indexPath) as! HomePageVisitCell
            cell.data = startupSumData
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostomerDetailsProjectCell", for: indexPath) as! CostomerDetailsProjectCell
            cell.data = data[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 54))
        let header = HomePageHeaderView(frame: CGRect(x: 0, y: 10, width: ScreenWidth, height: 44))
        var logoName = "visit"
        var attriMuStr = NSMutableAttributedString(string: "本月统计")
        attriMuStr.changeColor(str: "我的项目", color: UIColor(hex: "#2E4695"))
        if section == 1 {
            logoName = "project"
            attriMuStr = NSMutableAttributedString(string: "我的项目")
            attriMuStr.changeColor(str: "我的项目", color: UIColor(hex: "#2E4695"))
        }
        header.setContent(logoName: logoName, attriMuStr: attriMuStr)
        headerView.addSubview(header)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let vc = ProjectDetailsController()
            vc.lockState = 1
            vc.projectData = data[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
