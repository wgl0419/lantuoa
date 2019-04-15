//
//  ProjectListCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/15.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目列表 cell

import UIKit
import SnapKit

class ProjectListCell: UITableViewCell {
    
    var data: ProjectListStatisticsData? {
        didSet {
            if let data = data {
                titleLabel.text = data.name ?? " "
                followLabel.text = "\(data.responseUserNum)人"
                manageLabel.text = data.customerName
                countLabel.text = data.name
                stateLabel.text = data.lastVisitResult ?? "尚未拜访"
                if data.lastVisitTime == 0 {
                    timeLabel.text = "尚未拜访"
                } else {
                    let timeStr = Date(timeIntervalSince1970: TimeInterval(data.lastVisitTime)).yearTimeStr()
                    timeLabel.text = timeStr
                }
                
                let weekCount = setAttriMuStr(contentStr: "跟进人数：\(data.weekVisitUserNum)人", highlightStr: "跟进人数：", highlightColor:  UIColor(hex: "#999999"))
                weekCountLabel.attributedText = weekCount
                
                let weekDeal = setAttriMuStr(contentStr: "成交：\(data.weekVisitUserNum)元", highlightStr: "成交：", highlightColor:  UIColor(hex: "#999999"))
                weekDealLabel.attributedText = weekDeal
                
                let weekRebate = setAttriMuStr(contentStr: "回扣：\(data.weekVisitUserNum)元", highlightStr: "回扣：", highlightColor:  UIColor(hex: "#999999"))
                weekRebateLabel.attributedText = weekRebate
                
                let moonCount = setAttriMuStr(contentStr: "跟进人数：\(data.monthVisitNum)人", highlightStr: "跟进人数：", highlightColor:  UIColor(hex: "#999999"))
                moonCountLabel.attributedText = moonCount
                
                let moonDeal = setAttriMuStr(contentStr: "成交：\(data.weekVisitUserNum)元", highlightStr: "成交：", highlightColor:  UIColor(hex: "#999999"))
                moonDealLabel.attributedText = moonDeal
                
                let moonRebate = setAttriMuStr(contentStr: "回扣：\(data.weekVisitUserNum)元", highlightStr: "回扣：", highlightColor:  UIColor(hex: "#999999"))
                moonRebateLabel.attributedText = moonRebate
                
                
                if data.isLock == 1 { //TODO: 未知1是不是锁定  暂定为锁定
                    followView.backgroundColor = UIColor(hex: "#FF7744")
                    stateConstraint.deactivate()
                    ascriptionConstraint.activate()
                    ascriptionLabel.text = "后端没有给数据" // TODO: 后端没有给数据
                    ascription.text = "参与人员："
                } else {
                    followView.backgroundColor = UIColor(hex: "#5FB9A1")
                    stateConstraint.activate()
                    ascriptionConstraint.deactivate()
                    ascriptionLabel.text = ""
                    ascription.text = ""
                }
            }
        }
    }

    /// 白色背景框
    private var whiteView: UIView!
    /// 跟进背景
    private var followView: UIView!
    /// 跟进数
    private var followLabel: UILabel!
    /// 标题
    private var titleLabel: UILabel!
    /// 管理人
    private var manageLabel: UILabel!
    /// 拜访次数
    private var countLabel: UILabel!
    /// 拜访时间
    private var timeLabel: UILabel!
    /// 状态
    private var stateLabel: UILabel!
    /// "锁定人："
    private var ascription: UILabel!
    /// 锁定人
    private var ascriptionLabel: UILabel!
    /// 一周跟进人数
    private var weekCountLabel = UILabel()
    /// 一周成交
    private var weekDealLabel = UILabel()
    /// 一周回扣
    private var weekRebateLabel = UILabel()
    /// 一月跟进人数
    private var moonCountLabel = UILabel()
    /// 一月成交
    private var moonDealLabel = UILabel()
    /// 一月回扣
    private var moonRebateLabel = UILabel()
    
    
    /// 状态底部约束
    private var stateConstraint: Constraint!
    /// 锁定人底部约束
    private var ascriptionConstraint: Constraint!
    
    
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
        
        whiteView = UIView().taxi.adhere(toSuperView: contentView) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentView).offset(8)
                make.left.equalTo(contentView).offset(15)
                make.right.equalTo(contentView).offset(-15)
                make.bottom.equalTo(contentView).offset(-8)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 4
                view.layer.shadowOpacity = 1
                view.backgroundColor = .white
                view.layer.shadowColor = UIColor(hex: "#666666", alpha: 0.2).cgColor
                view.layer.shadowOffset = CGSize(width: 2, height: 2)
            })
        
        let arrowView = UIView().taxi.adhere(toSuperView: whiteView) // 填充箭头
            .taxi.layout { (make) in
                make.top.left.right.equalToSuperview()
            }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        titleLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(13)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-70)
            })
            .taxi.config({ (label) in
                label.text = "南宁出租车后车门广告"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        _ = UIImageView().taxi.adhere(toSuperView: arrowView) // 箭头
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "arrow")
            })
        
        followView = UIView().taxi.adhere(toSuperView: arrowView) // 跟进背景
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel)
                make.width.height.equalTo(50)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 25
                view.layer.masksToBounds = true
                view.backgroundColor = UIColor(hex: "#5FB9A1")
            })
        
        _ = UILabel().taxi.adhere(toSuperView: followView) // “跟进人数”
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(followView.snp.centerY).offset(-2)
            })
            .taxi.config({ (label) in
                label.text = "跟进人数"
                label.textColor = .white
                label.textAlignment = .center
                label.font = UIFont.medium(size: 8)
            })
        
        followLabel = UILabel().taxi.adhere(toSuperView: followView) // 跟进人数
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(followView.snp.centerY).offset(2)
            })
            .taxi.config({ (label) in
                label.text = "6人"
                label.textColor = .white
                label.textAlignment = .center
                label.font = UIFont.medium(size: 12)
            })
        
        let manage = UILabel().taxi.adhere(toSuperView: arrowView) // "管理人"
        manageLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 管理人
        setTitle(title: manage, content: manageLabel, lastLabel: titleLabel)
        manage.text = "管理人："
        
        let count = UILabel().taxi.adhere(toSuperView: arrowView) // "拜访次数"
        countLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 拜访次数
        setTitle(title: count, content: countLabel, lastLabel: manage)
        count.text = "总拜访次数："
        
        let time = UILabel().taxi.adhere(toSuperView: arrowView) // "拜访时间"
        timeLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 拜访时间
        setTitle(title: time, content: timeLabel, lastLabel: count)
        time.text = "最新拜访时间："
        
        let state = UILabel().taxi.adhere(toSuperView: arrowView) // "状态"
        stateLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 状态
        setTitle(title: state, content: stateLabel, lastLabel: time, isLast: true)
        state.text = "最新拜访状态："
        
        ascription = UILabel().taxi.adhere(toSuperView: arrowView) // "锁定人"
        ascriptionLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 锁定人
        setTitle(title: ascription, content: ascriptionLabel, lastLabel: state, isLast: true)
        
        stateConstraint.deactivate()
        ascriptionConstraint.activate()
        
        setCount(titleStr: "最近一周", count: weekCountLabel, deal: weekDealLabel, rebate: weekRebateLabel, lastView: arrowView)
        setCount(titleStr: "最近一月", count: moonCountLabel, deal: moonDealLabel, rebate: moonRebateLabel, lastView: weekCountLabel, isLast: true)
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
                if lastLabel.text == "最新拜访时间：" { // 状态底部约束
                    stateConstraint = make.bottom.equalToSuperview().offset(-13).priority(800).constraint
                } else { // 锁定人底部约束
                    ascriptionConstraint = make.bottom.equalToSuperview().offset(-13).priority(800).constraint
                }
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
            if lastLabel == titleLabel {
                make.right.lessThanOrEqualToSuperview().offset(-70)
            } else {
                make.right.lessThanOrEqualToSuperview().offset(-23)
            }
            }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
    
    /// 设置时间
    ///
    /// - Parameters:
    ///   - titleStr: 标题内容
    ///   - count: 数量label
    ///   - deal: 成交label
    ///   - rebate: 回扣label
    ///   - lastView: 跟随的最后一个视图
    ///   - isLast: 是否是最后一个
    private func setCount(titleStr: String, count: UILabel, deal: UILabel, rebate: UILabel, lastView: UIView, isLast: Bool = false) {
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.right.equalToSuperview()
                if isLast { // 因为只有两个  直接判断 是否是第二个
                    make.top.equalTo(lastView.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(lastView.snp.bottom)
                }
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        let title = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout { (make) in
                if isLast { // 因为只有两个  直接判断 是否是第二个
                    make.top.equalTo(lastView.snp.bottom).offset(20)
                } else {
                    make.top.equalTo(lastView.snp.bottom).offset(10)
                }
                make.left.equalToSuperview().offset(15)
            }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#6B83D1")
        }
        
        count.taxi.adhere(toSuperView: whiteView) // 数量
            .taxi.layout { (make) in
                make.width.equalToSuperview().dividedBy(3.1).priority(800)
                make.top.equalTo(title.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
                if isLast {
                    make.bottom.equalToSuperview().offset(-10)
                }
            }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
        }
        
        deal.taxi.adhere(toSuperView: whiteView) // 成交
            .taxi.layout { (make) in
                make.width.equalToSuperview().dividedBy(3.1).priority(800)
                make.top.equalTo(title.snp.bottom).offset(5)
                make.left.equalTo(count.snp.right).offset(5)
            }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
        }
        
        rebate.taxi.adhere(toSuperView: whiteView) // 回扣
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(3.1).priority(800)
                make.top.equalTo(title.snp.bottom).offset(5)
                make.left.equalTo(deal.snp.right).offset(5)
            })
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
        }
    }
    
    /// 设置富文本
    ///
    /// - Parameters:
    ///   - contentStr: 内容
    ///   - highlightStr: 高亮内容
    ///   - highlightColor: 高亮颜色
    /// - Returns: 富文本
    private func setAttriMuStr(contentStr: String, highlightStr: String, highlightColor: UIColor) -> NSMutableAttributedString {
        let attriMuStr = NSMutableAttributedString(string: contentStr)
        attriMuStr.changeColor(str: highlightStr, color: highlightColor)
        return attriMuStr
    }
}

