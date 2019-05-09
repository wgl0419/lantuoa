//
//  NewWorkingGroupController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/2.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  新建工作组

import UIKit
import MBProgressHUD

class NewWorkingGroupController: UIViewController {

    /// 项目数据 (id + 名称)
    var projectData: (Int, String)!
    /// 添加成功回调
    var addBlock: (() -> ())?
    
    /// 确定按钮
    private var determineBtn: UIButton!
    /// tableview
    private var tableView: UITableView!
    
    /// 标题数据
    private var titleArray = ["工作组名称", "工作组成员", "项目"]
    /// 提示文本
    private let placeArray = ["请输入名称", "请选择", "请输入名称"]
    /// 选中内容
    private var seleStrArray = ["", "", ""]
    /// 成员id
    private var personIdArray = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "新建工作组"
        view.backgroundColor = .white
        
        seleStrArray[2] = projectData.1
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮背景视图
            .taxi.layout { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(62 + (isIphoneX ? SafeH : 18))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        determineBtn = UIButton().taxi.adhere(toSuperView: btnView) // 确定按钮
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
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(btnView.snp.top)
                make.top.left.right.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.backgroundColor = UIColor(hex: "F3F3F3")
                tableView.register(CustomerTextViewCell.self, forCellReuseIdentifier: "CustomerTextViewCell")
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
            })
    }
    
    /// 点亮确认按钮
    private func determineHandle() {
        var isCompleted = true
        for str in seleStrArray {
            if str.count == 0 {
                isCompleted = false
                break
            }
        }
        determineBtn.isEnabled = isCompleted
        determineBtn.backgroundColor = isCompleted ? UIColor(hex: "#2E4695") : UIColor(hex: "#CCCCCC")
    }
    
    // MARK: - Api
    /// 新建工作组
    private func workGroupCreate() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.workGroupCreate(seleStrArray[0], personIdArray, projectData.0), t: LoginModel.self, successHandle: { (result) in
            if self.addBlock != nil {
                self.addBlock!()
            }
            self.navigationController?.popViewController(animated: true)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "新建失败")
        })
    }
    
    
    // MARK: - 按钮点击
    /// 点击确定
    @objc private func determineClick() {
        workGroupCreate()
    }
}

extension NewWorkingGroupController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return placeArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section != 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTextViewCell", for: indexPath) as! CustomerTextViewCell
            cell.isEdit = section == 0
            cell.data = (titleArray[section], placeArray[section])
            cell.contentStr = seleStrArray[section]
            cell.tableView = tableView
            cell.isMust = true
            if section == 0 {
                cell.limit = 50
            }
            cell.stopBlock = { [weak self] (str) in
                self?.seleStrArray[section] = str
                self?.determineHandle()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
            cell.data = (titleArray[section], placeArray[section])
            cell.contentStr = seleStrArray[section]
            cell.isMust = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sction = indexPath.section
        if sction == 1 { // 选择成员
            let vc = ProjectManageSeleController()
            vc.title = "选择成员"
            vc.isMultiple = true
            vc.backBlock = { [weak self] (idArray, nameArray) in
                if idArray.count > 0 {
                    self?.personIdArray = idArray
                    var personNameStr = ""
                    for str in nameArray {
                        personNameStr.append("、\(str)")
                    }
                    personNameStr.remove(at: personNameStr.startIndex)
                    self?.seleStrArray[sction] = personNameStr
                    tableView.reloadRows(at: [indexPath], with: .fade)
                    self?.determineHandle()
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
