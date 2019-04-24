//
//  CustomerHomeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/15.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户首页  cell

import UIKit

class CustomerHomeCell: UITableViewCell {
    
    /// 数据
    var data: CustomerListStatisticsData? {
        didSet {
            if let data = data {
                let industryStr = "(\(data.industryName ?? ""))"
                let titleAttriMuStr = NSMutableAttributedString(string: "\(data.name ?? "") \(industryStr)")
                titleAttriMuStr.changeColor(str: industryStr, color: UIColor(hex: "#999999"))
                titleAttriMuStr.changeFont(str: industryStr, font: UIFont.medium(size: 12))
                titleLabel.attributedText = titleAttriMuStr
                
                let customerTypeStr = data.type == 1 ? "公司" : data.type == 2 ? "普通" : "开发中"
                let width = customerTypeStr.getTextSize(font: UIFont.medium(size: 10), maxSize: CGSize(width: ScreenWidth, height: ScreenHeight)).width
                customerTypeBtn.snp.updateConstraints { (make) in
                    make.width.equalTo(width + 10)
                }
                customerTypeBtn.setTitle(customerTypeStr, for: .normal)
                
                let allAttriMuStr = setAttriMuStr(contentStr: "在线  \(data.onlineProjectNum)", highlightStr: "在线", highlightColor:  UIColor(hex: "#999999"))
                allLabel.attributedText = allAttriMuStr
                
                let lockAttriMuStr =  setAttriMuStr(contentStr: "锁定  \(data.lockedProjectNum)", highlightStr: "锁定", highlightColor:  UIColor(hex: "#999999"))
                lockLabel.attributedText = lockAttriMuStr
                
                let unlockAttriMuStr = setAttriMuStr(contentStr: "未锁定  \(data.noLockProjectNum)", highlightStr: "未锁定", highlightColor:  UIColor(hex: "#999999"))
                unlockLabel.attributedText = unlockAttriMuStr
                
                visitLabel.text = data.lastVisitUserName ?? "尚未拜访"
                stateLabel.text = data.lastVisitResult ?? "尚未拜访"
                
                if data.lastVisitTime == 0 {
                    timeLabel.text = "尚未拜访"
                } else {
                    let timeStr = Date(timeIntervalSince1970: TimeInterval(data.lastVisitTime)).yearTimeStr()
                    timeLabel.text = timeStr
                }
                
                let weekCount = setAttriMuStr(contentStr: "跟进人数：\(data.weekVisitUserNum)人", highlightStr: "跟进人数：", highlightColor:  UIColor(hex: "#999999"))
                weekCountLabel.attributedText = weekCount
                
                let weekDeal = setAttriMuStr(contentStr: String(format: "成交：%.2f元", data.monthMoney), highlightStr: "成交：", highlightColor:  UIColor(hex: "#999999"))
                weekDealLabel.attributedText = weekDeal
                
                let weekRebate = setAttriMuStr(contentStr: String(format: "回扣：%.2f元", data.monthRebate), highlightStr: "回扣：", highlightColor:  UIColor(hex: "#999999"))
                weekRebateLabel.attributedText = weekRebate
                
                let moonCount = setAttriMuStr(contentStr: "跟进人数：\(data.monthVisitNum)人", highlightStr: "跟进人数：", highlightColor:  UIColor(hex: "#999999"))
                moonCountLabel.attributedText = moonCount
                
                let moonDeal = setAttriMuStr(contentStr: String(format: "成交：%.2f元", data.seasonMoney), highlightStr: "成交：", highlightColor:  UIColor(hex: "#999999"))
                moonDealLabel.attributedText = moonDeal
                
                let moonRebate = setAttriMuStr(contentStr: String(format: "回扣：%.2f元", data.seasonRebate), highlightStr: "回扣：", highlightColor:  UIColor(hex: "#999999"))
                moonRebateLabel.attributedText = moonRebate
            }
        }
    }
    /// 编辑回调
    var editBlock: (() -> ())?

    /// 白色背景框
    private var whiteView: UIView!
    /// 在线 （全部）
    private var allLabel: UILabel!
    /// 锁定
    private var lockLabel: UILabel!
    /// 未锁定
    private var unlockLabel: UILabel!
    /// 标题
    private var titleLabel: UILabel!
    /// 客户类型
    private var customerTypeBtn : UIButton!
    /// 最新拜访人
    private var visitLabel: UILabel!
    /// 最新拜访时间
    private var timeLabel: UILabel!
    /// 最新状态
    private var stateLabel: UILabel!
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
                label.text = " "
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        _ = UIView().taxi.adhere(toSuperView: arrowView) // 蓝色线条
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(2)
                make.height.equalTo(15)
                make.left.equalToSuperview()
                make.centerY.equalTo(titleLabel)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        let customerType = UILabel().taxi.adhere(toSuperView: arrowView) // “客户类型”
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
            .taxi.config { (label) in
                label.text = "客户类型："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        customerTypeBtn = UIButton().taxi.adhere(toSuperView: arrowView) // 客户类型按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(33)
                make.height.equalTo(18)
                make.centerY.equalTo(customerType)
                make.left.equalTo(customerType.snp.right)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.layer.borderWidth = 1
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.layer.borderColor = UIColor(hex: "#5FB9A1").cgColor
                
                btn.backgroundColor = UIColor(hex: "#E4F0ED")
                btn.titleLabel?.font = UIFont.medium(size: 10)
                btn.setTitleColor(UIColor(hex: "#2F9B7F"), for: .normal)
            })
        
        _ = UIImageView().taxi.adhere(toSuperView: arrowView) // 箭头
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "arrow")
            })
        
        //        _ = UIButton().taxi.adhere(toSuperView: arrowView) // “编辑”按钮 // TODO: 蒙冠洲叫改
//            .taxi.layout(snapKitMaker: { (make) in
//                make.width.equalTo(60)
//                make.height.equalTo(24)
//                make.top.equalToSuperview().offset(15)
//                make.right.equalToSuperview().offset(-15)
//            })
//            .taxi.config({ (btn) in
//                btn.setTitle("编辑", for: .normal)
//                btn.setTitleColor(.white, for: .normal)
//                btn.backgroundColor = UIColor(hex: "#2E4695")
//                btn.titleLabel?.font = UIFont.medium(size: 12)
//                btn.layer.cornerRadius = 2
//                btn.layer.masksToBounds = true
//                btn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
//            })
        
        let project = UILabel().taxi.adhere(toSuperView: arrowView) // "项目"
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(customerType.snp.bottom).offset(5)
        }
            .taxi.config { (label) in
                label.text = "项目："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        allLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 在线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(project)
                make.left.equalTo(project.snp.right).offset(5)
                make.width.equalToSuperview().dividedBy(9 / 2.0).priority(800)
            })
            .taxi.config({ (label) in
                label.text = "在线 66666"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        lockLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 锁定
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(project)
                make.left.equalTo(allLabel.snp.right).offset(5)
                make.width.equalToSuperview().dividedBy(9 / 2.0).priority(800)
            })
            .taxi.config({ (label) in
                label.text = "锁定 66666"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        unlockLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 在线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(project)
                make.left.equalTo(lockLabel.snp.right).offset(5)
                make.width.equalToSuperview().dividedBy(9 / 2.0).priority(800)
            })
            .taxi.config({ (label) in
                label.text = "在线 666666"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        let visit = UILabel().taxi.adhere(toSuperView: arrowView) // "最新拜访人"
        visitLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 最新拜访人
        setTitle(title: visit, content: visitLabel, lastLabel: project)
        visit.text = "最新拜访人："
        
        let time = UILabel().taxi.adhere(toSuperView: arrowView) // "最新拜访时间"
        timeLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 最新拜访时间
        setTitle(title: time, content: timeLabel, lastLabel: visit)
        time.text = "最新拜访时间："
        
        let state = UILabel().taxi.adhere(toSuperView: arrowView) // "最新状态"
        stateLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 最新状态
        setTitle(title: state, content: stateLabel, lastLabel: time, isLast: true)
        state.text = "最新拜访状态："
        
        let ascription = UILabel().taxi.adhere(toSuperView: arrowView) // "锁定人"
        ascriptionLabel = UILabel().taxi.adhere(toSuperView: arrowView) // 锁定人
        setTitle(title: ascription, content: ascriptionLabel, lastLabel: state, isLast: true)
        ascription.text = "锁定人："
        
        setCount(titleStr: "最近一月", count: weekCountLabel, deal: weekDealLabel, rebate: weekRebateLabel, lastView: arrowView)
        setCount(titleStr: "最近三月", count: moonCountLabel, deal: moonDealLabel, rebate: moonRebateLabel, lastView: weekCountLabel, isLast: true)
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
                make.bottom.equalToSuperview().offset(-13).priority(800)
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
                make.width.equalToSuperview().dividedBy(3.8).priority(800)
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
                label.adjustsFontSizeToFitWidth = true
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
                label.adjustsFontSizeToFitWidth = true
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
    
    // MARK: - 按钮点击
    /// 点击编辑
    @objc private func editClick() {
        if editBlock != nil {
            editBlock!()
        }
    }
}

