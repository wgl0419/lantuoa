//
//  NewlyBuildVisitTextViewCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  新建拜访  输入框  cell

import UIKit

class NewlyBuildVisitTextViewCell: UITableViewCell {

    /// 修改内容回调
    var textBlock: ((String) -> ())?
    /// 数据(标题+提示文本)
    var data: (String, String)? {
        didSet {
            if let data = data {
                titleLabel.text = data.0
                textView.placeHolderLabel?.text = data.1
            }
        }
    }
    /// 富文本数据
    var attriData: (NSMutableAttributedString, String)? {
        didSet {
            if let data = attriData {
                titleLabel.attributedText = data.0
                textView.placeHolderLabel?.text = data.1
            }
        }
    }
    /// 内容
    var contentStr: String? {
        didSet {
            if let str = contentStr {
                textView.text = str
                textView.placeHolderLabel?.isHidden = str.count > 0
            }
        }
    }
    /// 必选(默认非必选)
    var isMust: Bool? {
        didSet {
            if let isMust = isMust {
                mustLabel.isHidden = !isMust
            }
        }
    }
    /// 限制长度
    var limit: Int!
    
    /// 标题
    private var titleLabel: UILabel!
    /// 必选星星
    private var mustLabel: UILabel!
    /// 输入框
    private var textView: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        limit = nil
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
            })
        
        mustLabel = UILabel().taxi.adhere(toSuperView: contentView) // 必选星星
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(titleLabel)
                make.right.equalTo(titleLabel.snp.left).offset(-3)
            })
            .taxi.config({ (label) in
                label.text = "*"
                label.isHidden = true
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#FF4444")
            })
        
        let interval = UITextView().textContainer.lineFragmentPadding // 间隔 -> 保持输入框内容和标题对齐
        textView = UITextView().taxi.adhere(toSuperView: contentView) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(110).priority(800)
                make.left.equalToSuperview().offset(15 - interval)
                make.top.equalTo(titleLabel.snp.bottom).offset(10 - interval)
                make.bottom.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (textView) in
                textView.delegate = self
                textView.textColor = blackColor
                textView.font = UIFont.boldSystemFont(ofSize: 16)
            })
    }
}

extension NewlyBuildVisitTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.placeHolderLabel?.isHidden = textView.text.count > 0
        if textBlock != nil {
            textBlock!(textView.text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count == 0 { // 删除
            return true
        }
        if limit != nil {
            var str = textView.text ?? ""
            str.insert(Character(text), at: str.index(str.startIndex, offsetBy: range.location))
            if str.count > limit {
                return false
            }
        }
        return true
    }
}
