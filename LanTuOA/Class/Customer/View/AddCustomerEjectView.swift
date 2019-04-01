//
//  AddCustomerEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  新增客户  弹出视图

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift

class AddCustomerEjectView: UIView {
    
    /// 添加回调
    var addBlock: (() -> ())?
    /// 修改的数据
    var modifyData: (String, [String])? {
        didSet {
            if let data = modifyData {
                titleLabel.text = data.0
                seleStrArray = data.1
                tableView.reloadData()
            }
        }
    }
    
    /// 灰色背景view
    private var grayView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// 显示填写的tableview
    private var tableView: UITableView!
    /// 确认按钮
    private var confirmBtn: UIButton!
    
    
    /// 标题
    var titleStr = "新增客户"
    /// 标题
    private let titleArray = ["客户名称", "客户类型", "所属行业", "公司地址", "公司全名"]
    /// 提示
    private let placeholderArray = ["请输入", "请选择", "请选择", "请输入", "请输入"]
    /// 选中内容
    private var seleStrArray = ["", "", "", "", ""]
    /// 记录当前偏移的高度
    private var deviationHeight: CGFloat = 0
    /// 客户类型
    private var customerType = -1
    /// 行业id
    private var customerIndustryId = -1
    /// 行业数据
    private var customerIndustryData = [CustomerIndustryListData]()
    /// 是否是修改
    private var isModify = false
    
    
    override init(frame: CGRect) {
        super.init(frame: ScreenBounds)
        initSubViews()
        addKeyboardNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
        IQKeyboardManager.shared.previousNextDisplayMode = .Default
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
        grayView = UIView().taxi.adhere(toSuperView: self) // 灰色背景view
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().offset(-76)
                make.center.equalToSuperview()
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
                view.backgroundColor = UIColor(hex: "#F1F1F1")
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: grayView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(55)
                make.top.left.right.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.text = titleStr
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: grayView) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.right.equalTo(grayView)
                make.height.equalTo(250)
            })
            .taxi.config({ (tableView) in
                tableView.bounces = false
                tableView.delegate = self
                tableView.dataSource = self
                tableView.register(CustomerTextViewCell.self, forCellReuseIdentifier: "CustomerTextViewCell")
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: grayView) // 取消按钮
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
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        confirmBtn = UIButton().taxi.adhere(toSuperView: grayView) // 确定按钮
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
        
        layoutIfNeeded()
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(tableView.contentSize.height)
        }
        
    }
    
    
    // MARK: - 通知
    /// 添加键盘通知
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        
        let endKeyboardRect = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! CGRect
        
        let inputRect = tableView.cellForRow(at: IndexPath(row: 4, section: 0))?.frame
        let inputMaxY = (inputRect?.maxY ?? 0) + tableView.y + grayView.y
        
        if inputMaxY == endKeyboardRect.origin.y { // 已经弹出到固定位置
            return
        }
        let duration = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Float
        let yOffset = endKeyboardRect.origin.y > inputMaxY ? 0 : endKeyboardRect.origin.y - inputMaxY
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.grayView.snp.updateConstraints { (make) in
                make.centerY.equalTo(self).offset(yOffset == 0 ? 0 : yOffset + self.deviationHeight)
                self.deviationHeight = yOffset
            }
        }
        
    }
    
    // MARK: - Api
    /// 新增客户
    private func customerSave() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.customerSave(seleStrArray[0], seleStrArray[4], seleStrArray[3], customerType, customerIndustryId), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.showSuccess("新增客户成功")
            if self.addBlock != nil {
                self.addBlock!()
            }
            self.hidden()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "新增客户失败")
        })
    }
    
    /// 获取行业列表
    private func customerIndustryList() {
        if customerIndustryData.count == 0 {
            MBProgressHUD.showWait("")
            _ = APIService.shared.getData(.customerIndustryList(), t: CustomerIndustryListModel.self, successHandle: { (result) in
                MBProgressHUD.dismiss()
                self.customerIndustryData = result.data
                self.customerIndustryList()
            }, errorHandle: { (error) in
                MBProgressHUD.showError(error ?? "获取行业列表失败")
            })
        } else {
            var contentStrArray = [String]()
            for model in customerIndustryData {
                contentStrArray.append(model.name ?? "")
            }
            let view = SeleVisitModelView(title: "选择行业类型", content: contentStrArray)
            view.didBlock = { [weak self] (seleIndex) in
                self?.seleStrArray[2] = contentStrArray[seleIndex]
                self?.customerIndustryId = self?.customerIndustryData[seleIndex].id ?? 0
                self?.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
            }
            view.show()
        }
        
    }
    
    // MARK: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    /// 点击确认
    @objc private func confirmClick() {
        var isCan = true
        for str in seleStrArray {
            if str.count == 0 {
                isCan = false
                break
            }
        }
        if isCan {
            customerSave()
        } else {
            MBProgressHUD.showError("请先完成内容的输入")
        }
    }
}

extension AddCustomerEjectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if placeholderArray[row] == "请选择" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
            cell.data = (titleArray[row], placeholderArray[row])
            cell.contentStr = seleStrArray[row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTextViewCell", for: indexPath) as! CustomerTextViewCell
            cell.data = (titleArray[row], placeholderArray[row])
            cell.contentStr = seleStrArray[row]
            cell.tableView = tableView
            if row == 3 { // 地址可输入3行
                cell.limitRow = 3
            } else if row == 4 { // 公司全称可输入2行
                cell.limitRow = 2
            }
            cell.stopBlock = { [weak self] (str) in
                self?.seleStrArray[row] = str
                tableView.snp.updateConstraints { (make) in
                    make.height.equalTo(tableView.contentSize.height)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        if row == 1 { // 客户类型
            let contentArray = ["公司客户", "普通客户", "开发中客户"]
            let view = SeleVisitModelView(title: "选择客户类型", content: contentArray)
            view.didBlock = { [weak self] (seleIndex) in
                self?.customerType = seleIndex + 1
                self?.seleStrArray[1] = contentArray[seleIndex]
                tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            }
            view.show()
        } else if row == 2 { // 所属行业
            customerIndustryList()
        }
    }
}
