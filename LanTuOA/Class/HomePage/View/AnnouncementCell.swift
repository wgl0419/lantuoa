//
//  AnnouncementCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class AnnouncementCell: UICollectionViewCell {
    
    var data : filesData? {
        didSet {
            if let data = data {
                contentLabel.text = data.fileName
                let size = data.fileSize
                var totalCache = Double(size) / 1024.00
                if totalCache < 1024 {
                    sizeLabel.text = String(format: "%.2fKB", totalCache)
                } else {
                    totalCache = Double(size) / 1024.00 / 1024.00
                    sizeLabel.text = String(format: "%.2fMB", totalCache)
                }
            }
        }
    }
    
    ///背景
    private var backView : UIImageView!
    /// 内容
    private var contentLabel: UILabel!
    ///图标
    private var fileImage: UIImageView!
    /// 大小
    private var sizeLabel: UILabel!
    
    var deleteBlock: ((Int) -> ())?
    ///下载
    var downloadButton :UIButton!

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
        
        backView = UIImageView().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.equalToSuperview()
                make.width.height.equalTo(80)
            })
            .taxi.config({ (image) in
                image.image = UIImage(named: "组 355")
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: backView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalTo(contentView).offset(10)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(50)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 10)
                label.textColor = UIColor(hex: "#222222")
                label.numberOfLines = 0
                label.text = "蓝图双层公车 隐私合同.doc"
            })
        
        fileImage = UIImageView().taxi.adhere(toSuperView: backView)
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.width.equalTo(16)
                make.height.equalTo(13)
            })
            .taxi.config({ (image) in
                image.image = UIImage(named: "组 318")
            })

        sizeLabel = UILabel().taxi.adhere(toSuperView: backView) // 大小
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.equalTo(32)
                make.bottom.equalToSuperview().offset(-10)
                make.trailing.equalToSuperview()
                make.height.equalTo(13)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 9)
                label.textColor = UIColor(hex: "#999999")
                label.text = "234.87KB"
            })
        
        downloadButton = UIButton().taxi.adhere(toSuperView: contentView) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(30)
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle("点击下载", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.regular(size: 12)
                btn.addTarget(self, action: #selector(downloadClick), for: .touchUpInside)
            })

    }
    
    @objc func downloadClick(sender:UIButton){
        if deleteBlock != nil {
            deleteBlock!(sender.tag)
        }
    }
    
}
