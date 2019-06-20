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
                titleLabel.text = data.createdUserName
                numLabel.attributedText = richText(title: "订单编号：", content: "\(data.id)")
                let smallData = data.data
//                if smallData.count == 1 {
//                    let model = smallData.first!
//                    _ = setTitleAndContent(model.title ?? "", contentStr: model.value ?? "", lastLabel: titleLabel, isLast: true)
//                }
                var lastView: UIView = numLabel
                for index in 0..<smallData.count {
                    let model = smallData[index]
                    
                    if model.type == 1 { // 标题 + 文本
                        let label = setTitleAndContent(model.title ?? "", contentStr: model.value ?? "", lastView: lastView, isLast: index == smallData.count - 1)
                        lastView = label
                        
                    } else if model.type == 2 { // 表单名称
                        lastView = setFormHeader(model.title ?? "", lastView: lastView, isLast: index == smallData.count - 1)
                    } else { // 分割线
                        lastView = UIView().taxi.adhere(toSuperView: contentView) // 分割线
                            .taxi.layout(snapKitMaker: { (make) in
                                make.top.equalTo(lastView.snp.bottom).offset(5)
                                make.left.equalToSuperview().offset(15)
                                make.right.equalToSuperview()
                                make.height.equalTo(1)
                                if index == smallData.count - 1 {
                                    make.bottom.equalToSuperview()
                                }
                            })
                            .taxi.config({ (view) in
                                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                            })
                    }
                }
            }
        }
    }
    
    
    /// 标题
    private var titleLabel: UILabel!
    ///订单编号
    private var numLabel: UILabel!
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
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize:18)
            })
        
        numLabel = UILabel().taxi.adhere(toSuperView: contentView) // 订单编号
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(15)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 14)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
    }
    
    
    /// 生成标题+内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题str
    ///   - contentStr: 内容str
    ///   - lastLabel: 跟随的控件
    ///   - isLast: 是否是后一个控件
    /// - Returns: 内容控件
    private func setTitleAndContent(_ titleStr: String, contentStr: String, lastView: UIView, isLast: Bool) -> UILabel {
        
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
            }
            .taxi.config { (label) in
                label.text = titleStr + "："
                label.font = UIFont.regular(size: 14)
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
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.regular(size: 14)
                label.text = contentStr.count == 0 ? " " : contentStr
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        return contentLabel
    }
    
    /// 设置表单头
    private func setFormHeader(_ titleStr: String, lastView: UIView, isLast: Bool) -> UILabel {
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(lastView is UILabel ? 11 : 5)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.regular(size: 14)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        if lastView is UILabel {
            _ = UIView().taxi.adhere(toSuperView: contentView) // 分割线
                .taxi.layout(snapKitMaker: { (make) in
                    make.top.equalTo(lastView.snp.bottom).offset(5)
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview()
                    make.height.equalTo(1)
                })
                .taxi.config({ (view) in
                    view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                })
        }
        
        return titleLabel
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
    
    ///处理编号
    private func richText(title:String,content:String) -> NSMutableAttributedString{
        let attrs1 = [NSAttributedString.Key.font : UIFont.regular(size: 14), NSAttributedString.Key.foregroundColor : UIColor(hex: "#999999")]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.regular(size: 14), NSAttributedString.Key.foregroundColor : blackColor]
        
        let attributedString1 = NSMutableAttributedString(string:title, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:content, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        
        return attributedString1
    }
    
    

}
