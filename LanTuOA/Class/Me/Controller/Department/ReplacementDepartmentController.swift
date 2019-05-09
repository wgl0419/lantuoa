//
//  ReplacementDepartmentController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  更换部门 控制器

import UIKit
import MBProgressHUD

class ReplacementDepartmentController: UIViewController {
    
    /// 修改用户id
    var userId = 0
    /// 当前部门的id
    var departmentsId = 0
    /// 修改回调
    var changeBlock: (() -> ())?

    /// tableview
    private var tableView: UITableView!
    /// 确定按钮
    private var determineBtn: UIButton!
    /// 已选
    private var selectedLabel: UILabel!
    
    /// 全部部门数据
    private var departmentsData = [DepartmentsData]()
    /// 选中的id
    private var selectedIds = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        selectedIds.append(departmentsId)
        departments()
    }
    

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "更换部门"
        view.backgroundColor = UIColor(hex: "#F3F3F3")
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮视图
            .taxi.layout { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(64 + (isIphoneX ? SafeH : 18))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        determineBtn = UIButton().taxi.adhere(toSuperView: btnView) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().offset(-30)
                make.top.equalToSuperview().offset(18)
                make.centerX.equalToSuperview()
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.setTitle("更换", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top).offset(-10)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(SelePersonnelCell.self, forCellReuseIdentifier: "SelePersonnelCell")
            })
    }
    
    /// 确定按钮处理
    private func determineHandle() {
        determineBtn.isEnabled = selectedIds.count > 0
        selectedLabel.text = "已选 \(selectedIds.count)/\(departmentsData.count)"
        determineBtn.backgroundColor = selectedIds.count > 0 ? UIColor(hex: "#2E4695") : UIColor(hex: "#CCCCCC")
    }
    
    /// 初始化顶部视图
    private func initHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 37))
        headerView.backgroundColor = UIColor(hex: "#F3F3F3")
        
        selectedLabel = UILabel().taxi.adhere(toSuperView: headerView) // 已选
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "已选 \(selectedIds.count)/\(departmentsData.count)"
                label.textColor = UIColor(hex: "#999999")
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        return headerView
    }
    
    // MARK: - Api
    /// 全部部门列表
    private func departments() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.departments(-1), t: DepartmentsModel.self, successHandle: { (result) in
            self.departmentsData = result.data
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
            self.determineHandle()
        }, errorHandle: { (error) in
            self.tableView.mj_header.endRefreshing()
            MBProgressHUD.showError(error ?? "获取部门列表失败")
        })
    }
    
    /// 修改部门
    private func departmentsChange() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.departmentsChange(userId, selectedIds), t: LoginModel.self, successHandle: { (result) in
            if self.changeBlock != nil {
                self.changeBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "修改部门失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击确定
    @objc private func determineClick() {
        departmentsChange()
    }
}

extension ReplacementDepartmentController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departmentsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelePersonnelCell", for: indexPath) as! SelePersonnelCell
        let row = indexPath.row
        let seleModel = departmentsData[row]
        var isSele = selectedIds.count != 0
        if isSele { // 有数据
            isSele = false
            for index in 0..<selectedIds.count {
                let selectedId = selectedIds[index]
                if selectedId == seleModel.id {
                    isSele = true
                    break
                }
            }
        }
        cell.data = (seleModel.name ?? "", "", isSele)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return initHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var isSele = false
        let model = departmentsData[indexPath.row]
        for index in (0..<selectedIds.count).reversed() {
            let sele = selectedIds[index]
            if sele == model.id {
                isSele = true
                selectedIds.remove(at: index)
                break
            }
        }
        if !isSele {
            selectedIds.append(model.id)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        determineHandle()
    }
}
