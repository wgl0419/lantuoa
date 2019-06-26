//
//  CheckReportTemplateFilterCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/25.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CheckReportTemplateFilterCell: UITableViewCell {
    
    /// CollectionView
    private var collectionView: UICollectionView!
    var selectCollentViewIndex:Int?
    /// 标题
    private var titleLabel: UILabel!
    private var titleData = [WorkReportListData]()

    var templateBlack: ((Int)->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle  = .none
        selectCollentViewIndex = -1
        initSubViews()
    }
    
    //数据
    var data: [WorkReportListData]! {
        didSet {
            titleData = []
            if let data = data {
                for model in data {
                    titleData.append(model)
                }
                titleLabel.text = "按模版筛选"
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
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(10)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#999999")
                label.font = UIFont.medium(size: 12)
            })
        
        
        if #available(iOS 9.0, *) {
            let layout = UICollectionViewFlowLayout()
//            layout.minimumLineSpacing = 5
//            layout.minimumInteritemSpacing = 5
//            layout.estimatedItemSize = CGSize(width: 50, height: 50)
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView
        } else {
            let flowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
//            flowLayout.minimumLineSpacing = 5
//            flowLayout.minimumInteritemSpacing = 5
//            flowLayout.estimatedItemSize = CGSize(width: 100, height: 44)
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout) // collectionView
        }
        
        collectionView.taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(200).priority(800)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                collectionView.register(TemplateFilterCell.self, forCellWithReuseIdentifier: "TemplateFilterCell")
            })
       let tipsLabel = UILabel().taxi.adhere(toSuperView: contentView) // 提示
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(collectionView.snp.bottom)
                make.bottom.equalToSuperview().offset(-0.1)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textAlignment = .center
                label.font = UIFont.regular(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
    }

}

extension CheckReportTemplateFilterCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateFilterCell", for: indexPath) as! TemplateFilterCell
        cell.isSelect = selectCollentViewIndex == indexPath.item
        cell.data = titleData[indexPath.item]
        return cell
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
        let nameWidth = getLabWidth(labelStr:titleData[indexPath.item].name ?? "" , font: UIFont.medium(size: 12), height: 30)
        return CGSize(width: nameWidth + 10  , height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCollentViewIndex = indexPath.item
        if templateBlack != nil {
            templateBlack!(titleData[indexPath.item].id)
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

