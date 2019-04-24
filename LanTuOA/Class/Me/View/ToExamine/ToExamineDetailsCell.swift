//
//  ToExamineDetailsCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批详情  cell

import UIKit

class ToExamineDetailsCell: UITableViewCell {
    
    /// 数据 (审批人姓名;时间戳;status;位置: -1：顶部  0：中间   1：底部)
    var data: (String, Int, Int, Int)? {
        didSet {
            if let data = data {
                nameLabel.text = data.0
                statusLabel.text = data.2 == 0 ? "(发起申请)" : data.2 == 1 ? "(审批中)" : data.2 == 2 ? "(同意)" : "(拒绝)"
                if data.3 == -1 { // 都写  防止复用
                    topLineView.isHidden = true
                    bottomLineView.isHidden = false
                } else if data.3 == 0 {
                    topLineView.isHidden = false
                    bottomLineView.isHidden = false
                } else {
                    topLineView.isHidden = false
                    bottomLineView.isHidden = true
                }
                
                if data.1 != 0 {
                    timeLabel.text = Date(timeIntervalSince1970: TimeInterval(data.1)).getCommentTimeString()
                } else {
                    timeLabel.text = ""
                }
            }
        }
    }
    
    
    /// 审批人名称
    private var nameLabel: UILabel!
    /// 状态
    private var statusLabel: UILabel!
    /// 时间
    private var timeLabel: UILabel!
    /// 顶部线
    private var topLineView: UIView!
    /// 底部线
    private var bottomLineView: UIView!
    

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
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(18)
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-18)
            })
            .taxi.config({ (label) in
                label.text = "测试"
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 18)
            })
        
        statusLabel = UILabel().taxi.adhere(toSuperView: contentView) // 状态
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(nameLabel)
                make.left.equalTo(nameLabel.snp.right).offset(5)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 10)
            })
        
        timeLabel = UILabel().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(nameLabel)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#999999")
            })
        
        topLineView = UIView().taxi.adhere(toSuperView: contentView) // 顶部线
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(nameLabel.snp.top).offset(-3)
                make.left.equalTo(nameLabel).offset(8)
                make.top.equalToSuperview()
                make.width.equalTo(3)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        bottomLineView = UIView().taxi.adhere(toSuperView: contentView) // 底部线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(3)
                make.left.equalTo(nameLabel).offset(8)
                make.bottom.equalToSuperview()
                make.width.equalTo(3)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
    }
}
