//
//  CustomerEditController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户编辑 控制器

import UIKit

class CustomerEditController: UIViewController {

    /// 主要显示数据的tableview
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "客户编辑"
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // 主要显示数据的tableView
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.register(CustomerEditDetailsCell.self, forCellReuseIdentifier: "CustomerEditDetailsCell")
                tableView.register(CustomerEditProjectCell.self, forCellReuseIdentifier: "CustomerEditProjectCell")
                tableView.register(CustomerEditVisitorCell.self, forCellReuseIdentifier: "CustomerEditVisitorCell")
            })
        
        _ = UIView().taxi.adhere(toSuperView: view) // 遮挡tableview底部 -> 数据大于一页时 会出现在 安全区
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(SafeH)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
            })
    }
    
    // MARK: - 按钮点击
    /// 点击添加拜访人
    @objc private func addVisitorClick() {
        
    }

}

extension CustomerEditController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if section == 0 {
            if row == 0 { // 客户详情
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerEditDetailsCell", for: indexPath) as! CustomerEditDetailsCell
                return cell
            } else { // 在线项目
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerEditProjectCell", for: indexPath) as! CustomerEditProjectCell
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerEditVisitorCell", for: indexPath) as! CustomerEditVisitorCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        } else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 30))
            headerView.backgroundColor = .white
            _ = UILabel().taxi.adhere(toSuperView: headerView)
                .taxi.layout(snapKitMaker: { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(15)
                })
                .taxi.config({ (label) in
                    label.text = "拜访人："
                    label.font = UIFont.medium(size: 12)
                    label.textColor = UIColor(hex: "#999999")
                })
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
            footerView.backgroundColor = .white
            _ = UIButton().taxi.adhere(toSuperView: footerView) // 添加拜访人按钮
                .taxi.layout(snapKitMaker: { (make) in
                    make.edges.equalToSuperview()
                })
                .taxi.config({ (btn) in
                    btn.setTitle(" 添加拜访人", for: .normal)
                    btn.titleLabel?.font = UIFont.medium(size: 14)
                    btn.setImage(UIImage(named: "add"), for: .normal)
                    btn.setImage(UIImage(named: "add"), for: .highlighted)
                    btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                    btn.addTarget(self, action: #selector(addVisitorClick), for: .touchUpInside)
                })
            
            for index in 0..<2 {
                _ = UIView().taxi.adhere(toSuperView: footerView) // 分割线
                    .taxi.layout(snapKitMaker: { (make) in
                        make.left.equalToSuperview().offset(15)
                        make.right.equalToSuperview()
                        make.height.equalTo(1)
                        if index == 0 {
                            make.top.equalToSuperview()
                        } else {
                            make.bottom.equalToSuperview()
                        }
                    })
                    .taxi.config({ (view) in
                        view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                    })
            }
            return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        } else {
            return 40
        }
    }
    
}
