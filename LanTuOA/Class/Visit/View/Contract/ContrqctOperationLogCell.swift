//
//  ContrqctOperationLogCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ContrqctOperationLogCell: UITableViewCell {
    
    var data: OperationLogListData? {
        didSet {
            if let data = data {
//                timeLabel.text = data.operateTime
                if data.operateTime != 0 {
                    let timeStr = Date(timeIntervalSince1970: TimeInterval(data.operateTime)).yearTimeStr()
                    timeLabel.text = timeStr
                } else {
                    timeLabel.text = ""
                }
                contentLabel.text = data.operationInfo
            }
        }
    }
    
    private var timeLabel : UILabel!
    private var contentLabel : UILabel!
    
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
        timeLabel = UILabel().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.top.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-15)
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(timeLabel.snp.bottom).offset(5)
                make.left.equalTo(15)
                make.right.lessThanOrEqualToSuperview().offset(-15)
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

