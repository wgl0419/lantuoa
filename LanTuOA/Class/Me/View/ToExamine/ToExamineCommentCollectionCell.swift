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
    /// 图片数据
    var imageData: UIImage? {
        didSet {
            if let image = imageData {
                imageView.image = image
                nameLabel.text = ""
                logoImageView.image = UIImage()
                sizeLabel.text = ""
            }
        }
    }
    /// 文件数据
    var fileName: String? {
        didSet {
            if let fileName = fileName {
                nameLabel.text = fileName
                
                let enclosurePath = AliOSSClient.shared.getCachesPath() + fileName
                let floder = try! FileManager.default.attributesOfItem(atPath: enclosurePath)
                // 用元组取出文件大小属性
                for (key, fileSize) in floder {
                    // 累加文件大小
                    if key == FileAttributeKey.size {
                        let size = (fileSize as AnyObject).integerValue ?? 0
                        var totalCache = Double(size) / 1024.00
                        if totalCache < 1024 {
                            sizeLabel.text = String(format: "%.2fKB", totalCache)
                        } else {
                            totalCache = Double(size) / 1024.00 / 1024.00
                            sizeLabel.text = String(format: "%.2fMB", totalCache)
                        }
                        
                    }
                }
                
                let type = fileName.components(separatedBy: ".").last ?? ""
                if type == "docx" { // word
                    logoImageView.image = UIImage(named: "enclosure_word")
                } else if type == "png" || type == "jpg" || type == "jpeg" { // 图片
                    logoImageView.image = UIImage(named: "enclosure_image")
                } else { // 其他
                    
                }
            }
        }
    }
    
    /// 图片
    private var imageView: UIImageView!
    /// 文件名称
    private var nameLabel: UILabel!
    /// 文件logo
    private var logoImageView: UIImageView!
    /// 大小
    private var sizeLabel: UILabel!
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
                imageView.backgroundColor = UIColor(hex: "#F1F1F1")
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
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 文件名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalTo(imageView).offset(10)
                make.right.equalTo(imageView).offset(-10)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 2
                label.textColor = blackColor
                label.font = UIFont.regular(size: 12)
            })
        
        logoImageView = UIImageView().taxi.adhere(toSuperView: contentView) // logo
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(20)
                make.height.equalTo(16)
                make.left.equalTo(imageView).offset(10)
                make.bottom.equalTo(imageView).offset(-8)
            })
        
        sizeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 文件大小
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(logoImageView.snp.right).offset(5)
                make.bottom.right.equalTo(imageView).offset(-8)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 12)
                label.adjustsFontSizeToFitWidth = true
                label.textColor = UIColor(hex: "#999999")
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
