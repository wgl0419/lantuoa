//
//  ContractPerformanceCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  业绩详情  cell

import UIKit

class ContractPerformanceCell: UITableViewCell {

    /// 数据 (年份  月份  金额)
    var data: (String, Int, Float)! {
        didSet {
            yearLabel.text = String(format: "%@年%d月", data.0, data.1)
            moneyLabel.text = data.2.getAllMoneyStr()
        }
    }
    
    /// 年份
    private var yearLabel: UILabel!
    /// 金额
    private var moneyLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        yearLabel = UILabel().taxi.adhere(toSuperView: contentView) // 年份
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(40)
                make.height.equalTo(25).priority(800)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        moneyLabel = UILabel().taxi.adhere(toSuperView: contentView) // 金额
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(yearLabel.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
    }
}
