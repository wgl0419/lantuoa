//
//  NewlyBuildSeleCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  新建选择 cell

import UIKit

class NewlyBuildSeleCell: UITableViewCell {

    var data: (String, Bool)? {
        didSet {
            if let data = data {
                contentLabel.text = data.0
                seleImageView.image = UIImage(named: data.1 ? "sele" : "unsele")
            }
        }
    }
    
    /// 选中图标
    private var seleImageView: UIImageView!
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
        
        seleImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 选中图标
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(15)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(50).priority(800)
                make.right.equalToSuperview().offset(-15)
                make.left.equalTo(seleImageView.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
            })
    }
}
