//
//  ToExamineEnclosureTitleCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批 附件标题 cell

import UIKit

class ToExamineEnclosureTitleCell: UITableViewCell {

    /// 点击回调
    var enclosureBlock: (() -> ())?
    
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
        
        let enclosureLabel = UILabel().taxi.adhere(toSuperView: contentView) // “附件”
            .taxi.layout { (make) in
                make.top.equalToSuperview().offset(11)
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-11)
            }
            .taxi.config { (label) in
                label.text = "附件"
                label.textColor = blackColor
                label.font = UIFont.regular(size: 16)
        }
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 点击按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(enclosureLabel)
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "enclosure"), for: .normal)
                btn.addTarget(self, action: #selector(enclosureClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击附件
    @objc private func enclosureClick() {
        if enclosureBlock != nil {
            enclosureBlock!()
        }
    }
}
