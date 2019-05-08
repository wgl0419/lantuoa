//
//  FillInApplyTextViewCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/12.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请 输入框 cell

import UIKit

class FillInApplyTextViewCell: UITableViewCell {
    
    /// 输入回调
    var inputBlock: ((String) -> ())?
    /// 数据(标题+提示文本)
    var data: (String, String)? {
        didSet {
            if let data = data {
                titleLabel.text = data.0
                textView.placeHolderLabel?.text = data.1
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
                textView.text = str
            }
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    /// 输入框
    private var textView: UITextView!
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
                make.top.equalToSuperview().offset(11)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
            })
        
        
        starLabel = UILabel().taxi.adhere(toSuperView: contentView) // 星号
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(5)
                make.centerY.equalTo(titleLabel)
            })
            .taxi.config({ (label) in
                label.text = "*"
                label.isHidden = true
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#FF4444")
            })
        
        let top = UITextView().textContainerInset.top
        let lineFragmentPadding = UITextView().textContainer.lineFragmentPadding
        textView = UITextView().taxi.adhere(toSuperView: contentView) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(90).priority(800)
                make.bottom.equalToSuperview().offset(-10 + top)
                make.top.equalTo(titleLabel.snp.bottom).offset(10 - top)
                make.left.equalToSuperview().offset(15 - lineFragmentPadding)
                make.right.equalToSuperview().offset(-15 + lineFragmentPadding)
            })
            .taxi.config({ (textView) in
                textView.delegate = self
                textView.font = UIFont.medium(size: 16)
                textView.placeHolderLabel?.text = "请输入"
            })
    }
}

extension FillInApplyTextViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) { // 处理输入纯英文后 点击其他输入框 造成使用了纠正后的英文的bug
        if inputBlock != nil {
            inputBlock!(textView.text)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if inputBlock != nil {
            inputBlock!(textView.text)
        }
        textView.placeHolderLabel?.isHidden = textView.text.count > 0
    }
}
