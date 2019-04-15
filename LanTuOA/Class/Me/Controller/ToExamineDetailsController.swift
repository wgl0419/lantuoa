//
//  ToExamineDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审核详情   控制器

import UIKit
import MBProgressHUD

class ToExamineDetailsController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "审核详情"
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
            })
    }
    
    // MARK: - APi
    /// 审批详情
    private func notifyCheckDetail() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckDetail(1), t: NotifyCheckDetailModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取审批详情失败")
        })
    }
}

extension ToExamineDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
