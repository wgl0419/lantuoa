//
//  ApplyControllers.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class ApplyControllers: UIViewController {

    /// collectionView
    private var collectionView: UICollectionView!
    
    /// 数据
    private var data = [ProcessListData]()
    /// 展开数组
    private var openArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        processList()
    }
    
    // MAKR: - 自定义自有方法
    /// 设置导航栏
    private func setNav() {
        title = "工作申请"
        view.backgroundColor = .white
        let nav = navigationController as! MainNavigationController
        nav.backBtn.isHidden = false
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "申请记录",
                                                            titleColor: .white,
                                                            titleFont: UIFont.medium(size: 15),
                                                            titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                            target: self,
                                                            action: #selector(rightClick))
    }
    
    /// 初始化子控件
    private func initSubViews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: ScreenWidth, height: ScreenWidth)
        layout.footerReferenceSize = CGSize(width: ScreenWidth, height: 10)
        layout.headerReferenceSize = CGSize(width: ScreenWidth, height: 45)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // collectionView
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.register(ApplyCollectionCell.self, forCellWithReuseIdentifier: "ApplyCollectionCell")
                collectionView.register(ApplyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ApplyHeaderView")
                collectionView.register(ApplyFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ApplyFooterView")
            })
    }
    
    
    // MARK: - Api
    /// 流程列表
    private func processList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.processList(), t: ProcessListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.data = result.data
            var moreArray = [Bool]()
            for _ in result.data {
                moreArray.append(false)
            }
            self.openArray = moreArray
            self.collectionView.reloadData()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击申请记录
    @objc private func rightClick() {
        let vc = ApplyHistoryController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ApplyControllers: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = data[section].list.count
        count = count == 1 ? 2 : count
        return openArray[section] ? count : count > 4 ? 4 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyCollectionCell", for: indexPath) as! ApplyCollectionCell
        if row == data[section].list.count {
            cell.data = nil
        } else {
            cell.data = data[section].list[row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ApplyFooterView", for: indexPath) as! ApplyFooterView
            reusableview = footerView
        } else {
            let section = indexPath.section
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ApplyHeaderView", for: indexPath) as! ApplyHeaderView
            headerView.canOpen = data[section].list.count > 4
            headerView.isOpen = openArray[section]
            headerView.title = data[section].desc
            headerView.openBlock = { [weak self] in
                self?.openArray[section] = !(self?.openArray[section] ?? false)
                collectionView.reloadData()
            }
            reusableview = headerView
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        if row != data[section].list.count {
            let vc = FillInApplyController()
            vc.processName = data[indexPath.section].list[row].name ?? ""
            vc.processId = data[indexPath.section].list[row].id
            vc.pricessType = data[indexPath.section].list[row].type
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
