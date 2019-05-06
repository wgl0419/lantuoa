//
//  ModifyNoticeEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/25.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  修改通知弹出框  -> 点击拒绝原因后弹出的界面

import UIKit
import MBProgressHUD

class ModifyNoticeEjectView: UIView {
    
    /// 修改类型
    enum ModifyType {
        /// 已存在
        case alreadyExist
        /// 不合理
        case unreasonable
    }
    /// 存在回调
    var alreadyExistBlock: (([Int]) -> ())?
    /// 不合理回调
    var unreasonableBlock: (([String]) -> ())?
    /// 修改类型
    var modifyType: ModifyType! {
        didSet {
            tableView.reloadData()
            layoutIfNeeded()
            self.perform(#selector(setTableViewHeight), with: nil, afterDelay: 0.01)
        }
    }
    /// 数据
    var data: NotifyCheckListData! {
        didSet {
            contentArray[0] = data.customerName ?? ""
            contentArray[1] = data.projectName ?? ""
            idArray[0] = data.customerId
            idArray[1] = data.projectId
        }
    }
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// tableView
    private var tableView: UITableView!
    /// 确定按钮
    private var determineBtn: UIButton!
    

    /// 标题
    private var titleArray = ["客户", "项目"]
    /// 提示
    private var placeholderArray = [["请选择", "请选择"], ["请输入", "请输入"]]
    /// 内容
    private var contentArray = ["", ""]
    /// 选中id
    private var idArray = [0, 0]
    
    override init(frame: CGRect) {
        super.init(frame: ScreenBounds)
        initSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                view.backgroundColor = .white
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.backgroundColor = UIColor(hex: "#F1F1F1")
                label.text = modifyType == .alreadyExist ? "选择客户/项目" : "修正客户/项目名称"
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: whiteView) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (tableView) in
                tableView.bounces = false
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                tableView.register(CustomerTextViewCell.self, forCellReuseIdentifier: "CustomerTextViewCell")
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(tableView.snp.bottom)
                make.left.bottom.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.setTitle("取消", for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        determineBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(tableView.snp.bottom)
                make.right.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.bottom.equalTo(determineBtn)
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        self.perform(#selector(setTableViewHeight), with: nil, afterDelay: 0.01)
    }
    
    @objc private func setTableViewHeight() {
        layoutIfNeeded()
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(tableView.contentSize.height)
        }
    }
    
    /// 选择客户
    private func seleCustomerHandle() {
        isHidden = true
        let vc = NewlyBuildVisitSeleController()
        vc.type = .customer
        vc.seleBlock = { [weak self] (customerArray) in
            self?.idArray[0] = customerArray.first?.0 ?? -1
            self?.contentArray[0] = customerArray.first?.1 ?? ""
            // 重置数据 -> 防止出现选择拜访对象、项目后 修改客户
            self?.idArray[1] = 0
            self?.contentArray[1] = ""
            self?.tableView.reloadData()
        }
        vc.backBlock = { [weak self] in
            self?.isHidden = false
        }
        let controller = APIService.shared.getCurrentController()
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择项目
    private func selfProjectHandle() {
        isHidden = true
        let vc = NewlyBuildVisitSeleController()
        vc.type = .project(idArray[0], contentArray[0])
        vc.seleBlock = { [weak self] (projectArray) in
            self?.idArray[1] = projectArray.first?.0 ?? -1
            self?.contentArray[1] = projectArray.first?.1 ?? ""
            self?.tableView.reloadData()
        }
        vc.backBlock = { [weak self] in
            self?.isHidden = false
        }
        let controller = APIService.shared.getCurrentController()
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    /// 点击确定
    @objc private func determineClick() {
        for index in 0..<contentArray.count {
            let str = contentArray[index]
            if str.count == 0 {
                var error = ""
                if index == 0 {
                    error = modifyType == .unreasonable ? "请输入客户" : "请选择客户"
                } else {
                    error = modifyType == .unreasonable ? "请输入项目" : "请选择项目"
                }
                MBProgressHUD.showError(error)
                return
            }
        }
        if modifyType == .alreadyExist && alreadyExistBlock != nil { // 名称存在
            alreadyExistBlock!(idArray)
        } else if modifyType == .unreasonable && unreasonableBlock != nil { // 名称不合理
            unreasonableBlock!(contentArray)
        }
        hidden()
    }
}

extension ModifyNoticeEjectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if modifyType == .alreadyExist { // 名称存在 -> 选择
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
            cell.data = (titleArray[row], placeholderArray[1][row])
            cell.contentStr = contentArray[row]
            cell.selectionStyle = .none
            return cell
        } else { // 名称不合理 -> 输入
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTextViewCell", for: indexPath) as! CustomerTextViewCell
            cell.data = (titleArray[row], placeholderArray[0][row])
            cell.contentStr = contentArray[row]
            cell.tableView = tableView
            let isEdit = data.processType == 2 && row == 0
            cell.isEdit = !isEdit
            cell.stopBlock = { [weak self] (str) in
                self?.contentArray[row] = str
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if modifyType == .alreadyExist {
            if indexPath.row == 0 && data.processType == 1 { // 选择客户
                seleCustomerHandle()
            } else if indexPath.row == 1 { // 选择项目
                if contentArray[0].count == 0 {
                    MBProgressHUD.showError("请先选择客户")
                    return
                }
                selfProjectHandle()
            }
        }
    }
}

