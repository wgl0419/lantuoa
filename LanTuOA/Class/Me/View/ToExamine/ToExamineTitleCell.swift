//
//  ToExamineTitleCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批标题 cell

import UIKit

class ToExamineTitleCell: UITableViewCell {
    
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
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(60)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
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

extension ToExamineTitleCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToExamineImagesCollectionCell", for: indexPath) as! ToExamineImagesCollectionCell
        cell.isApproval = isApproval
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
