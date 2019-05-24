//
//  ToExamineTitleCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批标题 cell

import UIKit

class ToExamineTitleCell: UITableViewCell {
    
    /// 数据
    var titleStr: String! {
        didSet {
            titleLabel.text = titleStr
        }
    }

    /// 标题
    private var titleLabel: UILabel!
    
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
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview().offset(-10).priority(800)
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 14)
                label.textColor = UIColor(hex: "#999999")
            })
    }
}
