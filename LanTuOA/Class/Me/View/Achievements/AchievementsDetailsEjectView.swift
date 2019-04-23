//
//  AchievementsDetailsEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  绩效详情  弹出框

import UIKit

class AchievementsDetailsEjectView: UIView {
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// tableview
    private var tableView: UITableView!
    
    /// 数据
    private var data = [PerformDetailData]()
    
    convenience init(year: String, month: Int, data: [PerformDetailData]) {
        self.init(frame: ScreenBounds)
        self.data = data
        let titleStr = year + "年\(month)月绩效"
        initSubViews(title: titleStr)
    }
    
    // MAKR: - 自定义公有方法
    /// 弹出
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(hex: "#000000", alpha: 0.5)
        }
    }
    
    /// 隐藏
    @objc func hidden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = .clear
            self.removeAllSubviews()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews(title: String) {
        whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(300)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (label) in
                label.textAlignment = .center
                label.textColor = UIColor(hex: "#2E4695")
                label.backgroundColor = UIColor(hex: "#F1F1F1")
                label.font = UIFont.boldSystemFont(ofSize: 16)
                
                let attriMuStr = NSMutableAttributedString(string: title)
                attriMuStr.changeColor(str: "绩效", color: blackColor)
                label.attributedText = attriMuStr
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: whiteView) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.lessThanOrEqualTo(200)
                make.height.equalTo(100)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.bounces = false
                tableView.estimatedRowHeight = 50
                tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                tableView.register(AchievementsDetailsEjectCell.self, forCellReuseIdentifier: "AchievementsDetailsEjectCell")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 关闭按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(tableView.snp.bottom)
                make.height.equalTo(50)
            })
            .taxi.config({ (btn) in
                btn.setTitle("关闭", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(tableView.snp.bottom)
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        layoutIfNeeded()
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(tableView.contentSize.height)
        }
    }
    
    // MARK: - 按钮点击
    @objc private func cancelClick() {
        hidden()
    }
}


extension AchievementsDetailsEjectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsDetailsEjectCell", for: indexPath) as! AchievementsDetailsEjectCell
        if row == 0 {
            cell.isTitle = true
        } else {
            cell.data = (row, data[row - 1])
        }
        return cell
    }
    
    
}
