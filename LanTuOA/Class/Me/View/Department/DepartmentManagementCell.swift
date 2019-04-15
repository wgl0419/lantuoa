//
//  DepartmentManagementCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  部门列表 cell

import UIKit

class DepartmentManagementCell: UITableViewCell {

    /// 数据
    var data: DepartmentsData? {
        didSet {
            if let data = data {
                nameLabel.text = data.name
                numberLabel.text = "\(data.memberNum)"
            }
        }
    }
    
    /// 部门名称
    private var nameLabel: UILabel!
    /// 部门人数
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
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 部门名称
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        let number = UILabel().taxi.adhere(toSuperView: contentView) // “部门人数”
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-15)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
            .taxi.config { (label) in
                label.text = "部门人数："
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
        }
        
        numberLabel = UILabel().taxi.adhere(toSuperView: contentView) // 部门人数
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(number.snp.right)
                make.top.equalTo(number)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
    }
}
