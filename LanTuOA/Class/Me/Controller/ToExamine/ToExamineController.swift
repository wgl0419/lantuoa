//
//  ToExamineController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审核 控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ToExamineController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    
    /// 页码
    private var page = 1
    /// 审核列表数据
    private var data =  [NotifyCheckListData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        notifyCheckList(isMore: false)
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "我的审核"
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // 用于显示数据的tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 180
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(NoticeHomePendingCell.self, forCellReuseIdentifier: "NoticeHomePendingCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.notifyCheckList(isMore: false)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.notifyCheckList(isMore: true)
                })
            })
        
        let str = "暂无审批！"
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: "noneData1")
    }
    
    /// 点击同意处理
    private func agreeHandle(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "提示", message: "是否同意该申请?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "同意", style: .default, handler: { (_) in
            self.notifyCheckAgree(index: indexPath)
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 点击拒绝处理
    private func refuseHandle(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "提示", message: "是否拒绝该申请?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "拒绝", style: .default, handler: { (_) in
            self.notifyCheckReject(index: indexPath)
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Api
    /// 审核列表
    private func notifyCheckList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.notifyCheckList(newPage, 10), t: NotifyCheckListModel.self, successHandle: { (result) in
            if isMore {
                for model in result.data {
                    self.data.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.data = result.data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.tableView.isNoData = self.data.count == 0
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            if isMore {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
            } else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 拒绝审批-非创建客户/项目
    private func notifyCheckReject(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = data[index.row].id
        _ = APIService.shared.getData(.notifyCheckReject(checkId, ""), t: LoginModel.self, successHandle: { (result) in
            self.data.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .fade)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝审核 填写弹出框
    ///
    /// - Parameters:
    ///   - type: 类型  0：已存在  1：有误
    ///   - index: 在tableView中的位置
    private func modifyEjectView(type: Int ,index: IndexPath) {
        let ejectView = ModifyNoticeEjectView()
        ejectView.data = data[index.row]
        if type == 0 {
            ejectView.modifyType = .alreadyExist
        } else {
            ejectView.modifyType = .unreasonable
        }
        ejectView.alreadyExistBlock = { [weak self] (idArray) in
            self?.notifyCheckCusRejectExist(index: index, id: idArray)
        }
        ejectView.unreasonableBlock = { [weak self] (contentArray) in
            self?.notifyCheckCusRejectMistake(index: index, conten: contentArray)
        }
        ejectView.show()
    }
    
    /// 拒绝创建客户/项目-客户已存在
    private func notifyCheckCusRejectExist(index: IndexPath, id: [Int]) {
        MBProgressHUD.showWait("")
        let checkId = data[index.row].id
        _ = APIService.shared.getData(.notifyCheckCusRejectExist(checkId, id[0], id[1]), t: LoginModel.self, successHandle: { (result) in
            self.data.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .fade)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝创建客户/项目-名称有误
    private func notifyCheckCusRejectMistake(index: IndexPath, conten: [String]) {
        MBProgressHUD.showWait("")
        let checkId = data[index.row].id
        _ = APIService.shared.getData(.notifyCheckCusRejectMistake(checkId, conten[0], conten[1]), t: LoginModel.self, successHandle: { (result) in
            self.data.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .fade)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 同意审批
    private func notifyCheckAgree(index: IndexPath) {
        MBProgressHUD.showWait("")
        let checkId = data[index.row].id
        _ = APIService.shared.getData(.notifyCheckAgree(checkId, ""), t: LoginModel.self, successHandle: { (result) in
            self.data.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .fade)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }
}

extension ToExamineController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeHomePendingCell", for: indexPath) as! NoticeHomePendingCell
        cell.data = data[indexPath.row]
        cell.agreeBlock = { [weak self] in // 同意
            self?.agreeHandle(indexPath: indexPath)
        }
        cell.refuseBlock = { [weak self] (type) in // 拒绝
            if type == nil {
                self?.refuseHandle(indexPath: indexPath)
            } else {
                self?.modifyEjectView(type: type!, index: indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ToExamineDetailsController()
        vc.checkListId = 4//data[indexPath.row].id
        vc.changeBlock = { [weak self] in
            self?.notifyCheckList(isMore: false)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
