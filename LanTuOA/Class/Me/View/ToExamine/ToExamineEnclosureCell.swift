//
//  ToExamineEnclosureCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批 附件 cell

import UIKit

class ToExamineEnclosureCell: UITableViewCell {
    
    /// 删除回调
    var deleteBlock: (() -> ())?
    /// 数据
    var path: String? {
        didSet {
            if let path = path {
                sizeLabel.text = "0.00KB"
                nameLabel.text = path
                
                let enclosurePath = AliOSSClient.shared.getCachesPath() + path
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
            }
        }
    }
    var data: NotifyCheckListValue! {
        didSet {
            if let data = data {
                let size = data.fileSize
                var totalCache = Double(size) / 1024.00
                if totalCache < 1024 {
                    sizeLabel.text = String(format: "%.2fKB", totalCache)
                } else {
                    totalCache = Double(size) / 1024.00 / 1024.00
                    sizeLabel.text = String(format: "%.2fMB", totalCache)
                }
                nameLabel.text = data.fileName ?? ""
            }
        }
    }
    /// 是显示删除按钮
    var isDelete: Bool! = true {
        didSet {
            logoImage.snp.updateConstraints { (make) in
                make.width.height.equalTo(60)
            }
            deleteBtn.isHidden = !isDelete
        }
    }
    /// 是否是评论
    var isComment: Bool? {
        didSet {
            if let isComment = isComment {
                logoImage.snp.updateConstraints { (make) in
                    make.left.equalToSuperview().offset(isComment ? 33 : 15)
                }
            }
        }
    }
    
    /// 图标
    private var logoImage: UIImageView!
    /// 名称
    private var nameLabel: UILabel!
    /// 大小
    private var sizeLabel: UILabel!
    /// 删除按钮
    private var deleteBtn: UIButton!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        logoImage = UIImageView().taxi.adhere(toSuperView: contentView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview().offset(-10)
                make.left.equalToSuperview().offset(15)
                make.width.height.equalTo(47)
                make.top.equalToSuperview()
            })
            .taxi.config({ (imageView) in
                imageView.backgroundColor = .blue
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(logoImage.snp.centerY).offset(-2)
                make.left.equalTo(logoImage.snp.right).offset(10)
                make.right.equalToSuperview().offset(-25)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.regular(size: 16)
            })
        
        sizeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 大小
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(logoImage.snp.right).offset(10)
                make.top.equalTo(logoImage.snp.centerY).offset(2)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
        
        deleteBtn = UIButton().taxi.adhere(toSuperView: contentView) // 删除按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.width.height.equalTo(13)
                make.centerY.equalTo(logoImage)
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
