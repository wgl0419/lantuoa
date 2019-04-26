//
//  FillInApplyAddPersonnelEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  新增合同人员

import UIKit

class FillInApplyAddPersonnelEjectView: UIView {

    /// 点击选择
    var seleBlock: (() -> ())?
    /// 确定回调
    var determineBlock: ((UsersData, String, String) -> ())?
    /// 人员数据
    var userData: UsersData! {
        didSet {
            contentArray[0] = userData.realname ?? ""
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }
    /// 最大数量
    var maxInput: Array<Int>! {
        didSet {
            for index in 1...2 {
                let max = maxInput[index - 1]
                var regexStr = ""
                let bit = max % 10 // 个位
                let tenPlace = max / 10 // 十位
                if tenPlace == 10 { // 100
                    regexStr = "^100$|^(\\d|[1-9]\\d)$"
                } else if tenPlace == 1 { // 10 ~ 19
                    regexStr = "^(^(\\d|1[0-\(bit)])$"
                } else if tenPlace == 0 { // 0 ~ 9
                    regexStr = "^[0-\(bit)$"
                } else { // 20 ~ 99
                    regexStr = "^(\\d|[1-1]\\d)|^(\\d|[1-\(tenPlace)][0-\(bit)])$"
                }
                regexArray[index] = regexStr
                tableView.reloadData()
            }
        }
    }
    /// 白色背景框
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// tableview
    private var tableView: UITableView!
    /// 确定按钮
    private var determineBtn: UIButton!
    
    
    /// 标题
    private let titleArray = ["合同人员", "业绩（%）", "提成（%）"]
    /// 提示
    private let placeholderArray = ["请选择", "请输入", "请输入"]
    /// 内容
    private var contentArray = ["", "", ""]
    /// 数量限制
    private var regexArray = ["", "", ""]
    
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
                label.text = "新增合同人员"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.backgroundColor = UIColor(hex: "#F1F1F1")
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: whiteView) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(100)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
                tableView.register(FillInApplyFieldViewCell.self, forCellReuseIdentifier: "FillInApplyFieldViewCell")
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
        
        determineBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(tableView.snp.bottom)
                make.right.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle("确认新增", for: .normal)
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
                make.top.left.bottom.equalTo(determineBtn)
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
        if determineBlock != nil {
            determineBlock!(userData, contentArray[1], contentArray[2])
        }
        hidden()
    }
}

extension FillInApplyAddPersonnelEjectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
            cell.data = (titleArray[row], placeholderArray[row])
            cell.contentStr = contentArray[row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyFieldViewCell", for: indexPath) as! FillInApplyFieldViewCell
            cell.regexStr = regexArray[row]
            cell.data = (titleArray[row], placeholderArray[row])
            cell.contentStr = contentArray[row]
            cell.inputBlock = { [weak self] (contentStr) in
                self?.contentArray[row] = contentStr
            }
            cell.isNumber = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            if seleBlock != nil {
                seleBlock!()
            }
        }
    }
}
