//
//  ContractRepaymentEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同 回款弹出框

import UIKit
import MBProgressHUD

class ContractRepaymentEjectView: UIView {

    /// 标题
    var titleStr: String! {
        didSet {
            titleLabel.text = titleStr
        }
    }
    /// 数据 (用于修改)
    var data: ContractPaybackListData! {
        didSet {
            contentArray[0] = data.desc ?? ""
            contentArray[1] = String(format: "%.2f", data.money)
            contentArray[2] = Date(timeIntervalSince1970: TimeInterval(data.payTime)).customTimeStr(customStr: "yyyy-MM-dd")
            tableView.reloadData()
        }
    }
    
    /// 修改回调
    var editBlock: ((String, Float, Int) -> ())?
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// tableView
    private var tableView: UITableView!
    
    /// 标题数据
    private let titleArray = ["款项摘要", "回款金额（元）", "时间"]
    /// 提示
    private let placeholderArray = ["请输入", "请输入", "请选择"]
    /// 内容数据
    private var contentArray = ["", "", ""]
    /// 选中的时间戳
    private var timeStamp = 0
    
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
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: whiteView) // tableView
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(150)
                make.left.right.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
            })
            .taxi.config({ (tableView) in
                tableView.bounces = false
                tableView.delegate = self
                tableView.dataSource = self
                tableView.register(CustomerTextViewCell.self, forCellReuseIdentifier: "CustomerTextViewCell")
                tableView.register(FillInApplyFieldViewCell.self, forCellReuseIdentifier: "FillInApplyFieldViewCell")
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
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(tableView.snp.bottom)
                make.right.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(tableView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.centerX.equalToSuperview()
                make.height.equalTo(55)
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        layoutIfNeeded()
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(tableView.contentSize.height)
        }
    }
    
    // MARK: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    /// 点击确定
    @objc private func determineClick() {
        for str in contentArray {
            if str.count == 0 {
                MBProgressHUD.showError("请完成输入")
                return
            }
        }
        if editBlock != nil {
            let money = Float(contentArray[1]) ?? 0
            editBlock!(contentArray[0], money, timeStamp)
        }
        hidden()
    }
}

extension ContractRepaymentEjectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
            cell.data = (titleArray[row], placeholderArray[row])
            cell.contentStr = contentArray[row]
            return cell
        } else if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTextViewCell", for: indexPath) as! CustomerTextViewCell
            cell.data = (titleArray[row], placeholderArray[row])
            cell.contentStr = contentArray[row]
            cell.tableView = tableView
            if row == 0 {
                cell.limit = 25
            }
            cell.stopBlock = { [weak self] (str) in
                self?.contentArray[row] = str
                tableView.snp.updateConstraints { (make) in
                    make.height.equalTo(tableView.contentSize.height)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyFieldViewCell", for: indexPath) as! FillInApplyFieldViewCell
            cell.data = (titleArray[row], placeholderArray[row])
            cell.contentStr = contentArray[row]
            cell.isNumber = true
            cell.inputBlock = { [weak self] (contentStr) in
                self?.contentArray[row] = contentStr
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 2 { // 点击选择时间
            let view = SeleVisitTimeView(limit: true)
            view.seleBlock = { (timeStr) in
                self.timeStamp = timeStr.getTimeStamp(customStr: "yyyy-MM-dd HH:mm")
                self.contentArray[2] = Date(timeIntervalSince1970: TimeInterval(self.timeStamp)).customTimeStr(customStr: "yyyy-MM-dd")
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            view.show()
        }
    }
}
