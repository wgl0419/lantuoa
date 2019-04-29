//
//  MeHomeHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  “我”模块  首页 顶部cell

import UIKit

class MeHomeHeaderCell: UITableViewCell {
    
    /// 名称
    private var nameLabel: UILabel!
    
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
        backgroundColor = .white
        
        let whiteView = UIView().taxi.adhere(toSuperView: contentView) // 白色背景的cell
            .taxi.layout { (make) in
                make.right.equalToSuperview().offset(-15).priority(800)
                make.top.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-22)
                make.height.equalTo(100).priority(800)
        }
            .taxi.config { (view) in
                view.layer.borderWidth = 1
                view.layer.cornerRadius = 4
                view.layer.shadowRadius = 10
                view.layer.shadowOpacity = 1
                view.backgroundColor = .white
                view.layer.borderColor = UIColor(hex: "#D8D8D8", alpha: 0.6).cgColor
                view.layer.shadowColor = UIColor(hex: "#666666", alpha: 0.2).cgColor
                view.layer.shadowOffset = CGSize(width: 0, height: 5)
        }
        
        
        nameLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 名字
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.text = UserInfo.share.userName
                label.font = UIFont.boldSystemFont(ofSize: 18)
            })
        
        _ = UIImageView().taxi.adhere(toSuperView: whiteView) // 箭头
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "arrow")
            })
    }
}

