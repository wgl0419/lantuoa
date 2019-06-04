//
//  VisitHomeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/14.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访 首页 cell

import UIKit

class VisitHomeCell: UITableViewCell {

    /// 数据
    var data: VisitListData? {
        didSet {
            if let data = data {
                titleLabel.text = data.projectName
                visitNameLabel.text = data.contactInfo
                
                stateLabel.text = data.result
                if data.visitTime != 0 {
                    let timeStr = Date(timeIntervalSince1970: TimeInterval(data.visitTime)).yearTimeStr()
                    timeLabel.text = timeStr
                } else {
                    timeLabel.text = ""
                }
                
                let str = "业务人员：" + (data.createUserName ?? "")
                let attriMuStr = NSMutableAttributedString(string: str)
                attriMuStr.changeColor(str: "业务人员：", color: UIColor(hex: "#999999"))
                initiateLabel.attributedText = attriMuStr
            }
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    /// 拜访对象
    private var visitNameLabel: UILabel!
    /// 业务人员
    private var initiateLabel: UILabel!
    /// 拜访时间
    private var timeLabel: UILabel!
    /// 状态
    private var stateLabel: UILabel!
    
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
        backgroundColor = UIColor(hex: "#F3F3F3")
        
        let whiteView = UIView().taxi.adhere(toSuperView: contentView) // 白色背景
            .taxi.layout { (make) in
                make.top.equalTo(contentView).offset(8)
                make.left.equalTo(contentView).offset(15)
                make.right.equalTo(contentView).offset(-15)
                make.bottom.equalTo(contentView).offset(-8)
        }
            .taxi.config { (view) in
                view.layer.cornerRadius = 4
                view.layer.shadowOpacity = 1
                view.backgroundColor = .white
                view.layer.shadowColor = UIColor(hex: "#666666", alpha: 0.2).cgColor
                view.layer.shadowOffset = CGSize(width: 2, height: 2)
        }
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(13)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            })
        
        initiateLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 业务人员
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-15)
                make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(5)
            })
            .taxi.config({ (label) in
                label.textAlignment = .right
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 橙色线条
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(2)
                make.height.equalTo(15)
                make.left.equalTo(whiteView)
                make.centerY.equalTo(initiateLabel)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#FF7744")
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.right.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(titleLabel.snp.bottom).offset(14)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIImageView().taxi.adhere(toSuperView: whiteView) // 箭头
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "arrow")
            })
        
        let visitName = UILabel().taxi.adhere(toSuperView: whiteView) // “拜访对象”
        visitNameLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 拜访对象
        setTitle(title: visitName, content: visitNameLabel, lastLabel: titleLabel, isFirst: true)
        visitName.text = "拜访对象："
        
        let state = UILabel().taxi.adhere(toSuperView: whiteView) // “状态“
        stateLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 状态
        setTitle(title: state, content: stateLabel, lastLabel: visitNameLabel)
        state.text = "主要事宜："
        
        timeLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-13)
                make.top.equalTo(stateLabel.snp.bottom).offset(13)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - lastLabel: 跟随控件
    ///   - isFirst: 是否是第一个控件
    private func setTitle(title: UILabel, content: UILabel, lastLabel: UILabel, isFirst: Bool = false) {
        title.taxi.layout { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(lastLabel.snp.bottom).offset(isFirst ? 27 : 5)
        }
            .taxi.config { (label) in
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#2E4695")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        content.taxi.layout { (make) in
            make.top.equalTo(title)
            make.left.equalTo(title.snp.right).offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-23)
        }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}
