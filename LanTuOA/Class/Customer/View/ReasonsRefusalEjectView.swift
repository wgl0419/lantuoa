//
//  ReasonsRefusalEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拒绝原因  弹出视图

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift

class ReasonsRefusalEjectView: UIView {

    /// 修改回调
    var changeBlock: (() -> ())?
    /// 审批id
    var checkId = 0
    
    /// 标题
    private var titleLabel: UILabel!
    /// 白色背景视图
    private var whiteView: UIView!
    /// 输入框
    private var textView: UITextView!
    /// 确定按钮
    private var confirmBtn: UIButton!
    
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
        
        whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(300)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
                view.backgroundColor = .white
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (label) in
                label.text = "其它原因"
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        let top = UITextView().textContainerInset.top
        let lineFragmentPadding = UITextView().textContainer.lineFragmentPadding
        textView = UITextView().taxi.adhere(toSuperView: whiteView) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15 + lineFragmentPadding)
                make.left.equalToSuperview().offset(15 - lineFragmentPadding)
                make.top.equalTo(titleLabel.snp.bottom).offset(15 - top)
                make.height.equalTo(107)
            })
            .taxi.config({ (textView) in
                textView.delegate = self
                textView.font = UIFont.regular(size: 16)
                textView.placeHolderLabel?.text = "输入内容（选填）"
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2)
                make.top.equalTo(textView.snp.bottom)
                make.left.bottom.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.setTitle("取消", for: .normal)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
            })
        
        confirmBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
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
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.bottom.equalTo(confirmBtn)
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(confirmBtn)
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
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
        
        let firstResponder = UIResponder.firstResponder() as! UITextView
        let inputRect = firstResponder.convert(firstResponder.frame, to: self)
        let inputMaxY = inputRect.maxY
        if inputMaxY == endKeyboardRect.origin.y { // 已经弹出到固定位置
            return
        }
        let duration = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Float
        let yOffset = endKeyboardRect.origin.y > inputMaxY ? 0 : endKeyboardRect.origin.y - inputMaxY
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.whiteView.snp.updateConstraints { (make) in
                make.centerY.equalTo(self).offset(yOffset == 0 ? 0 : yOffset + self.deviationHeight)
                self.deviationHeight = yOffset
            }
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Api
    /// 提交拒绝理由
    private func notifyCheckReject() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckReject(checkId, [], [], textView.text), t: LoginModel.self, successHandle: { (result) in
            if self.changeBlock != nil {
                self.changeBlock!()
            }
            MBProgressHUD.dismiss()
            self.hidden()
        }) { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败，请重试")
        }
    }
    
    // MAKR: - 按钮点击
    /// 点击确定
    @objc private func confirmClick() {
        notifyCheckReject()
    }
}

extension ReasonsRefusalEjectView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.placeHolderLabel?.isHidden = textView.text.count > 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count == 0 { // 删除
            return true
        }
        let str = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if str.count > 120 {
            return false
        }
        return true
    }
}
