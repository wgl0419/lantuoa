//
//  ApplyHistoryCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ApplyHistoryCell: UITableViewCell {

    
    /// 数据
    var data: ProcessHistoryData? {
        didSet {
            if let data = data {
                let name = data.name ?? ""
                nameLabel.text = name.count == 0 ? " " : name
                let content = data.content ?? ""
                contentLabel.text = content.count == 0 ? " " : content
                let check_users = data.check_users ?? ""
                checkNameLabel.text = check_users.count == 0 ? " " : check_users
                let statusStr = data.status == 1 ? "申请中" : data.status == 2 ? "已通过" : "未通过"
                let statusColor = data.status == 1 ? UIColor(hex: "#2E4695") : data.status == 2 ? UIColor(hex: "#5FB9A1") : UIColor(hex: "#FF4444")
                let newStatusStr = data.status == 1 ? "审批中" : data.status == 2 ? "已同意" : "未拒绝"
                statusLabel.text = statusStr
                statusLabel.textColor = statusColor
                newStatusLabel.text = (data.check_users ?? "") + newStatusStr
            }
        }
    }
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 名称
    private var nameLabel: UILabel!
    /// 内容
    private var contentLabel = UILabel()
    /// 处理人
    private var checkNameLabel = UILabel()
    /// 当前状态
    private var newStatusLabel = UILabel()
    /// 状态
    private var statusLabel: UILabel!
    
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
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-8)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                
                view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
                view.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.16).cgColor
                view.layer.shadowRadius = 3
                view.layer.cornerRadius = 4
                view.layer.shadowOpacity = 1
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-55)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 蓝色块
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview()
                make.centerY.equalTo(nameLabel)
                make.height.equalTo(18)
                make.width.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        statusLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 状态
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(nameLabel)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 12)
            })
        
        _ = setTitle(titleStr: "申请内容：", contentLabel: contentLabel, lastView: nameLabel, position: -1)
        _ = setTitle(titleStr: "当前处理人：", contentLabel: checkNameLabel, lastView: contentLabel)
        _ = setTitle(titleStr: "当前状态：", contentLabel: newStatusLabel, lastView: checkNameLabel, position: 1)
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题内容
    ///   - contentLabel: 内容文本
    ///   - lastView: 跟随控件
    ///   - position: 位置 (-1顶部  0中间部分 1底部)
    /// - Returns: 标题控件
    private func setTitle(titleStr: String, contentLabel: UILabel, lastView: UIView, position: Int = 0) -> UILabel {
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
        whiteView.addSubview(contentLabel) // 内容
        
        titleLabel.taxi.layout { (make) in
            make.left.equalToSuperview().offset(15)
            if position == -1 {
                make.top.equalTo(lastView.snp.bottom).offset(15)
            } else {
                make.top.equalTo(lastView.snp.bottom).offset(5)
            }
        }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        contentLabel.taxi.layout { (make) in
            make.top.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right)
            make.right.lessThanOrEqualToSuperview().offset(-15)
            if position == 1 {
                make.bottom.equalToSuperview().offset(-15)
            }
        }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        return titleLabel
    }
}
