//
//  FillInApplyFieldViewCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/12.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请  数字输入框  cell

import UIKit

class FillInApplyFieldViewCell: UITableViewCell {
    

    /// 输入回调
    var inputBlock: ((String) -> ())?
    /// 数据(标题+提示文本)
    var data: (String, String)? {
        didSet {
            if let data = data {
                titleLabel.text = data.0
                textField.placeholder = data.1
            }
        }
    }
    /// 必选(默认非必选)
    var isMust: Bool? {
        didSet {
            if let isMust = isMust {
                starLabel.isHidden = !isMust
            }
        }
    }
    /// 内容
    var contentStr: String? {
        didSet {
            if let str = contentStr {
                textField.text = str
            }
        }
    }
    /// 正则式 (默认两位小数)
    var regexStr = "(^[1-9](\\d+)?([.]\\d{0,2})?$)|(^0$)|(^\\d[.]\\d{0,2}$)"
    /// 输入类型是否是数字
    var isNumber: Bool? {
        didSet {
            if let isNumber = isNumber {
                textField.keyboardType = isNumber ? .decimalPad : .default
            }
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    /// 输入框
    private var textField: UITextField!
    /// 星号
    private var starLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(50).priority(800)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
        
        starLabel = UILabel().taxi.adhere(toSuperView: contentView) // 星号
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(5)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.text = "*"
                label.isHidden = true
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#FF4444")
            })
        
        
        textField = UITextField().taxi.adhere(toSuperView: contentView) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(titleLabel.snp.right).offset(15)
                make.right.equalToSuperview().offset(-30)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (textField) in
                textField.textAlignment = .right
                textField.textColor = blackColor
                textField.delegate = self
                textField.font = UIFont.medium(size: 16)
                textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                textField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
            })
    }
    
    /// textField 内容变化
    @objc private func textFieldChange() {
        if inputBlock != nil {
            inputBlock!(textField.text ?? "")
        }
    }
}

extension FillInApplyFieldViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isNumber != nil {
            if string.count == 0 { // 删除
                return true
            }
            let str = (textField.text ?? "") + string
            return str.isRegex(str: regexStr)
        } else {
            return true
        }
    }
}
