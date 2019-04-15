//
//  CostomerDetailsProjectCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户详情  在线项目 cell

import UIKit

class CostomerDetailsProjectCell: UITableViewCell {

    /// 数据
    var data: ProjectListStatisticsData? {
        didSet {
            if let data = data {
                nameLabel.text = data.name ?? " "
                stateLabel.text = "最新状态：" + (data.lastVisitResult ?? "")
            }
        }
    }
    
    /// 项目名称
    private var nameLabel: UILabel!
    /// 状态
    private var stateLabel: UILabel!
    
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
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(13)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        stateLabel = UILabel().taxi.adhere(toSuperView: contentView) // 状态
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-13)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
    }
}
