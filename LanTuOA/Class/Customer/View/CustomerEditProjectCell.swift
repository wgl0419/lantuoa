//
//  CustomerEditProjectCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户编辑 在线项目 cell

import UIKit

class CustomerEditProjectCell: UITableViewCell {
    
    /// 点击修改回调
    var modifyBolck: (() -> ())?

    /// 项目
    private var projectLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // “在线项目”
            .taxi.layout { (make) in
                make.top.left.equalToSuperview().offset(15)
                make.right.lessThanOrEqualToSuperview().offset(-60)
        }
            .taxi.config { (label) in
                label.text = "在线项目："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        projectLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
                make.bottom.equalToSuperview().offset(-15)
                make.right.lessThanOrEqualToSuperview().offset(-60)
                make.height.greaterThanOrEqualTo(titleLabel).priority(800)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 修改按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.centerY.equalTo(titleLabel)
                make.right.equalToSuperview()
                make.width.equalTo(60)
            })
            .taxi.config({ (btn) in
                btn.setTitle("修改", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(modifyClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击修改
    @objc private func modifyClick() {
        if modifyBolck != nil {
            modifyBolck!()
        }
    }
}
