//
//  SelePersonnelCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  选择人员  cell

import UIKit

class SelePersonnelCell: UITableViewCell {
    
    /// 数据 （名称  职位  是否选中）
    var data: (String, String, Bool)? {
        didSet {
            if let data = data {
                nameLabel.text = data.0
                positionLabel.text = data.1
                seleBtn.isSelected = data.2
            }
        }
    }
    
    /// 选择图标
    private var seleBtn: UIButton!
    /// 名称
    private var nameLabel: UILabel!
    /// 职位
    private var positionLabel: UILabel!

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
        seleBtn = UIButton().taxi.adhere(toSuperView: contentView) // 选择图标
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(15)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (btn) in
                btn.isUserInteractionEnabled = false
                btn.setImage(UIImage(named: "unsele"), for: .normal)
                btn.setImage(UIImage(named: "sele"), for: .selected)
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(50).priority(800)
                make.left.equalToSuperview().offset(40)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
        
        positionLabel = UILabel().taxi.adhere(toSuperView: contentView) // 职位
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(nameLabel.snp.right).offset(5)
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(nameLabel)
            })
            .taxi.config({ (label) in
                label.textAlignment = .right
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
    }
}
