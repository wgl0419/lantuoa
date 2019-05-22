//
//  ToExamineImageCollectionCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批  image cell

import UIKit

class ToExamineImageCollectionCell: UICollectionViewCell {
    
    /// 删除回调
    var deleteBlock: (() -> ())?
    /// 数据
    var data: UIImage? {
        didSet {
            if let image = data {
                imageView.image = image
            }
        }
    }
    
    /// 图片
    private var imageView: UIImageView!
    
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
        
        imageView = UIImageView().taxi.adhere(toSuperView: contentView) // 图片
            .taxi.layout(snapKitMaker: { (make) in
                make.left.bottom.equalToSuperview()
                make.width.height.equalTo(47)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 删除按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.right.equalToSuperview()
                make.width.height.equalTo(13)
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "input_clear"), for: .normal)
                btn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击删除
    @objc private func deleteClick() {
        if deleteBlock != nil {
            deleteBlock!()
        }
    }
}
