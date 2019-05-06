//
//  VisitDetailsHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/3.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访详情顶部 cell

import UIKit

class VisitDetailsHeaderCell: UITableViewCell {

    /// 数据
    var data: VisitListData? {
        didSet {
            if let data = data {
                projectNameLabel.text = data.projectName
                customerNameLabel.text = data.customerName
                projectAddressLabel.text = data.projectAddress
            }
        }
    }
    
    /// 拜访项目名称
    private var projectNameLabel: UILabel!
    /// 客户名称
    private var customerNameLabel: UILabel!
    /// 项目地址
    private var projectAddressLabel: UILabel!
    
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
        
        projectNameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 24)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 项目名称前的橙色块
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(projectNameLabel)
                make.left.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#FF7744")
            })
        
        let customer = UILabel().taxi.adhere(toSuperView: contentView) // “客户”
            .taxi.layout { (make) in
                make.top.equalTo(projectNameLabel.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "客户："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        customerNameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 客户名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(customer.snp.bottom)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        let projectAddress = UILabel().taxi.adhere(toSuperView: contentView) // “项目地址”
            .taxi.layout { (make) in
                make.top.equalTo(customerNameLabel.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "项目地址："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        projectAddressLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目地址
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalTo(projectAddress.snp.bottom)
                make.bottom.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
    }
}
