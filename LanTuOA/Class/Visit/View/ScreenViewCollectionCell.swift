//
//  ScreenViewCollectionCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/5.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  筛选 collectionviewcell

import UIKit

class ScreenViewCollectionCell: UICollectionViewCell {
    
    /// 删除回调
    var deleteBlock: (() -> ())?
    /// 内容
    var str: String? {
        didSet {
            if let str = str {
                /// 内容宽
                let labelWidth = str.getTextSize(font: UIFont.boldSystemFont(ofSize: 12), maxSize: CGSize(width: ScreenWidth, height: 24)).width
                contentLabel.text = str
                contentLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(labelWidth + 20).priority(800)
                }
                contentLabel.isHidden = false
                deleteBtn.isHidden = false
            } else {
                contentLabel.isHidden = true
                deleteBtn.isHidden = true
            }
        }
    }
    
    /// 内容
    private var contentLabel: UILabel!
    /// 删除按钮
    private var deleteBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义自有方法
    /// 初始化子控件
    private func initSubViews() {
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(10).priority(800)
                make.height.equalTo(24).priority(800)
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 12)).priority(800) // 添加删除按钮的位置
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.layer.cornerRadius = 4
                label.textAlignment = .center
                label.layer.masksToBounds = true
                label.font = UIFont.boldSystemFont(ofSize: 12)
                label.backgroundColor = UIColor(hex: "#F1F1F1")
            })
        
        deleteBtn = UIButton().taxi.adhere(toSuperView: contentView) // 删除按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(contentLabel.snp.right)
                make.centerY.equalTo(contentLabel.snp.top)
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
        if str != nil {
            if deleteBlock != nil {
                deleteBlock!()
            }
        }
    }
}
