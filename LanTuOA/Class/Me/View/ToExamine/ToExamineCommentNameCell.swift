//
//  ToExamineCommentNameCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/23.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批详情评论名称  cell

import UIKit
import SnapKit

class ToExamineCommentNameCell: UITableViewCell {

    /// 数据
    var data: NotifyCheckCommentListData? {
        didSet {
            if let data = data {
                nameLabel.text = data.userName ?? " "
                timeLabel.text = Date(timeIntervalSince1970: TimeInterval(data.createdTime)).getCommentTimeString()
                let text = data.text ?? ""
                if text.count == 0 {
                    nameConstraint.activate()
                    commentConstraint.deactivate()
                } else {
                    nameConstraint.deactivate()
                    commentConstraint.activate()
                }
                commentLabel.text = text
            }
        }
    }
    
    /// 名称
    private var nameLabel: UILabel!
    /// 时间
    private var timeLabel: UILabel!
    /// 评论内容
    private var commentLabel: YYLabel!
    
    /// 名称约束
    private var nameConstraint: Constraint!
    /// 名称约束
    private var commentConstraint: Constraint!
    
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
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 圆点
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(24)
                make.width.height.equalTo(8)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                nameConstraint = make.bottom.equalToSuperview().offset(-10).constraint
                make.left.equalToSuperview().offset(33)
                make.top.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                nameConstraint.deactivate()
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 18)
            })
        
        timeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(nameLabel.snp.right).offset(5)
                make.bottom.equalTo(nameLabel)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
        
        commentLabel = YYLabel().taxi.adhere(toSuperView: contentView) // 评论内容
            .taxi.layout(snapKitMaker: { (make) in
                commentConstraint = make.bottom.equalToSuperview().offset(-10).constraint
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.right.equalToSuperview().offset(-15)
                make.left.equalToSuperview().offset(33)
            })
            .taxi.config({ (label) in
                commentConstraint.activate()
                label.font = UIFont.systemFont(ofSize: 14)
                label.textParser = LPPZSendContentTextParser()
            })
    }
}
