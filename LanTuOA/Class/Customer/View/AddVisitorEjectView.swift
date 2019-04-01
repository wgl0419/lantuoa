//
//  AddVisitorEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  添加联系人 弹出视图

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift

class AddVisitorEjectView: UIView {

    /// 添加回调
    var addBlock: (() -> ())?
    /// 客户id
    var customerId = -1
    
    /// 灰色背景view
    private var grayView: UIView!
    /// 显示填写的tableview
    private var tableView: UITableView!
    /// 确认按钮
    private var confirmBtn: UIButton!
    
    /// 标题
    private let titleArray = ["名称", "联系号码", "职位"]
    /// 提示
    private let placeholderArray = ["请输入", "请输入", "请输入"]
    /// 选中内容
    private var seleStrArray = ["", "", ""]
    /// 记录当前偏移的高度
    private var deviationHeight: CGFloat = 0
    
    
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
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: grayView) // “新增拜访人”
            .taxi.layout { (make) in
                make.height.equalTo(55)
                make.top.left.right.equalToSuperview()
            }
            .taxi.config { (label) in
                label.text = "新增拜访人"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
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
    /// 新增联系人
    private func customerContactSave() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.customerContactSave(customerId, seleStrArray[0], seleStrArray[1], seleStrArray[2]), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.showSuccess("添加成功")
            if self.addBlock != nil {
                self.addBlock!()
            }
            self.hidden()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "添加失败")
        })
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
        
        if !isCan {
            MBProgressHUD.showError("请先完成内容的输入")
        } else if seleStrArray[1].isRegexMobile() {
            MBProgressHUD.showError("请填写正确的手机号码")
        } else {
            customerContactSave()
        }
    }
}

extension AddVisitorEjectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTextViewCell", for: indexPath) as! CustomerTextViewCell
        cell.data = (titleArray[row], placeholderArray[row])
        cell.tableView = tableView
        cell.stopBlock = { [weak self] (str) in
            self?.seleStrArray[row] = str
        }
        return cell
    }
}
