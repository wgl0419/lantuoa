//
//  ProjectDetailsVisitCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情 拜访历史 cell

import UIKit

class ProjectDetailsVisitCell: UITableViewCell {

    var data: VisitListData? {
        didSet {
            if let data = data {
                nameLabel.text = data.contactInfo
                initiatedLabel.text = data.createUserName
                modeLabel.text = data.type == 1 ? "面谈" : data.type == 2 ? "电话沟通" : "网络聊天"
                resultLabel.text = data.result
                let timeStr = Date(timeIntervalSince1970: TimeInterval(data.visitTime)).yearTimeStr()
                timeLabel.text = timeStr
            }
        }
    }
    
    /// 拜访对象
    private var nameLabel: UILabel!
    /// 业务人员
    private var initiatedLabel: UILabel!
    /// 拜访方式
    private var modeLabel = UILabel()
    /// 拜访时间
    private var timeLabel = UILabel()
    /// 拜访结果
    private var resultLabel = UILabel()
    
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
        
        let name = UILabel().taxi.adhere(toSuperView: contentView) // “拜访对象”
            .taxi.layout { (make) in
                make.top.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "拜访对象："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }

        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 拜访对象名称
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(name)
                make.left.equalTo(name.snp.right)
            })
            .taxi.config({ (label) in
                label.text = "拜访对象"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })

        let initiated = UILabel().taxi.adhere(toSuperView: contentView) // “业务人员”
            .taxi.layout { (make) in
                make.left.greaterThanOrEqualToSuperview().offset(115)
                make.left.equalTo(nameLabel.snp.right).offset(5)
                make.top.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "业务人员："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }

        initiatedLabel = UILabel().taxi.adhere(toSuperView: contentView) // 业务人员
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(initiated)
                make.left.equalTo(initiated.snp.right)
            })
            .taxi.config({ (label) in
                label.text = "业务人员"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })

        let mode = UILabel()
        setTitle(title: mode, content: modeLabel, lastLabel: name)
        mode.text = "拜访方式："
        modeLabel.text = "拜访方式："

        let time = UILabel()
        setTitle(title: time, content: timeLabel, lastLabel: mode)
        time.text = "拜访时间："
        timeLabel.text = "拜访方式："

        let result = UILabel()
        setTitle(title: result, content: resultLabel, lastLabel: time, isLast: true)
        resultLabel.text = "123"
        result.text = "拜访结果："
        resultLabel.text = "拜访方式："
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - lastLabel: 跟随的最后一个控件
    ///   - isLast: 是否是最后一个
    private func setTitle(title: UILabel, content: UILabel, lastLabel: UILabel, isLast: Bool = false) {
        contentView.addSubview(title)
        contentView.addSubview(content)
        
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
            make.centerY.equalTo(title)
            make.left.equalTo(title.snp.right)
            make.right.lessThanOrEqualToSuperview().offset(-5)
        }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}


