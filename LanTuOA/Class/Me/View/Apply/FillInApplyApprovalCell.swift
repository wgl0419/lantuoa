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
    /// 是审批人
    var isApproval: Bool = true
    /// 数据
    var data: [ProcessUsersCheckUsers]! {
        didSet {
            dataHandle()
        }
    }
    
    /// CollectionView
    private var collectionView: UICollectionView!
    /// 标题
    private var titleLabel: UILabel!
    
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
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(200).priority(800)
                make.top.equalTo(titleLabel.snp.bottom)
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
                collectionView.register(FillInApplyCarbonCopyAddCell.self, forCellWithReuseIdentifier: "FillInApplyCarbonCopyAddCell")
            })
        
    }
    
    /// 数据处理
    private func dataHandle() {
        processedData = []
        if !isApproval { // 抄送人不需要处理
            titleLabel.text = "抄送人"
            for model in data {
                processedData.append([model])
            }
        } else { // 审批人 需要处理
            titleLabel.text = "审批人"
            var newData = data!
            guard newData.count > 0 else {
                return
            }
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
        }
        
        collectionView.reloadData()
        layoutIfNeeded()
        collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(collectionView.contentSize.height).priority(800)
        }
    }
}

extension FillInApplyApprovalCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
                cell.data = processedData[row]
                return cell
            }
            
        }
    }
}
