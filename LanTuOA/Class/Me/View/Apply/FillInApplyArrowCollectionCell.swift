//
//  FillInApplyArrowCollectionCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/19.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请  箭头 collectionViewCell

import UIKit

class FillInApplyArrowCollectionCell: UICollectionViewCell {
    
    var show: Bool = false {
        didSet {
            arrowImageView.isHidden = show
        }
    }
    
    /// 箭头
    private var arrowImageView: UIImageView!
    
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
        arrowImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 箭头
            .taxi.layout(snapKitMaker: { (make) in
//                make.top.equalToSuperview().offset(16).priority(800)
//                make.left.right.equalToSuperview()
//                make.centerX.equalToSuperview()
//                make.centerY.equalToSuperview()
                make.top.equalToSuperview().offset(16).priority(800)
                make.bottom.equalToSuperview().offset(-35)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "apply_arrow")
            })
    }
}
