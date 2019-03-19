//
//  SeleVisitModelCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/19.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class SeleVisitModelCell: UITableViewCell {
    
    /// 数据 (内容文本  颜色)
    var data: (String, UIColor)? {
        didSet {
            if let data = data {
                contentLabel.text = data.0
                contentLabel.textColor = data.1
            }
        }
    }
    
    /// 内容
    private var contentLabel: UILabel!

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
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(56).priority(800)
            })
            .taxi.config({ (label) in
                label.textAlignment = .center
                label.font = UIFont.medium(size: 16)
            })
    }
}
