//
//  WrokHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作 首页 控制器

import UIKit

class WrokHomeController: UIViewController {

    /// 主要tableview
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        navigationItem.title = "工作组"
        let nav = navigationController as! MainNavigationController
        nav.backBtn.isHidden = false
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增工作组",
                                                            titleColor: .white,
                                                            titleFont: UIFont.medium(size: 15),
                                                            titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                            target: self,
                                                            action: #selector(rightClick))
    }
    
    /// 初始化子控件
    private func initSubViews() {
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // 主要tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.register(WrokHomeCell.self, forCellReuseIdentifier: "WrokHomeCell")
                tableView.separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击右按钮
    @objc private func rightClick() {
        
    }
}

extension WrokHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WrokHomeCell", for: indexPath) as! WrokHomeCell
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
