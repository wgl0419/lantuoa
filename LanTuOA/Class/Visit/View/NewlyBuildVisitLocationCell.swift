//
//  NewlyBuildVisitLocationCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class NewlyBuildVisitLocationCell: UITableViewCell {
    
    /// 位置
    var addressStr: String? {
        didSet {
            if let addressStr = addressStr {
                contentLabel.text = addressStr
            }
        }
    }
    
    private var titleLabel : UILabel!
    private var contentLabel : UILabel!
    private var locationImage : UIImageView!
    
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
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalTo(contentView).offset(15)
                make.trailing.equalToSuperview().offset(-30)
                make.height.equalTo(17)
            })
            .taxi.config { (label) in
                label.textColor = UIColor(hex: "#666666")
                label.font = UIFont.medium(size: 16)
                label.text = "所在位置"
        }
        
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(43).priority(800)
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.bottom.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 15)
            })
        
        locationImage = UIImageView().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.trailing.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(15)
                make.width.equalTo(16)
                make.height.equalTo(20)
            })
            .taxi.config({ (image) in
                image.image = UIImage(named: "定位")
            })
        
    }
    
}
