//
//  ModifyCustomerTypeEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  修改客户类型 弹框

import UIKit
import MBProgressHUD

class ModifyCustomerTypeEjectView: UIView {
    
    /// 修改回调
    var changeBlock: (() -> ())?
    
    /// 白色背景框
    private var whiteView: UIView!
    /// tableview
    private var tableView: UITableView!
    /// 确认按钮
    private var confirmBtn: UIButton!
    
    /// 标题
    private var titleArray = ["客户类型", "开发者", "开发截止时间"]
    /// 提示
    private var placeholderArray = ["请选择", "请选择", "请选择"]
    /// 选中内容
    private var seleStrArray = ["", "", ""]
    /// 客户数据
    private var data: CustomerListStatisticsData!
    /// 选中客户类型
    private var seleType = 1
    /// 选中时间戳
    private var seleTime: Int!
    /// 选中人员id
    private var selePersonId: Int!
    
    convenience init(data: CustomerListStatisticsData) {
        self.init(frame: ScreenBounds)
        self.data = data
        seleType = data.type
        seleStrArray[0] = data.type == 1 ? "公司" : data.type == 2 ? "普通" : "开发中"
        seleStrArray[1] = data.developerName ?? ""
        if seleType != 3 { // 初始值不是开发中  不获取这些数据
            if data.developTime != 0 {
                seleTime = data.developTime
                seleStrArray[2] = Date(timeIntervalSince1970: TimeInterval(data.developTime)).customTimeStr(customStr: "yyyy-MM-dd")
            }
            selePersonId = data.developerId
        }
        initSubViews()
    }
    
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
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
         whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(300)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
                view.backgroundColor = .white
            })
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(55)
        }
            .taxi.config { (label) in
                label.text = "修改客户类型"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.backgroundColor = UIColor(hex: "#F1F1F1")
        }
        
        tableView = UITableView().taxi.adhere(toSuperView: whiteView) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.height.equalTo(250).priority(800)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.bounces = false
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2)
                make.top.equalTo(tableView.snp.bottom)
                make.left.bottom.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.setTitle("取消", for: .normal)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
            })
        
        confirmBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2)
                make.right.bottom.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.bottom.equalTo(confirmBtn)
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        tableViewHandle()
        
    }
    
    /// 处理tableview高度
    @objc private func tableViewHandle() {
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(tableView.contentSize.height + 5).priority(800)
        }
    }
    
    // MARK: - Api
    /// 设置开发客户
    private func customerUpdateDevelop() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.customerUpdateDevelop(data.id, selePersonId, seleTime), t: CustomerUpdateDevelopModel.self, successHandle: { (result) in
            MBProgressHUD.showSuccess("修改客户成功")
            if self.changeBlock != nil {
                self.changeBlock!()
            }
            self.hidden()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "修改客户失败")
        })
    }
    
    /// 设置公司、普通客户
    private func customerUpdate() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.customerUpdate(data.name ?? "", data.fullName ?? "", data.address ?? "", seleType, data.industry, data.id), t: CustomerUpdateDevelopModel.self, successHandle: { (result) in
            MBProgressHUD.showSuccess("修改客户成功")
            if self.changeBlock != nil {
                self.changeBlock!()
            }
            self.hidden()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "修改客户失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击确定
    @objc private func confirmClick() {
        if seleType == 3 {
            if seleType != data.type {
                if seleTime != nil && selePersonId != nil {
                    customerUpdateDevelop()
                } else {
                    MBProgressHUD.showSuccess("请选择剩余内容")
                }
            } else {
                MBProgressHUD.showSuccess("修改客户成功")
                hidden()
            }
        } else {
            if seleType != data.type {
                customerUpdate()
            } else {
                MBProgressHUD.showSuccess("修改客户成功")
                hidden()
            }
        }
    }
}

extension ModifyCustomerTypeEjectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seleType == 3 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
        cell.data = (titleArray[row], placeholderArray[row])
        cell.contentStr = seleStrArray[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        switch row {
        case 0: // 选择客户类型
            let contentArray = ["公司", "普通", "开发中"]
            let view = SeleVisitModelView(title: "选择客户类型", content: contentArray)
            view.didBlock = { [weak self] (seleIndex) in
                self?.seleType = seleIndex + 1
                self?.seleStrArray[0] = contentArray[seleIndex]
                tableView.reloadData()
                self?.layoutIfNeeded()
            }
            view.show()
        case 1: // 选择开发人
            self.isHidden = true
            let vc = SelePersonnelController()
            vc.isMultiple = false
            vc.displayData = ("选择开发人", "选定", .back)
            vc.backBlock = { [weak self] (users) in
                if users.count > 0 {
                    let userData = users[0]
                    self?.selePersonId = userData.id
                    self?.seleStrArray[1] = userData.realname ?? ""
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                self?.isHidden = false
            }
            let currentVC = APIService.shared.getCurrentController()
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        case 2: // 选择开发截止时间
            let ejectView = SeleTimeEjectView(timeStamp: seleTime, titleStr: "选择开发截止时间：")
            ejectView.miniTimeStamp = Int(Date().timeIntervalSince1970)
            ejectView.determineBlock = { [weak self] (time) in
                self?.seleStrArray[2] = Date(timeIntervalSince1970: TimeInterval(time)).customTimeStr(customStr: "yyyy-MM-dd")
                self?.seleTime = time
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            ejectView.show()
        default: break
        }
    }
}
