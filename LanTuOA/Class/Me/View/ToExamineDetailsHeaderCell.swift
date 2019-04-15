//
//  ToExamineDetailsHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ToExamineDetailsHeaderCell: UITableViewCell {
    
    /// 数据
    var data: String? {
        didSet {
            if let data = data {
                titleLabel.text = data
            }
        }
    }
    
    /// 审核标题
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
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 18)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 蓝色块
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(titleLabel)
                make.left.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
    }
}
