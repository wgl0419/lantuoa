//
//  WorkGroupController.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作组 控制器

import UIKit
import MJRefresh
import MBProgressHUD

class WorkGroupController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    /// 提示
    private var tipsLabel: UILabel!
    
    /// 工作组
    private var groupData = [WorkGroupListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        workGroupList()
    }
    
    // MARK: - 自定义私有方法
    private func initSubViews() {
        title = "工作组"
        view.backgroundColor = .white
        
        tipsLabel = UILabel().taxi.adhere(toSuperView: view) // 提示文本
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : -30)
            })
            .taxi.config({ (label) in
                label.text = "注：同一工作组成员能看到彼此在该项目的所有拜访"
                label.textColor = UIColor(hex: "#FF4444")
                label.font = UIFont.regular(size: 12)
                label.textAlignment = .center
            })
            
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(tipsLabel.snp.top).offset(-20)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 80
                tableView.tableFooterView = UIView()
                tableView.register(WrokHomeCell.self, forCellReuseIdentifier: "WrokHomeCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.workGroupList()
                })
            })
        setNoneData(str: "暂无工作组！", imageStr: "noneData")
    }
    
    /// 设置无数据信息
    ///
    /// - Parameters:
    ///   - str: 提示内容
    ///   - imageStr: 提示图片名称
    private func setNoneData(str: String, imageStr: String) {
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: kMainSelectedColor)
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: imageStr)
    }
    
    /// 退出工作组处理
    private func workGroupQuitHandle(groupId: Int) {
        let alertController = UIAlertController(title: "提示", message: "是否退出该工作组?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "退出", style: .default, handler: { (_) in
            self.workGroupQuit(groupId: groupId)
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api
    /// 获取项目工作组
    private func workGroupList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workGroupList(1, 9999, nil), t: WorkGroupListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.groupData = result.data
            self.tableView.mj_header.endRefreshing()
            if result.data.count == 0 {
                MBProgressHUD.showError("该项目没有工作组")
            }
            self.tableView.reloadData()
            self.tableView.isNoData = self.groupData.count == 0
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.isNoData = self.groupData.count == 0
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 邀请他人进入工作组
    ///
    /// - Parameters:
    ///   - groupId: 组id
    ///   - idArray: id数组
    private func workGroupInvite(groupId: Int, idArray: [Int]) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workGroupInvite(groupId, idArray), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "邀请失败")
        })
    }
    
    /// 退出工作组
    ///
    /// - Parameter groupId: 要退出的工作组id
    private func workGroupQuit(groupId: Int) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workGroupQuit(groupId), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.workGroupList()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "退出工作组失败")
        })
    }
}

extension WorkGroupController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WrokHomeCell", for: indexPath) as! WrokHomeCell
        cell.data = groupData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 37))
        headerView.backgroundColor = kMainBackColor
        _ = UILabel().taxi.adhere(toSuperView: headerView) // ”我参与的工作组“
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.text = "我参与的工作组"
                label.font = UIFont.medium(size: 12)
                label.textColor = kMainSelectedColor
            })
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let view = SeleVisitModelView(title: "选择操作", content: ["邀请成员", "退出工作组"])
        view.didBlock = { [weak self] (seleIndex) in
            let id = self?.groupData[indexPath.row].id ?? 0
            switch seleIndex {
            case 0: // 邀请成员
                let vc = ProjectManageSeleController()
                vc.title = "选择成员"
                vc.isMultiple = true
                vc.backBlock = { (idArray, _) in
                    if idArray.count != 0 {
                        self?.workGroupInvite(groupId: id, idArray: idArray)
                    }
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            case 1: // 退出工作组
                self?.workGroupQuitHandle(groupId: id)
            default: break
            }
        }
        view.show()
    }
}
