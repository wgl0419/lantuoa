//
//  JobHandoverController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作交接 控制器

import UIKit

class JobHandoverController: UIViewController {

    /// tableview
    private var tableVie: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "工作交接"
        view.backgroundColor = .white
        
        tableVie = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 110
                tableView.tableFooterView = UIView()
                tableView.register(JobHandoverCell.self, forCellReuseIdentifier: "JobHandoverCell")
            })
    }
}

extension JobHandoverController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobHandoverCell", for: indexPath) as! JobHandoverCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = HandoverStaffController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
