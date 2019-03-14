//
//  VisitHomeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/14.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访 首页 cell

import UIKit

class VisitHomeCell: UITableViewCell {

    
    /// 标题
    private var titleLabel: UILabel!
    /// 拜访人
    private var visitNameLabel: UILabel!
    /// 发起人
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
                make.top.equalTo(whiteView).offset(13)
                make.left.equalTo(whiteView).offset(15)
                make.right.equalTo(whiteView).offset(-15)
            })
            .taxi.config({ (label) in
                label.text = "火力全开世界巡回演唱会"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 蓝色线条
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(2)
                make.height.equalTo(15)
                make.left.equalTo(whiteView)
                make.centerY.equalTo(titleLabel)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        _ = UIImageView().taxi.adhere(toSuperView: whiteView) // 箭头
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(4)
                make.height.equalTo(8)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (imageView) in
                imageView.backgroundColor = .gray
            })
        
        let visitName = UILabel().taxi.adhere(toSuperView: whiteView) // “拜访人”
        visitNameLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 拜访人
        setTitle(title: visitName, content: visitNameLabel, lastLabel: titleLabel)
        visitName.text = "拜访人："
        
        let initiate = UILabel().taxi.adhere(toSuperView: whiteView) // "发起人"
        initiateLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 发起人
        setTitle(title: initiate, content: initiateLabel, lastLabel: visitName)
        initiate.text = "发起人："
        
        let time = UILabel().taxi.adhere(toSuperView: whiteView) // “时间”
        timeLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 时间
        setTitle(title: time, content: timeLabel, lastLabel: initiate)
        time.text = "拜访时间："
        
        let state = UILabel().taxi.adhere(toSuperView: whiteView) // “状态“
        stateLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 状态
        setTitle(title: state, content: stateLabel, lastLabel: time, isLast: true)
        state.text = "最新状态："
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - lastLabel: 跟随的最后一个控件
    ///   - isLast: 是否是最后一个
    private func setTitle(title: UILabel, content: UILabel, lastLabel: UILabel, isLast: Bool = false) {
        title.taxi.layout { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(lastLabel.snp.bottom).offset(5)
            make.right.lessThanOrEqualTo(content).offset(-8)
            if isLast {
                make.bottom.equalToSuperview().offset(-13)
            }
        }
            .taxi.config { (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        content.taxi.layout { (make) in
            make.top.equalTo(title)
            make.left.equalTo(title.snp.right).offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-23)
        }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
        }
    }
}
