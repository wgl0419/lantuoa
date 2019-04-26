//
//  ApplyListCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作申请  cell

import UIKit

class ApplyListCell: UITableViewCell {

    /// 点击回调
    var clickBlock: ((Int) -> ())?
    /// 查看更多
    var moreBlock: ((Bool) -> ())?
    /// 查看更多
    var isOpen = false
    /// 数据
    var data: ProcessListData? {
        didSet {
            if let data = data {
                titleLabel.text = data.desc
                collectionView.reloadData()
                layoutIfNeeded()
                self.perform(#selector(setCollectionViewHeight), with: nil, afterDelay: 0.01)
//                moreBtn.isHidden = data.list.count <= 4
            }
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    /// 更多按钮
    private var moreBtn: UIButton!
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
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.height.equalTo(45)
            })
            .taxi.config({ (label) in
                label.text = "标题"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        
        moreBtn = UIButton().taxi.adhere(toSuperView: contentView) // 更多按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(titleLabel)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (btn) in
                btn.setTitle("更多", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(moreClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(titleLabel)
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView
            .taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
                make.height.equalTo(102).priority(800)
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.showsVerticalScrollIndicator = false
                collectionView.showsHorizontalScrollIndicator = false
                collectionView.register(ApplyCollectionCell.self, forCellWithReuseIdentifier: "ApplyCollectionCell")
            })
        
    }
    
    @objc private func setCollectionViewHeight() {
        collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(collectionView.contentSize.height).priority(800)
        }
    }
    
    // MARK: - 按钮点击
    /// 点击更多
    @objc private func moreClick() {
        if moreBlock != nil {
            moreBlock!(!isOpen)
        }
    }
}


extension ApplyListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = data?.list.count ?? 0
        return count > 4 ? isOpen ? count : 4 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyCollectionCell", for: indexPath) as! ApplyCollectionCell
        cell.data = data?.list[0]//data?.list[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if clickBlock != nil {
            clickBlock!(indexPath.row)
        }
    }
}
