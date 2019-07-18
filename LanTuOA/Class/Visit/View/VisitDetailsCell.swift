//
//  VisitDetailsCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/2.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访详情 (标题 + 内容) cell

import UIKit

class VisitDetailsCell: UITableViewCell {
    
    /// 拜访方式 -> 显示方式
    enum visitType {
        /// 详情
        case details
        /// 内容
        case content
        /// 结果
        case result
    }
    
    /// 数据
    var visitListData: (VisitListData, visitType)? {
        didSet {
            if let data = visitListData?.0, let type = visitListData?.1 {
                switch type {
                case .details:
                    let createStr = data.createUserName ?? ""
                    let visitStr = data.contactInfo ?? ""
                    let typeStr = data.type == 1 ? "面谈" : data.type == 2 ? "电话沟通" : "网络聊天"
                    var time = "未设置"
                    if data.visitTime != 0 {
                        time = Date(timeIntervalSince1970: TimeInterval(data.visitTime)).yearTimeStr()
                    }
                    let create = setTitleAndContent("业务人员：", contentStr: createStr, lastLabel: nil, position: -1)
                    let visit = setTitleAndContent("联系人：", contentStr: visitStr, lastLabel: create, position: 0)
                    let type = setTitleAndContent("拜访方式：", contentStr: typeStr, lastLabel: visit, position: 0)
                    _ = setTitleAndContent("拜访时间：", contentStr: time, lastLabel: type, position: 1)
                case .content:
                    _ = setTitleAndContent("拜访内容：", contentStr: data.content ?? " ", lastLabel: nil, position: 2)
                case .result:
                    _ = setTitleAndContent("主要事宜：", contentStr: data.result ?? " ", lastLabel: nil, position: 2)
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 生成标题+内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题str
    ///   - contentStr: 内容str
    ///   - lastLabel: 最后一个控件
    ///   - position: 位置 -1:顶部  0:中间  1:底部  2:即使顶部也是底部
    /// - Returns: 内容控件
    private func setTitleAndContent(_ titleStr: String, contentStr: String, lastLabel: UILabel?, position: Int) -> UILabel {
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout { (make) in
                if position == -1 || position == 2 {
                    make.top.equalToSuperview().offset(15)
                } else {
                    make.top.equalTo(lastLabel!.snp.bottom).offset(10)
                }
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
        }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
        }
        
        let contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(3)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                if position == 1 || position == 2 {
                    make.bottom.equalToSuperview().offset(-15)
                }
        }
            .taxi.config { (label) in
                label.text = contentStr
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
        }
        
        return contentLabel
    }
}
