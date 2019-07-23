//
//  CheckReportListCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CheckReportListCell: UITableViewCell {
    
    /// 数据 (数据 + 是否是待审批)
    var data: (NotifyCheckListData, Bool)! {
        didSet {
            checkListData = data.0
            let isCheck = data.1
//            titleLabel.removeFromSuperview()
            initSubViews()
            titleLabel.text = checkListData.title
            titleLabel.textColor = UIColor(hex: "#FF7744")
            
            let smallData = checkListData.data
            if smallData.count == 1 {
                let model = smallData.first!
                _ = setTitleAndContent(model.title ?? "", contentStr: model.value ?? "", lastLabel: titleLabel, isLast: true)
            }
            var lastLabel = titleLabel
            let showCount = smallData.count > 5 ? 5 : smallData.count
            for index in 0..<showCount { //  最多显示5行
                let model = smallData[index]
                let label = setTitleAndContent(model.title ?? "", contentStr: model.value ?? "", lastLabel: lastLabel, isLast: index == smallData.count - 1)
                lastLabel = label
            }
            if smallData.count > 5 {
                _ = UILabel().taxi.adhere(toSuperView: whiteView)
                    .taxi.layout(snapKitMaker: { (make) in
                        make.top.equalTo(lastLabel!.snp.bottom).offset(10)
                        make.bottom.equalTo(agreeBtn.snp.top).offset(-15)
                        make.left.equalToSuperview().offset(15)
                    })
                    .taxi.config({ (label) in
                        label.font = UIFont.regular(size: 14)
                        label.textColor = UIColor(hex: "#6B83D1")
                        
                        let str = "点击卡片查看更多详情"
                        let attriMuStr = NSMutableAttributedString(string: str)
                        attriMuStr.addUnderline(color: UIColor(hex: "#6B83D1"), range: NSRange(location: 0, length: str.count))
                        label.attributedText = attriMuStr
                    })
            }
            
            agreeBtn.isHidden = !isCheck
            refuseBtn.isHidden = !isCheck
            timeLabel.isHidden = isCheck
            
            if checkListData.createdTime != 0 {
                let date = Date(timeIntervalSince1970: TimeInterval(checkListData.createdTime))
                timeLabel.text  = timeHandle(date: date)
            } else {
                timeLabel.text = " "
            }

            if checkListData.status == 1{
                readLabel.text = "未读"
                readLabel.textColor = UIColor(hex: "#FF4444")
                redView.backgroundColor = UIColor(hex: "#FF4444")
            }else{
                readLabel.text = "已读"
                readLabel.textColor = UIColor(hex: "#999999")
                redView.backgroundColor = UIColor.white
            }
            commentsLabel.text = "评论（\(checkListData.commentCnt)）"
        }
    }
    /// 白色背景
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// 同意按钮
    private var agreeBtn: UIButton!
    /// 拒绝按钮
    private var refuseBtn: UIButton!
    /// 已读，未读
    private var readLabel: UILabel!
    ///评论（0）
    private var commentsLabel: UILabel!
    /// 时间
    private var timeLabel: UILabel!
    
    private var redView: UIView!
    
    private var haveRead :UIButton!
    
    var checkListData: NotifyCheckListData!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.removeAllSubviews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        backgroundColor = UIColor(hex: "#F3F3F3")
        
        whiteView = UIView().taxi.adhere(toSuperView: contentView) // 白色背景图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-5)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
                view.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.16).cgColor
                view.layer.shadowRadius = 3
                view.layer.cornerRadius = 4
                view.layer.shadowOpacity = 1
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-20)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        agreeBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 同意按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview().offset(-15)
                make.height.equalTo(33)
                make.width.equalTo(55)
            })
            .taxi.config({ (btn) in

            })
        
        timeLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.right.bottom.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#999999")
            })
        
        refuseBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 拒绝按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.width.height.equalTo(agreeBtn)
                make.right.equalTo(agreeBtn.snp.left).offset(-10)
            })
            .taxi.config({ (btn) in

            })
        
        readLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 已读，未读
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.width.equalTo(30)
                make.bottom.equalTo(agreeBtn)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 10)
            })
        
        commentsLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 评论
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(readLabel.snp.right).offset(5)
                make.bottom.equalTo(agreeBtn)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#999999")
            })
        redView = UIView().taxi.adhere(toSuperView: whiteView)
            .taxi.layout(snapKitMaker: { (make) in
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(10)
                make.width.height.equalTo(10)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 5
                view.layer.masksToBounds = true
            })
    }
    
    
    /// 生成标题+内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题str
    ///   - contentStr: 内容str
    ///   - lastLabel: 跟随的控件
    ///   - isLast: 是否是后一个控件
    /// - Returns: 内容控件
    private func setTitleAndContent(_ titleStr: String, contentStr: String, lastLabel: UILabel?, isLast: Bool) -> UILabel {
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout { (make) in
                make.top.equalTo(lastLabel!.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
            }
            .taxi.config { (label) in
                label.text = titleStr + "："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        let contentLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 内容
            .taxi.layout { (make) in
                make.top.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
                make.right.lessThanOrEqualTo(whiteView).offset(-20)
                if isLast {
                    make.bottom.equalTo(agreeBtn.snp.top).offset(-15)
                }
            }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.text = contentStr.count == 0 ? " " : contentStr
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        return contentLabel
    }
    
    /// 时间处理
    private func timeHandle(date: Date) -> String {
        if date.isToday {
            return "今天\(date.dayTimeStr())"
        } else if date.isYesterday {
            return "昨天 \(date.dayTimeStr())"
        } else if date.isYear {
            return date.customTimeStr(customStr: "MM月dd日 HH:mm")
        } else {
            return date.customTimeStr(customStr: "yyyy年MM月dd日 HH:mm")
        }
    }

}

