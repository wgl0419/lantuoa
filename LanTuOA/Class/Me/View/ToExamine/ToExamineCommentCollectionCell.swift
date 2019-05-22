//
//  ToExamineCommentCollectionCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批详情  图片cell

import UIKit

class ToExamineCommentCollectionCell: UICollectionViewCell {
    
    // 删除回调
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
    /// 删除按钮
    private var deleteBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    // 初始化子控件
    private func initSubViews() {
        
        imageView = UIImageView().taxi.adhere(toSuperView: contentView) // 图片
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(90)
                make.left.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(7)
                make.right.equalToSuperview().offset(-7)
            })
            .taxi.config({ (imageView) in
            })
        
        deleteBtn = UIButton().taxi.adhere(toSuperView: contentView) // 删除按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(imageView.snp.right)
                make.centerY.equalTo(imageView.snp.top)
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
