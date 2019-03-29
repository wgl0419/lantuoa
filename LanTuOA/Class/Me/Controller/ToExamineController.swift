//
//  ToExamineController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审核 控制器

import UIKit

class ToExamineController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "我的审核"
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // 用于显示数据的tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 180
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(ToExamineCell.self, forCellReuseIdentifier: "ToExamineCell")
            })
    }
}

extension ToExamineController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineCell", for: indexPath) as! ToExamineCell
        cell.agreeBlock = {
            
        }
        cell.refuseBlock = {
            let view = SeleVisitModelView(title: "选择行业类型", content: ["已存在项目/客户/拜访人", "名字不合理"])
            view.didBlock = { [weak self] (seleIndex) in
                self?.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            view.show()
        }
        return cell
    }
    
    
}
