//
//  NewHomePageVisitCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class NewHomePageVisitCell: UITableViewCell {

    /// CollectionView
    private var collectionView: UICollectionView!
    var selectCollentViewIndex:Int?
    private var titleData = [HomePageNameData]()
    
    var deleteBlack: ((Int)->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle  = .none
        initSubViews()
    }
    
    //数据
    var data: [HomePageNameData]? {
        didSet {
            titleData = []
            if let data = data {
                for model in data {
                    titleData.append(model)
                }
                collectionView.reloadData()
                layoutIfNeeded()
                var collectionHeight = collectionView.contentSize.height
                collectionHeight = collectionHeight == 0 ? 15 : collectionHeight
                collectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(collectionHeight).priority(800)
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        if #available(iOS 9.0, *) {
            let layout = UICollectionViewFlowLayout()
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView
        } else {
            let flowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout) // collectionView
        }
    
        collectionView.taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(200).priority(800)
                make.top.equalToSuperview().offset(5)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                collectionView.register(NewHomePageItmeCell.self, forCellWithReuseIdentifier: "NewHomePageItmeCell")
            })
        let tipsLabel = UILabel().taxi.adhere(toSuperView: contentView) // 提示
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(collectionView.snp.bottom).offset(10)
                make.bottom.equalToSuperview().offset(-0.1)
                make.left.right.equalToSuperview()
            })
    }
    
}

extension NewHomePageVisitCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewHomePageItmeCell", for: indexPath) as! NewHomePageItmeCell
        cell.data = titleData[indexPath.item]
        return cell
    }
    
    //     最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    //    最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenWidth/4  , height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if deleteBlack != nil {
//            deleteBlack!(indexPath.item)
//        }
//        collectionView.reloadData()
    }
    
    
}
