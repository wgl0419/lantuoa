//
//  MeHomeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  “我”模块  首页 cell

import UIKit

class MeHomeCell: UITableViewCell {
    
    /// 数据 (图片 + 标题 + 是否有红点)
    var data: (String, String, Bool)? {
        didSet {
            if let data = data {
                titleLabel.text = data.1
                ImageView.image = UIImage(named: data.0)
                ImageView.isShowRedDot = data.2
            }
        }
    }
    
    /// 图标
    private var ImageView: UIImageView!
    /// 标题
    private var titleLabel: UILabel!

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
        
        ImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(24).priority(800)
                make.bottom.equalToSuperview().offset(-13)
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(13)
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(ImageView.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 15)
            })
    }
}
