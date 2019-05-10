//
//  ScreenEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/5.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  筛选 弹出视图

import UIKit
import MBProgressHUD

class ScreenEjectView: UIView {

    /// 筛选类型
    enum ScreenType {
        /// 客户
        case customer
        /// 业务人员
        case originator
    }
    
    /// 选中回调 (名称  id)
    var seleBlock: ((String, Int) -> ())?
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// tableview
    private var tableView: UITableView!
    /// 取消按钮
    private var cancelBtn: UIButton!
    
    /// 筛选类型
    private var screenType: ScreenType!
    /// 客户数据
    private var customerData = [[CustomerListStatisticsData]]()
    /// 业务人员数据
    private var usersData = [[UsersData]]()
    /// 索引
    private var firstLetterArray = [String]()
    
    // MAKR: - 自定义公有方法
    /// 弹出
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(hex: "#000000", alpha: 0.5)
        }
    }
    
    /// 隐藏
    @objc func hidden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = .clear
            self.removeAllSubviews()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 自定义初始化
    convenience init(data: [Any]) {
        self.init(frame: ScreenBounds)
        initSubViews()
        if data is [CustomerListStatisticsData] {
            screenType = .customer
            titleLabel.text = "客户筛选"
            let oldData = data as! [CustomerListStatisticsData]
            BMChineseSort.sortAndGroup(objectArray: oldData, key: "name") { (isSuccess, _, titleArr, objArr) in
                if isSuccess{
                    self.firstLetterArray = titleArr
                    self.customerData = objArr
                    self.reloadData()
                }
            }
        } else if data is [UsersData] {
            screenType = .originator
            titleLabel.text = "业务人员筛选"
            let oldData = data as! [UsersData]
            BMChineseSort.sortAndGroup(objectArray: oldData, key: "realname") { (isSuccess, _, titleArr, objArr) in
                if isSuccess{
                    self.firstLetterArray = titleArr
                    self.usersData = objArr
                    self.reloadData()
                }
            }
        }
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(300)
                make.center.equalToSuperview()
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
                view.backgroundColor = .white
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(50)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.textAlignment = .center
                label.backgroundColor = UIColor(hex: "#F1F1F1")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        cancelBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.setTitle("取消", for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(cancelBtn)
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: whiteView) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.bottom.equalTo(cancelBtn.snp.top)
                make.left.right.equalToSuperview()
                make.height.equalTo(40)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
            })
    }
    
    /// 刷新tableview
    private func reloadData() {
        tableView.reloadData()
        layoutIfNeeded()
        let sizeHeight = tableView.contentSize.height
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(sizeHeight > 360 ? 360 : sizeHeight)
        }
    }
    
    // MAKR: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
}

extension ScreenEjectView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetterArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenType == .customer {
            return customerData[section].count
        } else {
            return usersData[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ScreenEjectViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ScreenEjectViewCell")
            cell?.textLabel?.font = UIFont.medium(size: 14)
            cell?.textLabel?.textColor = blackColor
        }
        var str = ""
        let row = indexPath.row
        let section = indexPath.section
        if screenType == .customer {
            str = customerData[section][row].name ?? ""
        } else {
            str = usersData[section][row].realname ?? ""
        }
        cell?.textLabel?.text = str
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return firstLetterArray[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return firstLetterArray
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var str = ""
        var id = 0
        let row = indexPath.row
        let section = indexPath.section
        if screenType == .customer {
            id = customerData[section][row].id
            str = customerData[section][row].name ?? ""
        } else {
            id = usersData[section][row].id
            str = usersData[section][row].realname ?? ""
        }
        
        if seleBlock != nil {
            seleBlock!(str, id)
        }
        hidden()
    }
}
