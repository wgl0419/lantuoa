//
//  CheckReportTimeScreenCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CheckReportTimeScreenCell: UITableViewCell {
    
    /// 数据(标题+提示文本)
    var data: (String, String)? {
        didSet {
            if let data = data {
                titleLabel.text = data.0
                placeholderLabel.text = data.1
            }
        }
    }
    /// 数据(标题+提示文本)
    var attriData: (NSMutableAttributedString, String)? {
        didSet {
            if let data = attriData {
                titleLabel.attributedText = data.0
                placeholderLabel.text = data.1
            }
        }
    }
    /// 内容
    var contentStr: String? {
        didSet {
            if let str = contentStr {
                contentLabel.text = str
                showHandle()
            }
        }
    }
    /// 富文本内容
    var attriMuStr: NSMutableAttributedString? {
        didSet {
            if let str = attriMuStr {
                contentLabel.attributedText = str
                showHandle()
            }
        }
    }
    
    
    /// 标题
    var titleLabel: UILabel!
    /// 提示
    var placeholderLabel: UILabel!
    /// 内容
    var contentLabel: UILabel!
    
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
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
        titleLabel.taxi.layout { (make) in
            make.top.left.equalTo(contentView).offset(15)
            make.right.greaterThanOrEqualTo(contentLabel.snp.left).offset(-8)
            }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
        }
        
        contentLabel.taxi.layout { (make) in
            make.top.equalTo(contentView).offset(15)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-15)
            make.height.greaterThanOrEqualTo(titleLabel).priority(800)
            
            make.left.equalTo(titleLabel.snp.right).offset(8).priority(800)
            make.left.greaterThanOrEqualTo(contentView).offset(100)
            }
            .taxi.config { (label) in
                label.isHidden = true
                label.numberOfLines = 0
                label.textAlignment = .right
                label.textColor = blackColor
                label.lineBreakMode = .byCharWrapping
                label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        placeholderLabel = UILabel().taxi.adhere(toSuperView: contentView) // 提示
            .taxi.layout(snapKitMaker: { (make) in
                make.top.right.bottom.equalTo(contentView)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 14)
                label.text = "请选择"
                label.textColor = UIColor(hex: "#CACACA")
            })
    }
    
    /// 处理显示
    private func showHandle() {
        let str = contentLabel.text ?? ""
        let attriMuStr = contentLabel.attributedText?.string ?? ""
        let show = str.count > 0 || attriMuStr.count > 0
        contentLabel.isHidden = !show
        placeholderLabel.isHidden = show
    }
}
