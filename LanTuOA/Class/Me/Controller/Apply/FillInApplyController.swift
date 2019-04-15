//
//  FillInApplyController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请  控制器

import UIKit
import MBProgressHUD

class FillInApplyController: UIViewController {
    
    /// 流程名称
    var processName = "流程名称"
    /// 流程id
    var processId = 0

    /// tableview
    private var tableView: UITableView!
    
    /// 数据
    private var data = [ProcessParamsData]()
    /// 选中内容
    private var seleStrArray = [String]()
    /// 项目所在section
    private var projectPosition = -1
    /// 客户id
    private var customerId = -1
    /// 项目id
    private var projectId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        processParams()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = processName
        view.backgroundColor = .white
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
                tableView.register(FillInApplyTextViewCell.self, forCellReuseIdentifier: "FillInApplyTextViewCell")
                tableView.register(FillInApplyFieldViewCell.self, forCellReuseIdentifier: "FillInApplyFieldViewCell")
            })
    }
    
    /// 确认按钮处理
    private func confirmHandle() {
        
    }
    
    /// 选择时间
    private func seleTimeHandle(section: Int) {
        let view = SeleVisitTimeView(limit: false)
        view.seleBlock = { [weak self] (timeStr) in
            self?.seleStrArray[section] = timeStr
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .fade)
        }
        view.show()
    }
    
    /// 选择客户
    private func seleCustomerHandle(section: Int) {
        let vc = NewlyBuildVisitSeleController()
        vc.type = .customer
        vc.seleBlock = { [weak self] (customerArray) in
            let position = self?.projectPosition ?? 0
            self?.customerId = customerArray.first?.0 ?? -1
            self?.seleStrArray[section] = customerArray.first?.1 ?? ""
            // 重置数据 -> 防止出现选择项目后 修改客户
            self?.projectId = -1
            self?.seleStrArray[position] = ""
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section), IndexPath(row: 0, section: position)], with: .fade)
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择项目
    private func seleProjectHandle(section: Int) {
        guard customerId != -1 else {
            MBProgressHUD.showError("请先选择客户")
            return
        }
        let vc = NewlyBuildVisitSeleController()
        vc.type = .project(customerId)
        
        vc.seleBlock = { [weak self] (customerArray) in
            self?.projectId = customerArray.first?.0 ?? -1
            self?.seleStrArray[section] = customerArray.first?.1 ?? ""
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .fade)
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 数据处理
    private func dataHandld() {
        data.sort { (model1, model2) -> Bool in
            return model1.sort < model2.sort
        }
        for index in 0..<data.count {
            let model = data[index]
            if model.type == 7 { // 客户
                projectPosition = index
            }
            seleStrArray.append("")
        }
    }
    
    // MARK: - Api
    /// 获取流程内容
    private func processParams() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.processParams(processId), t: ProcessParamsModel.self, successHandle: { (result) in
            self.data = result.data
            self.dataHandld()
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取流程内容失败,请下拉重新加载")
        })
    }
}

extension FillInApplyController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let model = data[section]
        switch model.type {
        case 1: // 1.文本
            let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyTextViewCell", for: indexPath) as! FillInApplyTextViewCell
            cell.data = (model.title ?? "", model.hint ?? "")
            cell.isMust = model.isNecessary == 1
            cell.inputBlock = { [weak self] (contentStr) in
                self?.seleStrArray[section] = contentStr
            }
            return cell
        case 2: // 2.数字
            let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyFieldViewCell", for: indexPath) as! FillInApplyFieldViewCell
            cell.data = (model.title ?? "", model.hint ?? "")
            cell.isMust = model.isNecessary == 1
            cell.isNumber = true
            cell.inputBlock = { [weak self] (contentStr) in
                self?.seleStrArray[section] = contentStr
            }
            return cell
        case 3, 4, 5, 6, 7: // 3.日期，4.单选，5.多选，6.客户，7.项目
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
            cell.data = (model.title ?? "", model.hint ?? "")
            cell.contentStr = seleStrArray[section]
            cell.isMust = model.isNecessary == 1
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        let model = data[section]
        switch model.type {
        case 3: // 3.日期
            seleTimeHandle(section: section)
        case 4, 5: // 4.单选，5.多选
            break
        case 6: // 6.客户
            seleCustomerHandle(section: section)
        case 7: // 7.项目
            seleProjectHandle(section: section)
        default: break
        }
    }
}
