//
//  HandoverStaffCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  交接员工 cell

import UIKit

class HandoverStaffCell: UITableViewCell {

    /// 项目名称
    private var nameLabel: UILabel!
    /// 交接按钮
    private var handoverBtn: UIButton!
    
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
        handoverBtn = UIButton().taxi.adhere(toSuperView: contentView) // 交接按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(48)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-5)
            })
            .taxi.config({ (btn) in
                btn.setTitle("交接", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(40).priority(800)
                make.left.equalToSuperview().offset(15)
                make.right.equalTo(handoverBtn.snp.right)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
    }
}
