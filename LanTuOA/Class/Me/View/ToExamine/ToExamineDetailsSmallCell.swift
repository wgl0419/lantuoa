//
//  ToExamineDetailsSmallCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/29.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  展开的多人会签  cell

import UIKit

class ToExamineDetailsSmallCell: UITableViewCell {

    /// 数据 (审核人数据   是否是最后一个cell  是否轮到这条数据审批)
    var data: (NotifyCheckUserListData, Bool, Bool)? {
        didSet {
            if let userData = data?.0, let isLast = data?.1, let approval = data?.2 {
                if userData.`self` == 1 {
                    nameLabel.text = "我"
                } else {
                    nameLabel.text = userData.checkUserName
                }
                // 处理状态
                if !approval {
                    statusLabel.text = "(未审批)"
                    statusLabel.textColor = blackColor
                } else {
                    let status = userData.status
                    statusLabel.text = status == 0 ? "(发起申请)" : status == 1 ? "(审批中)" : status == 2 ? "(已同意)" : "(已拒绝)"
                    statusLabel.textColor = status == 0 ? blackColor : status == 1 ? UIColor(hex: "#FF7744") : status == 2 ? UIColor(hex: "#5FB9A1") : UIColor(hex: "#FF4444")
                }
                
                if isLast {
                    statusLabel.snp.updateConstraints { (make) in
                        make.bottom.equalToSuperview().offset(-15)
                    }
                }
            }
        }
    }
    
    /// 顶部线
    private var topLineView: UIView!
    /// 名称
    private var nameLabel: UILabel!
    /// 状态
    private var statusLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusLabel.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        topLineView = UIView().taxi.adhere(toSuperView: contentView) // 顶部线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(46)
                make.top.equalToSuperview().offset(2)
                make.height.equalTo(21)
                make.width.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(topLineView.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(36)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        statusLabel = UILabel().taxi.adhere(toSuperView: contentView) // 状态
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(2)
                make.bottom.equalToSuperview().offset(-5)
                make.left.equalToSuperview().offset(36)
            })
            .taxi.config({ (label) in
                label.font = UIFont.boldSystemFont(ofSize: 10)
            })
    }
}
