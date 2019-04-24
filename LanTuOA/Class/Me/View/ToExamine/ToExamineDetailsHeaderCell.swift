//
//  ToExamineDetailsHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批详情 顶部cell

import UIKit

class ToExamineDetailsHeaderCell: UITableViewCell {
    
    /// 数据
    var data: NotifyCheckListData? {
        didSet {
            if let data = data {
                initSubViews()
                
                titleLabel.text = data.processName
                
                let smallData = data.data
                if smallData.count == 1 {
                    let model = smallData.first!
                    _ = setTitleAndContent(model.title ?? "", contentStr: model.value ?? "", lastLabel: titleLabel, isLast: true)
                }
                var lastLabel = titleLabel
                for index in 0..<smallData.count {
                    let model = smallData[index]
                    let label = setTitleAndContent(model.title ?? "", contentStr: model.value ?? "", lastLabel: lastLabel, isLast: index == smallData.count - 1)
                    lastLabel = label
                }
                
                if data.status == 1 {
                    statusImageView.image = UIImage()
                } else if data.status == 2 {
                    statusImageView.image = UIImage(named: "approval_agree")
                } else {
                    statusImageView.image = UIImage(named: "approval_refuse")
                }
            }
        }
    }
    
    
    /// 标题
    private var titleLabel: UILabel!
    /// 状态图标
    private var statusImageView: UIImageView!
    
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
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-20)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize:18)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 标记线
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(titleLabel)
                make.left.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        statusImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 状态图标
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-7)
                make.top.equalToSuperview().offset(8)
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
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
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
        
        let contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout { (make) in
                make.top.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
                make.right.lessThanOrEqualToSuperview().offset(-20)
                if isLast {
                    make.bottom.equalToSuperview().offset(-10)
                }
            }
            .taxi.config { (label) in
                label.text = contentStr
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
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
