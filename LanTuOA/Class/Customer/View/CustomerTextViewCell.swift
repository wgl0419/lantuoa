//
//  CustomerTextViewCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/25.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户  输入框  cell

import UIKit

class CustomerTextViewCell: UITableViewCell {
    
    /// 停止输入回调 -> 用于记录
    var stopBlock: ((String) -> ())?
    
    /// 数据(标题+提示文本)
    var data: (String, String)? {
        didSet {
            if let data = data {
                titleLabel.text = data.0
                textView.placeHolderLabel?.text = data.1
                textView.placeHolderLabel?.font = UIFont.medium(size: 14)
                textView.placeHolderLabel?.textColor = UIColor(hex: "#CACACA")
            }
        }
    }
    
    /// 富文本数据(标题+提示文本)
    var attriData: (NSMutableAttributedString, String)? {
        didSet {
            if let data = attriData {
                titleLabel.attributedText = data.0
                textView.placeHolderLabel?.text = data.1
                textView.placeHolderLabel?.font = UIFont.medium(size: 14)
                textView.placeHolderLabel?.textColor = UIColor(hex: "#CACACA")
            }
        }
    }
    /// 内容
    var contentStr: String? {
        didSet {
            if let str = contentStr {
                textView.text = str
                textView.placeHolderLabel?.isHidden = str.count > 0
                self.perform(#selector(textViewDidChange(_:)), with: textView, afterDelay: 0)
            }
        }
    }
    
    /// 父tableview
    var tableView: UITableView!
    /// 限制的行数
    var limitRow: CGFloat = 1
    
    /// 标题
    private var titleLabel: UILabel!
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
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = " "
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
            })
        
        self.layoutIfNeeded()
        let top = UITextView().textContainerInset.top
        textView = UITextView().taxi.adhere(toSuperView: contentView) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(100)
                make.right.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview().offset(-top)
                make.top.equalToSuperview().offset(15 - top)
                make.height.equalTo(titleLabel.height).priority(800)
            })
            .taxi.config({ (textView) in
                textView.delegate = self
                textView.textAlignment = .right
                textView.textColor = blackColor
                textView.font = UIFont.medium(size: 16)
            })
    }
}

extension CustomerTextViewCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) { // 处理输入纯英文后 点击其他输入框 造成使用了纠正后的英文的bug
        if stopBlock != nil {
            stopBlock!(textView.text)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.placeHolderLabel?.isHidden = textView.text.count > 0
        
        let height = textView.contentSize.height // 内容高度
        let top = UITextView().textContainerInset.top // 顶部高度
        let titleHeight = titleLabel.height
        let initialHeight = titleHeight + top * 2 // 初始高度
        let limitHeight = ((titleHeight + 3) * limitRow) < initialHeight ? initialHeight : ((titleHeight + 3) * limitRow) // 限制高度 默认行间距为3
        textView.snp.updateConstraints { (make) in
            make.height.equalTo(height < initialHeight + 1 ? initialHeight : height > limitHeight ? limitHeight : height).priority(800)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        if stopBlock != nil {
            stopBlock!(textView.text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count == 0 && textView.text.count == 0 { // 删除
            return false
        }
        return true
    }
}
