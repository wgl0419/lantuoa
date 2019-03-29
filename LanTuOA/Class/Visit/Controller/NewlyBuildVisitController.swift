//
//  NewlyBuildVisitController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/15.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  新建拜访  控制器

import UIKit
import MBProgressHUD

class NewlyBuildVisitController: UIViewController {
    
    /// 添加成功回调
    var addBlock: (() -> ())?

    /// 主要tableview
    private var tableView: UITableView!
    /// 确定按钮
    private var confirmBtn: UIButton!
    
    /// 标题
//    private let titleArray = ["客户", "拜访人", "项目", "拜访方式", "拜访时间", "内容", "结果", "所在位置"]
    private let titleArray = ["客户", "拜访人", "项目", "拜访方式", "拜访时间", "内容", "结果"]
    /// 提示
//    private let placeholderArray = ["请选择", "请选择", "请选择", "请选择", "请选择", "请输入拜访内容", "请输入拜访结果", "请选择"]
    private let placeholderArray = ["请选择", "请选择", "请选择", "请选择", "请选择", "请输入拜访内容", "请输入拜访结果"]
    /// 选中id
//    private var seleIdArray = [-1, -1, -1, -1, -1, -1, -1, -1]
    private var seleIdArray = [-1, -1, -1, -1, -1, -1, -1]
    /// 拜访人id数组
    private var contactArray = [Int]()
    /// 选中内容
//    private var seleStrArray = ["", "", "", "", "", "", "", ""]
    private var seleStrArray = ["", "", "", "", "", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "填写拜访"
        
        let confirmView = UIView().taxi.adhere(toSuperView: view) // 确认按钮背景
            .taxi.layout { (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(64 + (isIphoneX ? SafeH : 18))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        confirmBtn = UIButton().taxi.adhere(toSuperView: confirmView) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(44)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(18)
                make.width.equalToSuperview().offset(-30)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitle("确定", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
            })
        
        tableView = UITableView(frame: .zero, style: .grouped)
            .taxi.adhere(toSuperView: view) // 主要tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(confirmView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 44
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
                tableView.register(NewlyBuildVisitTextViewCell.self, forCellReuseIdentifier: "NewlyBuildVisitTextViewCell")
            })
    }
    
    /// 选择客户
    private func seleCustomerHandle() {
        let vc = NewlyBuildVisitSeleController()
        vc.type = .customer
        vc.seleBlock = { [weak self] (customerArray) in
            self?.seleIdArray[0] = customerArray.first?.0 ?? -1
            self?.seleStrArray[0] = customerArray.first?.1 ?? ""
            // 重置数据 -> 防止出现选择拜访人、项目后 修改客户
            self?.seleIdArray[1] = -1
            self?.seleStrArray[1] = ""
            self?.seleStrArray[2] = ""
            self?.contactArray = []
            
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1), IndexPath(row: 0, section: 2)], with: .fade)
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择其他 (非客户)
    ///
    /// - Parameter section: 在tableview中的位置
    private func seleOtherHandle(section: Int) {
        let customerId = seleIdArray.first ?? -1
        guard customerId != -1 else {
            MBProgressHUD.showError("请先选择客户")
            return
        }
        let vc = NewlyBuildVisitSeleController()
        if section == 1 {
            vc.type = .visitor(customerId)
        } else {
            vc.type = .project(customerId)
        }
        
        vc.seleBlock = { [weak self] (customerArray) in
            if section == 1 {
                self?.contactArray = []
                var customerStr = ""
                for model in customerArray {
                    self?.contactArray.append(model.0)
                    customerStr.append("、\(model.1)")
                }
                if customerStr.count > 0 { customerStr.remove(at: customerStr.startIndex) }
                self?.seleStrArray[section] = customerStr
            } else {
                self?.seleIdArray[section] = customerArray.first?.0 ?? -1
                self?.seleStrArray[section] = customerArray.first?.1 ?? ""
            }
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .fade)
            self?.confirmHandle()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择拜访方式
    private func seleModelHandle() {
        let view = SeleVisitModelView(title: "选择拜访方式", content: ["面谈", "电话", "网络聊天"])
        view.didBlock = { [weak self] (seleIndex) in
            self?.seleIdArray[3] = seleIndex + 1
            self?.seleStrArray[3] = ["面谈", "电话", "网络聊天"][seleIndex]
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
            self?.confirmHandle()
        }
        view.show()
    }
    
    /// 选择时间处理
    private func seleTimeHandle() {
        let view = SeleVisitTimeView()
        view.seleBlock = { [weak self] (timeStr) in
            self?.seleStrArray[4] = timeStr
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .fade)
            self?.confirmHandle()
        }
        view.show()
    }
    
    /// 点亮确认按钮
    private func confirmHandle() {
        var isCompleted = true
        for str in seleStrArray {
            if str.count == 0 {
                isCompleted = false
                break
            }
        }
        confirmBtn.isEnabled = isCompleted
        confirmBtn.backgroundColor = isCompleted ? UIColor(hex: "#2E4695") : UIColor(hex: "#CCCCCC")
    }
    
    // MARK: - 按钮点击
    /// 点击确认
    @objc private func confirmClick() {
        MBProgressHUD.showWait("")
        let customerId = seleIdArray[0]
        let projectId = seleIdArray[2]
        let type = seleIdArray[3]
        let content = seleStrArray[5]
        let result = seleStrArray[6]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let visitTime = formatter.date(from: seleStrArray[4])?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        _ = APIService.shared.getData(.visitSave(customerId, projectId, type, content, result, Int(visitTime), contactArray), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if self.addBlock != nil {
                self.addBlock!()
            }
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "提交失败，请重新提交")
        })
    }
}

extension NewlyBuildVisitController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section != 5 && section != 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
            cell.data = (titleArray[section], placeholderArray[section])
            cell.contentStr = seleStrArray[section]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitTextViewCell", for: indexPath) as! NewlyBuildVisitTextViewCell
            cell.data = (titleArray[section], placeholderArray[section])
            cell.textBlock = { [weak self] (str) in
                self?.seleStrArray[section] = str
                self?.confirmHandle()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 7 {
            return 30
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        switch section {
        case 0: seleCustomerHandle()
        case 1, 2: seleOtherHandle(section: section)
        case 3: seleModelHandle()
        case 4: seleTimeHandle()
        case 7: break
        default: break
        }
    }
}
