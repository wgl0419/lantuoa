//
//  HomePageVisitCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  首页 拜访 cell

import UIKit

class HomePageVisitCell: UITableViewCell {
    
    /// 拜访公司数量
    private var visitCompanyLabel: UILabel!
    /// 项目
    private var projectLabel: UILabel!
    /// 拜访次数
    private var visitNumberLabel: UILabel!
    /// 拜访人数
    private var visitLabel: UILabel!

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
        visitCompanyLabel = UILabel().taxi.adhere(toSuperView: contentView) // 拜访公司
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentView).offset(38)
                make.width.equalTo(ScreenWidth / 4 - 10)
                make.left.equalTo(contentView).offset(5)
                make.bottom.equalTo(contentView).offset(-15)
            })
            .taxi.config({ (label) in
                label.text = "0"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.medium(size: 14)
            })
        
        _ = UILabel().taxi.adhere(toSuperView: contentView) // ”拜访公司“
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(visitCompanyLabel)
                make.bottom.equalTo(visitCompanyLabel.snp.top).offset(-7)
            })
            .taxi.config({ (label) in
                label.text = "拜访公司"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
        
        projectLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentView).offset(38)
                make.width.equalTo(ScreenWidth / 4 - 10)
                make.left.equalTo(visitCompanyLabel.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.text = "0"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.medium(size: 14)
            })
        
        _ = UILabel().taxi.adhere(toSuperView: contentView) // ”项目“
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(projectLabel)
                make.bottom.equalTo(projectLabel.snp.top).offset(-7)
            })
            .taxi.config({ (label) in
                label.text = "项目"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
        
        visitNumberLabel = UILabel().taxi.adhere(toSuperView: contentView) // 拜访次数
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentView).offset(38)
                make.width.equalTo(ScreenWidth / 4 - 10)
                make.left.equalTo(projectLabel.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.text = "0"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.medium(size: 14)
            })
        
        _ = UILabel().taxi.adhere(toSuperView: contentView) // ”拜访公司“
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(visitNumberLabel)
                make.bottom.equalTo(visitNumberLabel.snp.top).offset(-7)
            })
            .taxi.config({ (label) in
                label.text = "拜访公司"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
        
        visitLabel = UILabel().taxi.adhere(toSuperView: contentView) // 拜访人数
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentView).offset(38)
                make.width.equalTo(ScreenWidth / 4 - 10)
                make.left.equalTo(visitNumberLabel.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.text = "0"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.medium(size: 14)
            })
        
        _ = UILabel().taxi.adhere(toSuperView: contentView) // ”拜访人数“
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(visitLabel)
                make.bottom.equalTo(visitLabel.snp.top).offset(-7)
            })
            .taxi.config({ (label) in
                label.text = "拜访人数"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
    }
}
