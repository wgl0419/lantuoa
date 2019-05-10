//
//  ContractRepaymentHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  回款详情 顶部cell

import UIKit

class ContractRepaymentHeaderCell: UITableViewCell {

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
        backgroundColor = UIColor(hex: "#F3F3F3")
        let nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 摘要
            .taxi.layout { (make) in
                make.width.equalToSuperview().dividedBy(4).priority(800)
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(50).priority(800)
                make.top.bottom.equalToSuperview()
        }
            .taxi.config { (label) in
                label.text = "款项摘要"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        
        let moneyLabel = UILabel().taxi.adhere(toSuperView: contentView) // 回款
            .taxi.layout { (make) in
                make.width.equalToSuperview().dividedBy(2.5).priority(800)
                make.left.equalTo(nameLabel.snp.right).offset(5)
                make.centerY.equalToSuperview()
        }
            .taxi.config { (label) in
                label.text = "回款金额"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        
        _ = UILabel().taxi.adhere(toSuperView: contentView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(moneyLabel.snp.right).offset(5)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.text = "回款时间"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
    }
}
