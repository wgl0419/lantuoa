//
//  WrokHomeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/15.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作组  首页列表 cell

import UIKit

class WrokHomeCell: UITableViewCell {
    
    /// 数据
    var data: WorkGroupListData? {
        didSet {
            if let data = data {
//                ImageView.image = UIImage(named: "")
                nameLabel.text = data.name
                projectLabel.text = data.projectName
                memberLabel.text = data.members
            }
        }
    }

    /// 图标
    private var ImageView: UIImageView!
    /// 名称
    private var nameLabel: UILabel!
    /// 项目
    private var projectLabel: UILabel!
    /// 成员
    private var memberLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        ImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
                make.width.height.equalTo(40)
            })
            .taxi.config({ (imageView) in
                imageView.layer.cornerRadius = 20
                imageView.layer.masksToBounds = true
                imageView.backgroundColor = UIColor(hex: "#E0E0E0")
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(ImageView)
                make.right.equalToSuperview().offset(-5)
                make.left.equalTo(ImageView.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.text = "1号小分队"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        let project = UILabel().taxi.adhere(toSuperView: contentView) // "项目"
            .taxi.layout { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(3)
                make.left.equalTo(nameLabel)
        }
            .taxi.config { (label) in
                label.text = "项目："
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#999999")
        }
        
        projectLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目
            .taxi.layout(snapKitMaker: { (make) in
                make.right.lessThanOrEqualToSuperview()
                make.left.equalTo(project.snp.right)
                make.top.equalTo(project)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 10)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
        
        let member = UILabel().taxi.adhere(toSuperView: contentView) // ”成员“
            .taxi.layout { (make) in
                make.top.equalTo(project.snp.bottom).offset(3)
                make.left.equalTo(nameLabel)
        }
            .taxi.config { (label) in
                label.text = "成员："
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#999999")
        }
        
        memberLabel = UILabel().taxi.adhere(toSuperView: contentView) // 成员
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview().offset(-15)
                make.right.lessThanOrEqualToSuperview()
                make.left.equalTo(member.snp.right)
                make.top.equalTo(member)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 10)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
    }
}
