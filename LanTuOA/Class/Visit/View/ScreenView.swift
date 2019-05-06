//
//  ScreenView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  筛选视图

import UIKit

class ScreenView: UIView {


    /// 删除回调 (删除位置  时间：10086)
    var deleteBlock: ((Int) -> ())?
    
    /// 数据
    var data: (Int?, Int?, [String])! {
        didSet {
            strArray = []
            positionArray = []
            var startTimeStr = ""
            var endTimeStr = ""
            if data.0 != nil {
                startTimeStr = Date(timeIntervalSince1970: TimeInterval(data.0!)).customTimeStr(customStr: "yyyy.MM.dd")
            }
            if data.1 != nil {
                endTimeStr = Date(timeIntervalSince1970: TimeInterval(data.1!)).customTimeStr(customStr: "yyyy.MM.dd")
            }
            
            if startTimeStr.count == 0 && endTimeStr.count == 0 { // 没有选中时间

            } else if startTimeStr.count == 0 { // 没有选中开始时间
                strArray.append(endTimeStr + "之前")
                positionArray.append(10086)
            } else if endTimeStr.count == 0 { // 没有选中结束时间
                strArray.append(startTimeStr + "至今")
                positionArray.append(10086)
            } else { // 都选择了
                strArray.append(startTimeStr + "-" + endTimeStr)
                positionArray.append(10086)
            }
            
            let contentArray = data.2
            for index in 0..<contentArray.count {
                let str = contentArray[index]
                if str.count != 0 && str != "全部" {
                    strArray.append(str)
                    positionArray.append(index)
                }
            }
            setCollectionViewHeight()
            setCollectionViewHeight()
        }
    }
    
    /// 内容
    private var contentLabel: UILabel!
    /// 删除按钮
    private var deleteBtn: UIButton!
    /// collectionview
    private var collectionView: UICollectionView!
    
    /// 内容数组
    private var strArray = [String]()
    /// 记录位置
    private var positionArray = [Int]()
    
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
        
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = CGSize(width: 10, height: 44)
        let flowLayout = JYEqualCellSpaceFlowLayout(AlignType.left, 5.0)
        flowLayout.estimatedItemSize = CGSize(width: 10, height: 44)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout) // collectionView
            .taxi.adhere(toSuperView: self)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(100).priority(800)
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.register(ScreenViewCollectionCell.self, forCellWithReuseIdentifier: "ScreenViewCollectionCell")
            })
        
        
        setCollectionViewHeight()
    }
    
    @objc private func setCollectionViewHeight() {
        collectionView.reloadData()
        self.layoutIfNeeded()
        collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(collectionView.contentSize.height).priority(800)
        }
    }
}

extension ScreenView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if strArray.count == 1 {
            return 2
        } else {
            return strArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenViewCollectionCell", for: indexPath) as! ScreenViewCollectionCell
        if strArray.count == 1 && row == 1 {
            cell.str = nil
        } else {
            cell.str = strArray[row]
        }
        cell.deleteBlock = { [weak self] in
            let position = self?.positionArray[row] ?? 0
            if self?.deleteBlock != nil {
                self?.deleteBlock!(position)
            }
            self?.strArray.remove(at: row)
            self?.positionArray.remove(at: row)
            self?.setCollectionViewHeight()
        }
        return cell
    }
}
