//
//  ToExamineDescController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  申请备注 填写

import UIKit
import MBProgressHUD

class ToExamineDescController: UIViewController {

    /// 备注
    enum DescType {
        /// 同意
        case agree
        /// 拒绝
        case refuse
    }
    
    /// 审批id
    var checkId = 0
    /// 备注类型
    var descType: DescType = .agree
    /// 修改回调
    var changeBlock: (() -> ())?
    
    /// 输入框
    private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = .white
        title = descType == .agree ? "确认同意" : "确认拒绝"
        
        let btnView = UIButton().taxi.adhere(toSuperView: view) // 按钮背景图
            .taxi.layout { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(72 + (isIphoneX ? SafeH : 18))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        _ = UIView().taxi.adhere(toSuperView: btnView) // 灰色条
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(10)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: btnView) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(18)
                make.width.equalToSuperview().offset(-30)
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.layer.cornerRadius = 4
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#2E4695")
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.setTitle(descType == .agree ? "确认同意" : "确认拒绝", for: .normal)
                btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
            })
        
        let top = UITextView().textContainerInset.top
        let lineFragmentPadding = UITextView().textContainer.lineFragmentPadding
        textView = UITextView().taxi.adhere(toSuperView: view) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20 - top)
                make.left.equalToSuperview().offset(15 - lineFragmentPadding)
                make.right.equalToSuperview().offset(-15 + lineFragmentPadding)
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (textView) in
                textView.delegate = self
                textView.font = UIFont.medium(size: 14)
                textView.placeHolderLabel?.text = "请输入审批意见"
            })
    }
    
    // MARK: - Api
    /// 拒绝审批-非创建客户/项目
    private func notifyCheckReject() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckReject(checkId, textView.text), t: LoginModel.self, successHandle: { (result) in
            if self.changeBlock != nil {
                self.changeBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 同意审批
    private func notifyCheckAgree() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckAgree(checkId, textView.text), t: LoginModel.self, successHandle: { (result) in
            if self.changeBlock != nil {
                self.changeBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击确定按钮
    @objc private func confirmClick() {
        if descType == .agree {
            notifyCheckAgree()
        } else {
            notifyCheckReject()
        }
    }
}

extension ToExamineDescController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.placeHolderLabel?.isHidden = textView.text.count > 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count == 0 { // 删除
            return false
        }
        var str = textView.text ?? ""
        str.insert(Character(text), at: str.index(str.startIndex, offsetBy: range.location))
        if str.count > 127 {
            return false
        }
        return true
    }
}
