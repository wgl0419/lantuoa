//
//  WorkReportViewController.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class WorkReportViewController: UIViewController {
    
    /// collectionView
    private var collectionView: UICollectionView!
    /// 数据
    private var data = [WorkReportListData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        processList()

    }
    
    // MAKR: - 自定义自有方法
    /// 设置导航栏
    private func setNav() {
        title = "工作汇报"
        view.backgroundColor = .white
        let nav = navigationController as! MainNavigationController
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "查看汇报",
                                                            titleColor: .white,
                                                            titleFont: UIFont.medium(size: 15),
                                                            titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                            target: self,
                                                            action: #selector(rightClick))
    }
    
    /// 初始化子控件
    private func initSubViews() {
        let flowlayut : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayut) // collectionView
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.register(WorkReportCell.self, forCellWithReuseIdentifier: "WorkReportCell")
            })
        let str = "暂无工作汇报选项！"
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        collectionView.noDataLabel?.attributedText = attriMuStr
        collectionView.noDataImageView?.image = UIImage(named: "noneData")
    }
    
    // MARK: - Api
    /// 汇报列表
    private func processList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.WorkReportList, t: WorkReportListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.data = result.data
            self.collectionView.reloadData()
            self.collectionView.isNoData = self.data.count == 0
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
        
    // MARK: - 按钮点击
    /// 点击查看汇报
    @objc func rightClick(){
        let vc = CheckReportListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension WorkReportViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkReportCell", for: indexPath) as! WorkReportCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    //     最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }

    //    最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenWidth / 4  , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CheckReportContentController()
        vc.processName = data[indexPath.row].name ?? ""
        vc.processId = data[indexPath.row].id
//        vc.pricessType = data[indexPath.row].type
        vc.canUpload = data[indexPath.row].canUpload
        navigationController?.pushViewController(vc, animated: true)
        ///把抄送人那一栏改成接收人
    }
}

