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
        
        projectLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(nameLabel)
                make.right.equalToSuperview().offset(-5)
                make.top.equalTo(nameLabel.snp.bottom).offset(3)
            })
            .taxi.config({ (label) in
                label.text = "项目：南宁出租车后车门广告"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
        
        memberLabel = UILabel().taxi.adhere(toSuperView: contentView) // 成员
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(nameLabel)
                make.right.equalToSuperview().offset(-5)
                make.bottom.equalToSuperview().offset(-15)
                make.top.equalTo(projectLabel.snp.bottom).offset(3)
            })
            .taxi.config({ (label) in
                label.text = "成员：周天华、覃甲"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
    }
}
