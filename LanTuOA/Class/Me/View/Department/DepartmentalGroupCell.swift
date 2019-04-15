//
//  DepartmentalGroupCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/12.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  部门小组  cell

import UIKit

class DepartmentalGroupCell: UITableViewCell {

    /// 数据
    var data: DepartmentsData? {
        didSet {
            if let data = data {
                groupNameLabel.text = data.name
                numberLabel.text = "（\(data.memberNum)人）"
            }
        }
    }
    
    /// 小组名称
    private var groupNameLabel: UILabel!
    /// 人数
    private var numberLabel: UILabel!
    
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
        groupNameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 小组名称
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(50).priority(800)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        numberLabel = UILabel().taxi.adhere(toSuperView: contentView) // 人数
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(groupNameLabel.snp.right)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
            })
    }
}
