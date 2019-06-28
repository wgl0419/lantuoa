//
//  CheckReportHeadItmeCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CheckReportHeadItmeCell: UITableViewCell {
    /// CollectionView
    private var collectionView: UICollectionView!
    var selectCollentViewIndex:Int?
    private var titleData = [[String:String]]()
    
    var deleteBlack: ((String,Int)->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle  = .none
        initSubViews()
    }
    
    //数据
    var data: [[String:String]]! {
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
                collectionView.register(CheckHeadItmeCell.self, forCellWithReuseIdentifier: "CheckHeadItmeCell")
            })
        let tipsLabel = UILabel().taxi.adhere(toSuperView: contentView) // 提示
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(collectionView.snp.bottom).offset(10)
                make.bottom.equalToSuperview().offset(-0.1)
                make.left.right.equalToSuperview()
            })
    }
    
}

extension CheckReportHeadItmeCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckHeadItmeCell", for: indexPath) as! CheckHeadItmeCell
        let dic = titleData[indexPath.item]
        cell.titleLabel.text = dic["name"]
        cell.deleteBlock = { [weak self] in
            let dataDic = self?.titleData[indexPath.item]
            self?.deleteHandle(index: dataDic!["index"]!,indexpath: indexPath.item)
        }
        return cell
    }
    
    /// 处理删除回调
    private func deleteHandle(index: String,indexpath:Int) {
        collectionView.reloadData()
        layoutIfNeeded()
        if deleteBlack != nil {
            deleteBlack!(index,indexpath)
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
    
    //     最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    
    //    最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dic = titleData[indexPath.item]
        let nameWidth = getLabWidth(labelStr:dic["name"] ?? "" , font: UIFont.medium(size: 12), height: 30)
        return CGSize(width: nameWidth + 20  , height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic = titleData[indexPath.item]
        if deleteBlack != nil {
            deleteBlack!(dic["index"]!,indexPath.item)
        }
        collectionView.reloadData()
        
    }
    
    
    //            计算文字宽度
    func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: 315, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: (dic as! [NSAttributedString.Key : Any]) , context:nil).size
        return strSize.width
    }
    
}
