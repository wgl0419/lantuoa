//
//  CheckReportDetailsReadCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/25.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CheckReportDetailsReadCell: UITableViewCell {
    
    /// 添加回调
    var addBlock: (() -> ())?
    /// 点击删除回调
    var deleteBlock: ((Int) -> ())?
    /// 是审批人
    var isApproval: Bool!
    /// 原本的抄送人数量
    var oldCount = 0
    
    var moreBlock: (() -> ())?
    
    /// CollectionView
    private var collectionView: UICollectionView!
    /// 标题
    private var titleLabel: UILabel!
    /// 无审批人提示
//    private var tipsLabel: UILabel!
    private var line: UIView!
    var btnArr = [UIButton]()
    let bottomLine = UIView()
    var moreBtn: UIButton!
    var rightImage :UIImageView!
    var haveReadData : [NotifyCheckUserListData]!
    var didReadData : [NotifyCheckUserListData]!
    var isRead = 0
    /// 抄送人数据
    var carbonCopyData: [NotifyCheckUserListData]! {
        didSet {
            haveReadData.removeAll()
            didReadData.removeAll()
            for index in 0..<carbonCopyData.count {
                let model = carbonCopyData[index]
                
                if model.status == 2 {
                    haveReadData.append(model)
                }
                if model.status == 1 {
                    didReadData.append(model)
                }
            }
            btnArr[0].setTitle("已读(\(haveReadData.count))", for: .normal)
            btnArr[1].setTitle("未读(\(didReadData.count))", for: .normal)
            collectionView.reloadData()
            layoutIfNeeded()
            var collectionHeight = collectionView.contentSize.height
            collectionHeight = collectionHeight == 0 ? 15 : collectionHeight
            collectionView.snp.updateConstraints { (make) in
                make.height.equalTo(collectionHeight).priority(800)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        haveReadData = []
        didReadData = []
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {

//        moreBtn = UIButton().taxi.adhere(toSuperView: contentView)
//            .taxi.layout(snapKitMaker: { (make) in
//                make.trailing.equalToSuperview().offset(-20)
//                make.top.equalToSuperview()
//                make.width.equalTo(60)
//                make.height.equalTo(40)
//            })
//            .taxi.config({ (button) in
//                button.setTitle("查看更多", for: .normal)
//                button.setTitleColor(UIColor(hex: "#999999"), for: .normal)
//                button.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
//                button.titleLabel?.font = UIFont.regular(size: 14)
//            })
//        rightImage = UIImageView().taxi.adhere(toSuperView: contentView)
//            .taxi.layout(snapKitMaker: { (make) in
//                make.trailing.equalToSuperview().offset(-10)
//                make.top.equalToSuperview().offset(16)
//                make.width.equalTo(6)
//                make.height.equalTo(8)
//            })
//            .taxi.config({ (image) in
//                image.image = UIImage(named: "arrow")
//            })
        
        let arr = ["已读","未读"]
        for index in 0..<arr.count {
            let btn = UIButton()
            btn.frame = CGRect(x: 60*index, y: 0, width: 50, height: 38)
            btn.setTitle(arr[index], for: .normal)
            btn.titleLabel?.font = UIFont.medium(size: 14)
            btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            if index == 0 {
                btn.setTitleColor(UIColor(hex: "#222222"), for: .normal)
            }else{
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
            }
            btnArr.append(btn)
            contentView.addSubview(btn)
        }
        bottomLine.frame = CGRect(x: 10, y: 38, width: 30, height: 1.5)
        bottomLine.backgroundColor = kMainColor
        contentView.addSubview(bottomLine)
        line = UIView().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(39.5)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(0.5)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionview
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(200).priority(800)
                make.top.equalTo(line.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
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
    
    @objc func btnAction(sender:UIButton){
        if sender == btnArr[0]{
            sender.setTitleColor(UIColor(hex: "#222222"), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.bottomLine.frame = CGRect(x: 10, y: 38, width: 30, height: 1.5)
            }
            btnArr[1].setTitleColor(UIColor(hex: "#999999"), for: .normal)
            isRead = 0
            collectionView.reloadData()
        }else{
            btnArr[0].setTitleColor(UIColor(hex: "#999999"), for: .normal)
            sender.setTitleColor(UIColor(hex: "#222222"), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.bottomLine.frame = CGRect(x: 70, y: 38, width: 30, height: 1.5)
            }
            isRead = 1
            collectionView.reloadData()
        }
        
    }
    
    @objc func moreAction(){
        if moreBlock != nil  {
            moreBlock!()
        }
    }
    
}

extension CheckReportDetailsReadCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isRead == 0 {
            return haveReadData.count == 1 ? 2 : haveReadData.count
        }else{
            return didReadData.count == 1 ? 2 : didReadData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        if isRead == 0 {
            if haveReadData.count == 1 && row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyArrowCollectionCell", for: indexPath) as! FillInApplyArrowCollectionCell
                cell.show = true
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyApprovalCollectionCell", for: indexPath) as! FillInApplyApprovalCollectionCell
                cell.isCanDelete = false
                cell.detailsData = haveReadData[row]
                return cell
            }
        }else{
            if didReadData.count == 1 && row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyArrowCollectionCell", for: indexPath) as! FillInApplyArrowCollectionCell
                cell.show = true
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyApprovalCollectionCell", for: indexPath) as! FillInApplyApprovalCollectionCell
                cell.isCanDelete = false
                cell.detailsData = didReadData[row]
                return cell
            }
        }

    }
}

