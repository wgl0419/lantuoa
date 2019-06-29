//
//  ToExamineImageCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批 image cell

import UIKit

class ToExamineImageCell: UITableViewCell {
    
    /// 必选星星
    private var mustLabel: UILabel!
    
    var imageLabel: UILabel!
    var contentLabel: UILabel!
    /// 添加回调
    var imageBlock: (() -> ())?
    /// 删除回调
    var deleteBlock: ((Int) -> ())?
    /// 数据
    var data: [UIImage]! {
        didSet {
            collectionView.reloadData()
            collectionView.snp.updateConstraints { (make) in
                make.height.equalTo(data.count == 0 ? 0 : 53)
            }
        }
    }
    var dataTile: (String, String)? {
        didSet {
            if let dataTile = dataTile {
                let currentCharactorCount = dataTile.1.count
                if currentCharactorCount > 5 {
                    let sub1 = dataTile.1.prefix(5)
                    contentLabel.text = String(sub1) + "..."
                }else{
                    contentLabel.text = dataTile.1
                }
            }
        }
    }
    
    /// 必选(默认非必选)
    var isMust: Bool? {
        didSet {
            if let isMust = isMust {
                mustLabel.isHidden = !isMust
            }
        }
    }

    /// collectionview
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
        contentView.layer.masksToBounds = true
        
         imageLabel = UILabel().taxi.adhere(toSuperView: contentView) // “图片”
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-ScreenWidth/2-40)
        }
            .taxi.config { (label) in
                label.text = "图片"
                label.textColor = blackColor
                label.font = UIFont.regular(size: 16)
        }
        

        
        mustLabel = UILabel().taxi.adhere(toSuperView: contentView) // 必选星星
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(imageLabel)
                make.right.equalTo(imageLabel.snp.left).offset(-3)
            })
            .taxi.config({ (label) in
                label.text = "*"
                label.isHidden = true
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#FF4444")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 点击按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.right.equalToSuperview()
                make.centerY.equalTo(imageLabel)
                make.width.equalTo(53)
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "image"), for: .normal)
                btn.addTarget(self, action: #selector(imageClick), for: .touchUpInside)
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // “内容”
            .taxi.layout { (make) in
                make.left.equalTo(imageLabel.snp.right)
                make.top.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-45)
            }
            .taxi.config { (label) in
                label.text = "提示语言"
                label.textColor = UIColor(hex: "#666666")
                label.font = UIFont.regular(size: 14)
                label.textAlignment = .right
        }
        
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 53, height: 53)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(imageLabel.snp.bottom).offset(4)
                make.bottom.equalToSuperview().offset(-11)
                make.right.equalToSuperview().offset(-15)
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(0)
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.register(ToExamineImageCollectionCell.self, forCellWithReuseIdentifier: "ToExamineImageCollectionCell")
            })
    }
    
    // MARK: - 按钮点击
    /// 点击图标
    @objc private func imageClick() {
        if imageBlock != nil {
            imageBlock!()
        }
    }
}

extension ToExamineImageCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToExamineImageCollectionCell", for: indexPath) as! ToExamineImageCollectionCell
        cell.data = data[indexPath.row]
        cell.deleteBlock = { [weak self] in
            if self?.deleteBlock != nil {
                self?.deleteBlock!(indexPath.row)
            }
        }
        return cell
    }
}
