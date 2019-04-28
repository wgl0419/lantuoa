//
//  AchievementsListCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  查询绩效  cell

import UIKit

class AchievementsListCell: UITableViewCell {

    /// 数据
    var data: PerformUnderData? {
        didSet {
            if let data = data {
                nameLabel.text = data.realname
                let departmentStr = data.departmentName ?? ""
                departmentLabel.text = departmentStr.count > 0 ? departmentStr : " "
                
                let attriStr = String(format: "%.2f元", data.monthPerform)
                let attriMuStr = NSMutableAttributedString(string: attriStr)
                attriMuStr.addUnderline(color: UIColor(hex: "#FF7744"), range: NSRange(location: 0, length: attriMuStr.length))
                achievementsLabel.attributedText = attriMuStr
            }
        }
    }
    
    /// 员工名称
    private var nameLabel: UILabel!
    /// 部门名称
    private var departmentLabel: UILabel!
    /// 绩效
    private var achievementsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 员工名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "员工名称"
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        let department = UILabel().taxi.adhere(toSuperView: contentView) // ”部门名称“
            .taxi.layout { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "部门名称："
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        departmentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 部门名称
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.left.equalTo(department.snp.right)
                make.top.equalTo(department)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
        
        let achievements = UILabel().taxi.adhere(toSuperView: contentView) // ”本月绩效“
            .taxi.layout { (make) in
                make.top.equalTo(departmentLabel.snp.bottom).offset(5)
                make.bottom.equalToSuperview().offset(-15)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "本月绩效："
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
        }
        
        achievementsLabel = UILabel().taxi.adhere(toSuperView: contentView) // 绩效
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(achievements.snp.right)
                make.top.equalTo(achievements)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#FF7744")
            })
    }
}
