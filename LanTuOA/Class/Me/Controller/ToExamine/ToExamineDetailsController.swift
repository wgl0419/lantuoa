//
//  ToExamineDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审核详情   控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ToExamineDetailsController: UIViewController {

    /// 审批数据
    var checkListData: NotifyCheckListData!
    /// 修改回调
    var changeBlock: (() -> ())?
    
    
    /// tableview
    private var tableView: UITableView!
    
    /// 审批详情数据
    private var data = [NotifyCheckUserListData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        notifyCheckUserList()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "审核详情"
        view.backgroundColor = .white
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮背景图
            .taxi.layout { (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(62 + (isIphoneX ? SafeH : 18))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        _ = UIButton().taxi.adhere(toSuperView: btnView) // 拒绝按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo((ScreenWidth - 45) / 2).priority(800)
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(18)
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.setTitle("拒绝", for: .normal)
                btn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
                
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor(hex: "#2E4695").cgColor
                btn.addTarget(self, action: #selector(refuseClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: btnView) // 同意按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo((ScreenWidth - 45) / 2).priority(800)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(18)
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.setTitle("同意", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.backgroundColor = UIColor(hex: "#2E4695")
                btn.addTarget(self, action: #selector(agreeClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.backgroundColor = .white
                tableView.register(ToExamineDetailsHeaderCell.self, forCellReuseIdentifier: "ToExamineDetailsHeaderCell")
                tableView.register(ToExamineDetailsCell.self, forCellReuseIdentifier: "ToExamineDetailsCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.notifyCheckUserList()
                })
            })
    }
    
    /// 修改处理
    private func changeHandle() {
        notifyCheckDetail()
        notifyCheckUserList()
        if changeBlock != nil {
            changeBlock!()
        }
    }
    
    /// 点击同意处理
    private func agreeHandle() {
        let alertController = UIAlertController(title: "提示", message: "是否同意该申请?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let agreeAction = UIAlertAction(title: "同意", style: .default, handler: { (_) in
            self.notifyCheckAgree()
        })
        alertController.addAction(agreeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - APi
    /// 获取审批详情
    private func notifyCheckDetail() {
        _ = APIService.shared.getData(.notifyCheckDetail(checkListData.id), t: NotifyCheckDetailModel.self, successHandle: { (result) in
            self.checkListData = result.data
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取审批人失败")
        })
    }
    
    /// 审批人列表
    private func  notifyCheckUserList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckUserList(checkListData.id), t: NotifyCheckUserListModel.self, successHandle: { (result) in
            self.data = result.data
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取审批人失败")
        })
    }
    
    /// 拒绝创建客户/项目-客户已存在
    private func notifyCheckCusRejectExist() {
        MBProgressHUD.showWait("")
        let checkId = checkListData.id
        _ = APIService.shared.getData(.notifyCheckCusRejectExist(checkId), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.changeHandle()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 拒绝创建客户/项目-名称有误
    private func notifyCheckCusRejectMistake() {
        MBProgressHUD.showWait("")
        let checkId = checkListData.id
        _ = APIService.shared.getData(.notifyCheckCusRejectMistake(checkId), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.changeHandle()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 同意审批
    private func notifyCheckAgree() {
        MBProgressHUD.showWait("")
        let checkId = checkListData.id
        _ = APIService.shared.getData(.notifyCheckAgree(checkId, ""), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.changeHandle()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }
    
    
    // MARK: - 按钮点击
    /// 点击拒绝
    @objc private func refuseClick() {
        if checkListData.processType == 1 || checkListData.processType == 2 {
            let view = SeleVisitModelView(title: "拒绝原因", content: ["已存在项目/客户/拜访人", "名字不合理"])
            view.didBlock = { [weak self] (seleIndex) in
                switch seleIndex {
                case 1: self?.notifyCheckCusRejectExist()
                case 2: self?.notifyCheckCusRejectMistake()
                default: break
                }
            }
            view.show()
        } else {
            let vc = ToExamineDescController()
            vc.checkId = checkListData.id
            vc.descType = .refuse
            vc.changeBlock = { [weak self] in
                self?.changeHandle()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// 点击同意
    @objc private func agreeClick() {
        if checkListData.processType == 1 || checkListData.processType == 2 {
            agreeHandle()
        } else {
            let vc = ToExamineDescController()
            vc.checkId = checkListData.id
            vc.descType = .agree
            vc.changeBlock = { [weak self] in
                self?.changeHandle()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ToExamineDetailsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return data.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsHeaderCell", for: indexPath) as! ToExamineDetailsHeaderCell
            cell.data = checkListData
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineDetailsCell", for: indexPath) as! ToExamineDetailsCell
            if row == 0 {
                cell.data = (checkListData.createdUserName ?? "", checkListData.createdTime, 0, -1)
            } else {
                cell.data = (data[row - 1].checkUserName ?? "", data[row - 1].checkedTime, data[row - 1].status, row == data.count ? 1 : 0)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
            footerView.backgroundColor = UIColor(hex: "#F3F3F3")
            return footerView
        } else {
            return nil
        }
    }
}
