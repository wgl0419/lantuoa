//
//  ToExamineFileImagesCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ToExamineFileImagesCell: UITableViewCell {
    /// 数据
    var titleStr: String! {
        didSet {
            titleLabel.text = titleStr
        }
    }
    
    /// 是否是审批
    var isApproval = false
    /// 图片连接s
    var datas = [NotifyCheckListValue]() {
        didSet {
            
            
            collectionView.reloadData()
            
            layoutIfNeeded()
            var collectionHeight = collectionView.contentSize.height
            collectionHeight = collectionHeight == 0 ? 15 : collectionHeight
            collectionView.snp.updateConstraints { (make) in
                make.height.equalTo(collectionHeight).priority(800)
            }
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        perform(#selector(collectionViewHandle), with: nil, afterDelay: 0.1)
        
    }
    
    /// 处理collectionView高度
    @objc private func collectionViewHandle() {
        collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(collectionView.contentSize.height).priority(800)
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    
    /// collectionView
    private var collectionView: UICollectionView!
    
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
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                //                make.bottom.equalToSuperview().offset(-10).priority(800)
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 14)
                label.textColor = UIColor(hex: "#999999")
            })
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
//        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: ScreenWidth, height: 60)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(200).priority(800)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-15)
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .clear
                collectionView.register(ToMineFileImagesCell.self, forCellWithReuseIdentifier: "ToMineFileImagesCell")
            })
    }
}

extension ToExamineFileImagesCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToMineFileImagesCell", for: indexPath) as! ToMineFileImagesCell
//        cell.isApproval = isApproval
        cell.data = datas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoBrowser = PhotoBrowser()
        
        var array = [(String, String)]()
        for itme in datas {
            let objectName = itme.objectName ?? ""
            let fileName = itme.fileName ?? ""
            let path = isApproval ? "/Approval/\(itme.fileId)/" + fileName : "/Visit/\(itme.fileId)/" + fileName
            array.append((objectName, path))
        }
        photoBrowser.images = array
        photoBrowser.currentIndex = indexPath.row
        photoBrowser.show()
    }
}

class ToMineFileImagesCell: UICollectionViewCell {
    
    /// 删除回调
    var deleteBlock: (() -> ())?
    /// 数据
    var enclosureData: (Data, String)? {
        didSet {
            if let path = enclosureData?.1, let data = enclosureData?.0 {
                sizeLabel.text = "0.00KB"
                nameLabel.text = path
                
                var totalCache = Double(data.count) / 1024.00
                if totalCache < 1024 {
                    sizeLabel.text = String(format: "%.2fKB", totalCache)
                } else {
                    totalCache = Double(data.count) / 1024.00 / 1024.00
                    sizeLabel.text = String(format: "%.2fMB", totalCache)
                }
                
                /// 显示logo
                let type = path.components(separatedBy: ".").last ?? ""
                if type == "docx" {
                    logoImage.backgroundColor = UIColor(hex: "#2E4695")
                    attributeImageView.image = UIImage(named: "word")
                    otherImageView.image = UIImage()
                    attributeLabel.text = "word文档"
                } else if type == "png" || type == "jpg" || type == "jpeg" {
                    otherImageView.image = UIImage(named: "enclosure_image")
                    logoImage.backgroundColor = UIColor(hex: "#F1F1F1")
                    attributeImageView.image = UIImage()
                    attributeLabel.text = ""
                } else {
                    otherImageView.image = UIImage(named: "enclosure_file")
                    logoImage.backgroundColor = UIColor(hex: "#F1F1F1")
                    attributeImageView.image = UIImage()
                    attributeLabel.text = ""
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
                
                let type = (data.fileName ?? "other").components(separatedBy: ".").last ?? ""
                if type == "docx" {
                    logoImage.backgroundColor = UIColor(hex: "#2E4695")
                    attributeImageView.image = UIImage(named: "word")
                    otherImageView.image = UIImage()
                    attributeLabel.text = "word文档"
                } else if type == "png" || type == "jpg" || type == "jpeg" {
                    otherImageView.image = UIImage(named: "enclosure_image")
                    logoImage.backgroundColor = UIColor(hex: "#F1F1F1")
                    attributeImageView.image = UIImage()
                    attributeLabel.text = ""
                } else {
                    otherImageView.image = UIImage(named: "enclosure_file")
                    logoImage.backgroundColor = UIColor(hex: "#F1F1F1")
                    attributeImageView.image = UIImage()
                    attributeLabel.text = ""
                }
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
    /// 文件属性
    private var attributeImageView: UIImageView!
    /// 文件名称
    private var attributeLabel: UILabel!
    /// 其他logo
    private var otherImageView: UIImageView!
    /// 名称
    private var nameLabel: UILabel!
    /// 大小
    private var sizeLabel: UILabel!
    /// 删除按钮
    private var deleteBtn: UIButton!
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
//        initSubViews()
//    }
    
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
        logoImage = UIImageView().taxi.adhere(toSuperView: contentView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview().offset(0)
                make.left.equalToSuperview().offset(15)
                make.width.height.equalTo(47)
                make.top.equalToSuperview()
            })
            .taxi.config({ (imageView) in
                imageView.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        attributeImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 属性图标
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(logoImage.snp.centerY).offset(3)
                make.centerX.equalTo(logoImage)
            })
        
        attributeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 属性文本
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(attributeImageView.snp.bottom).offset(3)
                make.centerX.equalTo(logoImage)
            })
            .taxi.config({ (label) in
                label.textColor = .white
                label.font = UIFont.medium(size: 10)
            })
        
        otherImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 其他logo
            .taxi.layout(snapKitMaker: { (make) in
                make.center.equalTo(logoImage)
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
