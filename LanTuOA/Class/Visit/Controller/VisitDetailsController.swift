//
//  VisitDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/2.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访详情  控制器

import UIKit

class VisitDetailsController: UIViewController {

    
    /// 数据
    var visitListData: VisitListData!
    
    /// tableview
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "拜访详情"
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.register(VisitDetailsCell.self, forCellReuseIdentifier: "VisitDetailsCell")
                tableView.register(VisitDetailsHeaderCell.self, forCellReuseIdentifier: "VisitDetailsHeaderCell")
            })
    }
}

extension VisitDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailsHeaderCell", for: indexPath) as! VisitDetailsHeaderCell
            cell.data = visitListData
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailsCell", for: indexPath) as! VisitDetailsCell
            let type: VisitDetailsCell.visitType = row == 1 ? .details : row == 2 ? .content : .result
            cell.visitListData = (visitListData, type)
            return cell
        }
    }
    
}
