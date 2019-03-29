//
//  HandoverStaffHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  交接员工 顶部 cell

import UIKit

class HandoverStaffHeaderCell: UITableViewCell {

    /// 名称
    private var nameLabel: UILabel!
    /// 部门
    private var departmentLabel = UILabel()
    /// 手机
    private var phoneLabel = UILabel()
    
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
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = " "
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 18)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 蓝色标记块
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(nameLabel)
                make.left.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(3)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        let department = setTitle(titleStr: "所属部门：", contentLabel: departmentLabel, lastView: nameLabel) // 所属部门
        _ = setTitle(titleStr: "手机号码：", contentLabel: phoneLabel, lastView: department, isLast: true) // 手机号码
        
        _ = UIView().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.right.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
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
            if isLast {
                make.bottom.equalToSuperview().offset(-15)
            }
            make.right.lessThanOrEqualTo(contentLabel)
            }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
        }
        
        contentLabel.taxi.layout { (make) in
            make.top.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right)
            make.right.lessThanOrEqualToSuperview().offset(-15)
            }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
        }
        
        return titleLabel
    }
}
