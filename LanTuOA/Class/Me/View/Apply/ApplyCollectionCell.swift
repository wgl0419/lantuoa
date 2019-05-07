//
//  ApplyCollectionCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  申请 collectionViewCell

import UIKit

class ApplyCollectionCell: UICollectionViewCell {
    
    /// 数据
    var data: ProcessListList? {
        didSet {
            if let data = data {
//                4  政策    5  合同内容    6  制作、下单    7  合同条款    8  客户/项目    9  其他
                let imageArray = ["apply_policy", "apply_contract", "apply_make", "apply_clause", "apply_customer", "apply_other"]
                let imageIndex = data.type - 4
                imageView.image = UIImage(named: imageArray[imageIndex])
                titleLabel.text = data.name
            } else {
                imageView.image = UIImage()
                titleLabel.text = ""
            }
        }
    }
    
    /// 图标
    private var imageView: UIImageView!
    /// 标题
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        imageView = UIImageView().taxi.adhere(toSuperView: contentView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview().offset(-50).priority(800)
                make.top.equalToSuperview().offset(12)
                make.height.equalTo(40).priority(800)
                make.centerX.equalToSuperview()
                make.width.equalTo(40)
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().offset(-30).priority(800)
                make.width.equalTo(ScreenWidth / 4 - 31).priority(800)
                make.top.equalTo(imageView.snp.bottom).offset(7)
                make.centerX.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.numberOfLines = 2
                label.textColor = blackColor
                label.textAlignment = .center
                label.minimumScaleFactor = 0.5
                label.font = UIFont.medium(size: 12)
                label.adjustsFontSizeToFitWidth = true
            })
    }
}
