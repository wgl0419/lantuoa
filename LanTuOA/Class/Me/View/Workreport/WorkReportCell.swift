//
//  WorkReportCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class WorkReportCell: UICollectionViewCell {
    
    /// 数据
    var data: WorkReportListData? {
        didSet {
            if let data = data {
                imageView.image = UIImage(named: "汇报")
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
    
//        imageView = UIImageView().taxi.adhere(toSuperView: contentView) // 图标
//            .taxi.layout(snapKitMaker: { (make) in
//                make.bottom.equalToSuperview().offset(-50)
//                make.top.equalToSuperview().offset(12)
//                make.height.equalTo(40)
//                make.centerX.equalToSuperview()
//                make.width.equalTo(40)
//            })
//
//        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
//            .taxi.layout(snapKitMaker: { (make) in
//                make.width.equalToSuperview().offset(-30)
//                make.width.equalTo(ScreenWidth / 4 - 31)
//                make.top.equalTo(imageView.snp.bottom).offset(7)
//                make.centerX.equalToSuperview()
//            })
//            .taxi.config({ (label) in
//                label.numberOfLines = 2
//                label.textColor = blackColor
//                label.textAlignment = .center
//                label.minimumScaleFactor = 0.5
//                label.font = UIFont.medium(size: 12)
//                label.adjustsFontSizeToFitWidth = true
//            })
//    }
    
}
