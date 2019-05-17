//
//  JobHandoverCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作交接 cell

import UIKit

class JobHandoverCell: UITableViewCell {
    
    /// 数据
    var data: WorkExtendListData? {
        didSet {
            if let data = data {
                nameLabel.text = preventEmpty(data.realname)
                departmentLabel.text = preventEmpty(data.departmentName)
                phoneLabel.text = preventEmpty(data.phone)
                jobLabel.text = preventEmpty(data.projects)
                leavingCompanyImageView.isHidden = data.status == 1
            }
        }
    }

    /// 名字
    private var nameLabel: UILabel!
    /// 离职图标
    private var leavingCompanyImageView: UIImageView!
    /// 部门
    private var departmentLabel = UILabel()
    /// 手机号
    private var phoneLabel = UILabel()
    /// 交接工作
    private var jobLabel = UILabel()
    /// 交接状态
    private var statusLabel: UILabel!
    
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
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名字
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(13)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#2E4695")
            })
        
        leavingCompanyImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 离职图标
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-5)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "leavingCompany")
            })
        
        statusLabel = UILabel().taxi.adhere(toSuperView: contentView) // 交接状态
            .taxi.layout(snapKitMaker: { (make) in
                make.right.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.text = "测测测测测测"
                label.font = UIFont.regular(size: 12)
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
        
        _ = setTitle(titleStr: "所属部门：", contentLabel: departmentLabel, lastView: nameLabel) // 部门
        _ = setTitle(titleStr: "手机号码：", contentLabel: phoneLabel, lastView: departmentLabel) // 手机号码
        _ = setTitle(titleStr: "交接工作：", contentLabel: jobLabel, lastView: phoneLabel, isLast: true) // 交接工作
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题内容
    ///   - contentLabel: 内容文本
    ///   - lastView: 跟随控件
    ///   - isLast: 是否是最后一个
    /// - Returns: 标题控件
    private func setTitle(titleStr: String, contentLabel: UILabel, lastView: UIView, isLast: Bool = false) -> UILabel {
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
        contentView.addSubview(contentLabel) // 内容
        
        titleLabel.taxi.layout { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(lastView.snp.bottom).offset(5)
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
            make.right.lessThanOrEqualTo(statusLabel.snp.left).offset(-5)
            if isLast {
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
        return " "
    }
}
