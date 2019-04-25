//
//  ApplyController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  申请 控制器

import UIKit
import MBProgressHUD

class ApplyController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    
    
    /// 数据
    private var data = [ProcessListData]()
    /// 展开数组
    private var openArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        processList()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        title = "工作申请"
        view.backgroundColor = .white
        let nav = navigationController as! MainNavigationController
        nav.backBtn.isHidden = false
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "申请记录",
                                                            titleColor: .white,
                                                            titleFont: UIFont.medium(size: 15),
                                                            titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                            target: self,
                                                            action: #selector(rightClick))
    }
    
    /// 初始化子控件
    private func initSubViews() {
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableView
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(ApplyListCell.self, forCellReuseIdentifier: "ApplyListCell")
            })
    }
    
    // MARK: - Api
    /// 流程列表
    private func processList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.processList(), t: ProcessListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.data = result.data
            var moreArray = [Bool]()
            for _ in result.data {
                moreArray.append(false)
            }
            self.openArray = moreArray
            self.tableView.reloadData()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击申请记录
    @objc private func rightClick() {
        let vc = ApplyHistoryController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ApplyController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyListCell", for: indexPath) as! ApplyListCell
        cell.isOpen = openArray[indexPath.section]
        cell.data = data[indexPath.section]
        cell.moreBlock = { [weak self] (isOpen) in
            self?.openArray[indexPath.section] = isOpen
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.clickBlock = { [weak self] (row) in
            let vc = FillInApplyController()
            vc.processName = self?.data[indexPath.section].list[row].name ?? ""
            vc.processId = self?.data[indexPath.section].list[row].id ?? 0
            vc.pricessType = self?.data[indexPath.section].list[row].type ?? 0
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        footerView.backgroundColor = .clear
        return footerView
    }
}
