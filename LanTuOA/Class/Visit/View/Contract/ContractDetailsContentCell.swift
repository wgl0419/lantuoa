//
//  ContractDetailsContentCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  发布内容 cell

import UIKit

class ContractDetailsContentCell: UITableViewCell {
    
    /// 数据
    var data: ContractListSmallData? {
        didSet {
            if let data = data {
                titleLabel.text = (data.title ?? " ") + "："
                contentLabel.text = data.value ?? " "
            }
        }
    }

    /// 标题
    private var titleLabel: UILabel!
    /// 内容
    private var contentLabel: UILabel!
    
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
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(5)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(5)
                make.left.equalTo(titleLabel.snp.right)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-5).priority(800)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
    }
}
