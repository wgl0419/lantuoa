//
//  ProjectHomeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/15.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目首页 cell

import UIKit

class ProjectHomeCell: UITableViewCell {

    /// 数据
    var data: ProjectLlistStatisticsData? {
        didSet {
            if let data = data {
                titleLabel.text = data.name ?? " "
                customerLabel.text = data.customerName
                initiateLabel.text = data.customerName
                visitNameLabel.text = data.lastVisitUserName
                stateLabel.text = data.lastVisitResult
                
                let timeStamp = data.lastVisitTime
                if timeStamp != 0 {
                    let tiemStr = Date(timeIntervalSince1970: TimeInterval(timeStamp)).yearTimeStr()
                    timeLabel.text = tiemStr
                } else {
                    timeLabel.text = " "
                }
            }
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    /// 客户
    private var customerLabel: UILabel!
    /// 业务人员
    private var initiateLabel: UILabel!
    /// 联系人
    private var visitNameLabel: UILabel!
    /// 拜访时间
    private var timeLabel: UILabel!
    /// 状态
    private var stateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
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
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "arrow")
            })
        
        let customer = UILabel().taxi.adhere(toSuperView: whiteView) // "客户"
        customerLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 客户
        setTitle(title: customer, content: customerLabel, lastLabel: titleLabel)
        customer.text = "客户："
        
        let initiate = UILabel().taxi.adhere(toSuperView: whiteView) // "业务人员"
        initiateLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 业务人员
        setTitle(title: initiate, content: initiateLabel, lastLabel: customer)
        initiate.text = "业务人员："
        
        let visitName = UILabel().taxi.adhere(toSuperView: whiteView) // “联系人”
        visitNameLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 联系人
        setTitle(title: visitName, content: visitNameLabel, lastLabel: initiate)
        visitName.text = "最新联系人："
        
        let time = UILabel().taxi.adhere(toSuperView: whiteView) // “时间”
        timeLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 时间
        setTitle(title: time, content: timeLabel, lastLabel: visitName)
        time.text = "最新拜访时间："
        
        let state = UILabel().taxi.adhere(toSuperView: whiteView) // “状态“
        stateLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 状态
        setTitle(title: state, content: stateLabel, lastLabel: time, isLast: true)
        state.text = "最新拜访状态："
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
            if isLast {
                make.bottom.equalToSuperview().offset(-13)
            }
            }
            .taxi.config { (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        content.taxi.layout { (make) in
            make.top.equalTo(title)
            make.left.equalTo(title.snp.right).offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-23)
            }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}
