//
//  ApplyController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  申请 控制器

import UIKit

class ApplyController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "工作申请"
        view.backgroundColor = .white
        
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
                tableView.register(ApplyCell.self, forCellReuseIdentifier: "ApplyCell")
            })
    }
}

extension ApplyController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyCell", for: indexPath) as! ApplyCell
        return cell
    }
}
