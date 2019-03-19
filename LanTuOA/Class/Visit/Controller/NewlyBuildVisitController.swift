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

    /// 主要tableview
    private var tableView: UITableView!
    /// 确定按钮
    private var confirmBtn: UIButton!
    
    /// 标题
    private let titleArray = ["客户", "拜访人", "项目", "拜访方式", "拜访时间", "内容", "结果", "所在位置"]
    /// 提示
    private let placeholderArray = ["请选择", "请选择", "请选择", "请选择", "请选择", "请输入拜访内容", "请输入拜访结果", "请选择"]
    /// 选中id
    private var seleIdArray = [-1, -1, -1, -1, -1, -1, -1, -1]
    /// 选中内容
    private var seleStrArray = ["", "", "", "", "", "", "", ""]
    
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择拜访方式
    private func seleModelHandle() {
        let view = SeleVisitModelView()
        view.didBlock = { [weak self] (modelStr) in
            self?.seleStrArray[3] = modelStr
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
        }
        view.show()
    }
    
    private func seleTimeHandle() {
        let view = SeleVisitTimeView()
        view.seleBlock = { [weak self] (timeStr) in
            self?.seleStrArray[4] = timeStr
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .fade)
        }
        view.show()
    }
    
    // MARK: - 按钮点击
    /// 点击确认
    @objc private func confirmClick() {
        
    }
}

extension NewlyBuildVisitController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
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
