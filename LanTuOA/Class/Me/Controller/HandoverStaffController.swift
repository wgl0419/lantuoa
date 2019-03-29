//
//  HandoverStaffController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  交接员工  控制器

import UIKit

class HandoverStaffController: UIViewController {
    
    /// tableView
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "交接员工"
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.register(HandoverStaffCell.self, forCellReuseIdentifier: "HandoverStaffCell")
                tableView.register(HandoverStaffHeaderCell.self, forCellReuseIdentifier: "HandoverStaffHeaderCell")
            })
    }
}

extension HandoverStaffController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 25))
            headerView.backgroundColor = .white
            _ = UILabel().taxi.adhere(toSuperView: headerView)
                .taxi.layout(snapKitMaker: { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(15)
                })
                .taxi.config({ (label) in
                    label.text = "交接工作："
                    label.font = UIFont.medium(size: 10)
                    label.textColor = UIColor(hex: "#999999")
                })
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 25
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HandoverStaffHeaderCell", for: indexPath) as! HandoverStaffHeaderCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HandoverStaffCell", for: indexPath) as! HandoverStaffCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = HandoverStaffSeleController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
