//
//  ToExamineDetailsCarbonCopyCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/29.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
// 审核详情  抄送人 cell

import UIKit

class ToExamineDetailsCarbonCopyCell: UITableViewCell {

    
    /// 抄送人数据
    var carbonCopyData: [NotifyCheckUserListData]! {
        didSet {
            collectionView.reloadData()
            
            contentView.layoutIfNeeded()
            collectionView.snp.updateConstraints { (make) in
                make.height.equalTo(collectionView.contentSize.height)
            }
        }
    }
    
    /// collectinView
    private var collectionView: UICollectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(44).priority(800)
                make.top.equalToSuperview()
        }
            .taxi.config { (label) in
                label.text = "抄送人"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionview
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(0)
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                collectionView.register(FillInApplyApprovalCollectionCell.self, forCellWithReuseIdentifier: "FillInApplyApprovalCollectionCell")
                collectionView.register(FillInApplyArrowCollectionCell.self, forCellWithReuseIdentifier: "FillInApplyArrowCollectionCell")
            })
    }
}

extension ToExamineDetailsCarbonCopyCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carbonCopyData.count == 1 ? 2 : carbonCopyData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        if carbonCopyData.count == 1 && row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyArrowCollectionCell", for: indexPath) as! FillInApplyArrowCollectionCell
            cell.show = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyApprovalCollectionCell", for: indexPath) as! FillInApplyApprovalCollectionCell
            cell.detailsData = carbonCopyData[row]
            return cell
        }
    }
}
