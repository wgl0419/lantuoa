//
//  VisitDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/2.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访详情  控制器

import UIKit
import MBProgressHUD

class VisitDetailsController: UIViewController {

    
    /// 拜访数据
    var visitListData: VisitListData!
    /// 拜访id
    var visitListId: Int!
    
    /// tableview
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        if visitListId != nil {
            visitDetail()
        }
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
    
    // MARK: - Api
    /// 项目详情
    private func visitDetail() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.visitDetail(visitListId), t: VisitDetailModel.self, successHandle: { (result) in
            self.visitListData = result.data
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
}

extension VisitDetailsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailsHeaderCell", for: indexPath) as! VisitDetailsHeaderCell
            cell.data = visitListData
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailsCell", for: indexPath) as! VisitDetailsCell
            let type: VisitDetailsCell.visitType = section == 1 ? .details : section == 2 ? .content : .result
            cell.visitListData = (visitListData, type)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < 2 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
            footerView.backgroundColor = UIColor(hex: "#F3F3F3")
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 2 {
            return 10
        } else {
            return 0
        }
    }
}
