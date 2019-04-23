//
//  AchievementsDetailsHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  绩效详情

import UIKit

class AchievementsDetailsHeaderCell: UITableViewCell {

    /// 数据
    var data: PerformUnderData! {
        didSet {
            nameLabel.text = data.realname
            phoneLabel.text = data.phone
            
            let departmentStr = data.departmentName ?? ""
            departmentLabel.text = departmentStr.count > 0 ? departmentStr : " "
        }
    }
    
    /// 名称
    private var nameLabel: UILabel!
    /// 部门
    private var departmentLabel: UILabel!
    /// 电话号码
    private var phoneLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(20)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 18)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 蓝色标价线
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(nameLabel)
                make.left.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        let department = UILabel().taxi.adhere(toSuperView: contentView) // "所属部门"
            .taxi.layout { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "所属部门："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        departmentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 所属部门
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.left.equalTo(department.snp.right)
                make.top.equalTo(department)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
        
        let phone = UILabel().taxi.adhere(toSuperView: contentView) // ”手机号码“
            .taxi.layout { (make) in
                make.top.equalTo(departmentLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "手机号码："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        phoneLabel = UILabel().taxi.adhere(toSuperView: contentView) // 手机号码
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(phone.snp.right)
                make.top.equalTo(phone)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 灰色条
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(phone.snp.bottom).offset(15)
                make.left.right.equalToSuperview()
                make.height.equalTo(10)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
        
        _ = UILabel().taxi.adhere(toSuperView: contentView) // “绩效”
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(phone.snp.bottom).offset(40)
                make.bottom.equalToSuperview().offset(-15)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "绩效："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
    }
}
