//
//  CostomerDetailsProjectCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户详情  在线项目 cell

import UIKit

class CostomerDetailsProjectCell: UITableViewCell {

    /// 数据
    var data: ProjectListStatisticsData? {
        didSet {
            if let data = data {
                let attriMuStr = NSMutableAttributedString(string: (data.fullName ?? "") + "  ")
                if data.isLock == 1 { // 添加锁图标
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: "project_lock")
                    attachment.bounds = CGRect(x: 5, y: -2, width: 13, height: 15)
                    let attriStr = NSAttributedString(attachment: attachment)
                    attriMuStr.append(attriStr)
                }
                nameLabel.attributedText = attriMuStr
                
                wordGroupLabel.text = preventEmpty(data.groupNames)
                personLabel.text = preventEmpty(data.members)
                stateLabel.text = preventEmpty(data.lastVisitResult)
            }
        }
    }
    
    /// 项目名称
    private var nameLabel: UILabel!
    /// 工作组
    private var wordGroupLabel: UILabel!
    /// 参与人员
    private var personLabel: UILabel!
    /// 状态
    private var stateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(13)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        let wordGroup = UILabel().taxi.adhere(toSuperView: contentView) // "工作组"
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
            .taxi.config { (label) in
                label.text = "工作组："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }

        wordGroupLabel = UILabel().taxi.adhere(toSuperView: contentView) // 工作组
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(wordGroup.snp.right)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.right.lessThanOrEqualToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            })

        let person = UILabel().taxi.adhere(toSuperView: contentView) // "参与人员"
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(wordGroupLabel.snp.bottom).offset(5)
        }
            .taxi.config { (label) in
                label.text = "参与人员："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }

        personLabel = UILabel().taxi.adhere(toSuperView: contentView) // 参与人员
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(person.snp.right)
                make.right.lessThanOrEqualToSuperview().offset(-15)
                make.top.equalTo(wordGroupLabel.snp.bottom).offset(5)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentHuggingPriority(.defaultLow, for: .horizontal)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
        
        let state = UILabel().taxi.adhere(toSuperView: contentView) // ”状态“
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(personLabel.snp.bottom).offset(5)
            }
            .taxi.config { (label) in
                label.text = "最新状态："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        stateLabel = UILabel().taxi.adhere(toSuperView: contentView) // 状态
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(state.snp.right)
                make.bottom.equalToSuperview().offset(-13)
                make.top.equalTo(personLabel.snp.bottom).offset(5)
                make.right.lessThanOrEqualToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            })
    }
    
    /// 防止传空
    ///
    /// - Parameter str: 要判断的内容
    /// - Returns: 非空字符串
    private func preventEmpty(_ contentStr: String?) -> String {
        if let str = contentStr {
            if str.count > 0 {
                return str
            }
        }
        return "暂无"
    }
}
