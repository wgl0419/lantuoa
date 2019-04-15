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
//                imageView.image =  // TODO: 根据Type 使用不同的本地图标
                titleLabel.text = data.name
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
                make.centerX.equalToSuperview()
                make.width.height.equalTo(40).priority(800)
            })
            .taxi.config({ (imageView) in
                imageView.backgroundColor = .blue
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(7)
                make.width.equalToSuperview().offset(-30).priority(800)
                make.centerX.equalToSuperview()
                make.width.equalTo(70).priority(800)
            })
            .taxi.config({ (label) in
                label.text = "双层车喷绘通知单"
                label.numberOfLines = 2
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.medium(size: 12)
            })
    }
}
