//
//  ToExamineImagesCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  下载图片 collectionview

import UIKit

class ToExamineImagesCell: UITableViewCell {
    
    /// 图片连接s
    var datas = [NotifyCheckListValue]() {
        didSet {
            collectionView.reloadData()
        }
    }
    /// 是评论
    var isComment: Bool! {
        didSet {
            collectionView.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(isComment ? 33 : 15)
            }
        }
    }
    
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
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(60)
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-10)
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .clear
                collectionView.register(ToExamineImagesCollectionCell.self, forCellWithReuseIdentifier: "ToExamineImagesCollectionCell")
            })
    }
}

extension ToExamineImagesCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToExamineImagesCollectionCell", for: indexPath) as! ToExamineImagesCollectionCell
        cell.data = datas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoBrowser = PhotoBrowser()
        
        var array: Array<String> = []
        for itme in datas {
            array.append(itme.objectName ?? "")
        }
        photoBrowser.images = array
        photoBrowser.currentIndex = indexPath.row
        photoBrowser.show()
    }
}


class ToExamineImagesCollectionCell: UICollectionViewCell {
    
    /// 图片链接
    var data: NotifyCheckListValue? {
        didSet {
            if let data = data {
                AliOSSClient.shared.download(url: data.objectName ?? "", isCache: true) { (data) in
                    var defaultImage = UIImage(named: "image_default")
                    if data != nil {
                        defaultImage = UIImage(data: data!) ?? defaultImage
                    }
                    DispatchQueue.main.async(execute: {
                        self.imageView.image = defaultImage
                    })

                }
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
                make.edges.equalToSuperview()
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "image_default")
            })
    }
}
