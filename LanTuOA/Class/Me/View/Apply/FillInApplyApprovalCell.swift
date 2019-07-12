//
//  FillInApplyApprovalCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/19.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请  审批人  cell

import UIKit

class FillInApplyApprovalCell: UITableViewCell {
    
    /// 添加回调
    var addBlock: (() -> ())?
    /// 点击删除回调
    var deleteBlock: ((Int) -> ())?
    /// 是审批人
    var isApproval: Bool!
    /// 原本的抄送人数量
    var oldCount = 0
    /// 数据
    var data: [ProcessUsersCheckUsers]! {
        didSet {
            dataHandle()
        }
    }
    var isProcess: Bool! {
        didSet {
//            let str = isProcess ? "" : "本流程有节点缺失审批人，请联系管理员覃甲修改设置"
//            let attriMuStr = NSMutableAttributedString(string: str)
//            attriMuStr.changeFont(str: "覃甲", font: UIFont.medium(size: 12))
//            attriMuStr.changeColor(str: "覃甲", color: UIColor(hex: "#2E4695"))
//            tipsLabel.attributedText = attriMuStr
            let str = isProcess ? "" : "本流程有节点缺失审批人，请联系管理员修改设置"
            tipsLabel.text = str
        }
    }
    
    /// CollectionView
    private var collectionView: UICollectionView!
    /// 标题
    private var titleLabel: UILabel!
    /// 无审批人提示
    private var tipsLabel: UILabel!
    
    /// 处理过的数据
    private var processedData = [[ProcessUsersCheckUsers]]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(10)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
            })
        
        
        if #available(iOS 9.0, *) {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.estimatedItemSize = CGSize(width: 50, height: 50)
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView
        } else {
            let flowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.estimatedItemSize = CGSize(width: 100, height: 44)
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout) // collectionView
        }
        
        collectionView.taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(200).priority(800)
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                collectionView.register(FillInApplyApprovalCollectionCell.self, forCellWithReuseIdentifier: "FillInApplyApprovalCollectionCell")
                collectionView.register(FillInApplyArrowCollectionCell.self, forCellWithReuseIdentifier: "FillInApplyArrowCollectionCell")
                collectionView.register(FillInApplyCarbonCopyAddCell.self, forCellWithReuseIdentifier: "FillInApplyCarbonCopyAddCell")
            })
        
        tipsLabel = UILabel().taxi.adhere(toSuperView: contentView) // 提示
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(collectionView.snp.bottom)
                make.bottom.equalToSuperview().offset(-10)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textAlignment = .center
                label.font = UIFont.regular(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
    }
    
    /// 数据处理
    private func dataHandle() {
//        processedData = []
//        if !isApproval { // 抄送人不需要处理
//            titleLabel.text = "抄送人（审批发起和通过时，通知抄送人）"
//            for model in data {
//                processedData.append([model])
//            }
//        } else { // 审批人 需要处理
//            titleLabel.text = "审批人"
//            var newData = data!
//
//            if newData.count > 0 {
//                newData.sort { (model1, model2) -> Bool in // 数据排序
//                    return model1.sort < model2.sort
//                }
//
//                for index in 1...newData.count {
//                    let newModel = newData.filter { (model) -> Bool in
//                        return model.sort == index
//                    }
//                    if newModel.count != 0 {
//                        processedData.append(newModel)
//
//                    }
//
//                }
//
//            }
//        }
//
        
        processedData = []
        if !isApproval { // 抄送人不需要处理
            titleLabel.text = "抄送人（审批发起和通过时，通知抄送人）"
            for model in data {
                processedData.append([model])
            }
        } else { // 审批人 需要处理
            titleLabel.text = "审批人"
            var newData = data!
            
            if newData.count > 0 {
                newData.sort { (model1, model2) -> Bool in // 数据排序
                    return model1.sort < model2.sort
                }
                
                for index in 1...newData.count {
                    let newModel = newData.filter { (model) -> Bool in
                        return model.sort == index
                    }
                    if newModel.count != 0 {
                        processedData.append(newModel)

                    }
                }
                
                for  model in newData {
                    if model.checkUserId == 0 {
                        processedData.append([model])
                    }
                }
            }
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

extension FillInApplyApprovalCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isApproval == nil {
            return 0
        }
        if isApproval {
            if processedData.count == 1 {
                return 2
            } else {
                return processedData.count * 2 - 1
            }
        } else {
            return processedData.count == 0 ? 2 : processedData.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isApproval {
            if indexPath.row % 2 == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyApprovalCollectionCell", for: indexPath) as! FillInApplyApprovalCollectionCell
                cell.isCanDelete = false
                let row = indexPath.row / 2
                cell.data = processedData[row]
                
                return cell
            } else { // 箭头
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyArrowCollectionCell", for: indexPath) as! FillInApplyArrowCollectionCell
                cell.show = processedData.count == 1
                return cell
            }
        } else {
            let row = indexPath.row
            if processedData.count == 0 && row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyArrowCollectionCell", for: indexPath) as! FillInApplyArrowCollectionCell
                cell.show = true
                return cell
            } else if row == processedData.count || processedData.count == 0 { // 添加按钮
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyCarbonCopyAddCell", for: indexPath) as! FillInApplyCarbonCopyAddCell
                cell.addBlock = { [weak self] in
                    if self?.addBlock != nil {
                        self?.addBlock!()
                    }
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FillInApplyApprovalCollectionCell", for: indexPath) as! FillInApplyApprovalCollectionCell
                cell.isCanDelete = indexPath.row >= oldCount // 是否能删除
                cell.data = processedData[row]
                cell.deleteBlock = { [weak self] in
                    if self?.deleteBlock != nil {
                        self?.deleteBlock!(row)
                    }
                }
                return cell
            }
            
        }
    }
}
