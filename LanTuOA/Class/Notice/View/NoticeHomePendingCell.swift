//
//  NoticeHomePendingCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/3.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  通知首页 待处理 cell

import UIKit

class NoticeHomePendingCell: UITableViewCell {
    
    /// 数据 (数据 + 是否是待审批)
    var data: (NotifyCheckListData, Bool)! {
        didSet {
            let checkListData = data.0
            let isCheck = data.1
                initSubViews()
                let date = Date(timeIntervalSince1970: TimeInterval(checkListData.createdTime))
                timeLabel.text = timeHandle(date: date)
                
                titleLabel.text = checkListData.title
                titleLabel.textColor = UIColor(hex: "#FF7744")
                
                let smallData = checkListData.data
                if smallData.count == 1 {
                    let model = smallData.first!
                    _ = setTitleAndContent(model.title ?? "", contentStr: model.value ?? "", lastLabel: titleLabel, isLast: true)
                }
                var lastLabel = titleLabel
                for index in 0..<smallData.count {
                    let model = smallData[index]
                    let label = setTitleAndContent(model.title ?? "", contentStr: model.value ?? "", lastLabel: lastLabel, isLast: index == smallData.count - 1)
                    lastLabel = label
                }
            
            agreeBtn.isHidden = !isCheck
            refuseBtn.isHidden = !isCheck
            statusLabel.isHidden = isCheck
            statusLabel.text = checkListData.personStatus == 2 ? "已同意" : "已拒绝"
            statusLabel.textColor = checkListData.personStatus == 2 ? UIColor(hex: "#5FB9A1") : UIColor(hex: "#5FB9A1")
        }
    }
    /// 拒绝回调
    var refuseBlock: ((Int?) -> ())?
    /// 同意回调
    var agreeBlock: (() -> ())?
    
    /// 白色背景
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// 同意按钮
    private var agreeBtn: UIButton!
    /// 拒绝按钮
    private var refuseBtn: UIButton!
    /// 状态
    private var statusLabel: UILabel!
    /// 时间
    private var timeLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.removeAllSubviews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        backgroundColor = UIColor(hex: "#F3F3F3")
        
        whiteView = UIView().taxi.adhere(toSuperView: contentView) // 白色背景图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-5)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
                view.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.16).cgColor
                view.layer.shadowRadius = 3
                view.layer.cornerRadius = 4
                view.layer.shadowOpacity = 1
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-20)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        agreeBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 同意按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview().offset(-15)
                make.height.equalTo(33)
                make.width.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.setTitle("同意", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#2E4695")
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.addTarget(self, action: #selector(agreeClick), for: .touchUpInside)
            })
        
        statusLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 状态
            .taxi.layout(snapKitMaker: { (make) in
                make.right.bottom.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 16)
            })
        
        refuseBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 拒绝按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.width.height.equalTo(agreeBtn)
                make.right.equalTo(agreeBtn.snp.left).offset(-10)
            })
            .taxi.config({ (btn) in
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor(hex: "#2E4695").cgColor
                
                btn.backgroundColor = .white
                btn.setTitle("拒绝", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
                btn.addTarget(self, action: #selector(refuseClick), for: .touchUpInside)
            })
        
        timeLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalTo(agreeBtn)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#999999")
            })
    }
    
    
    /// 生成标题+内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题str
    ///   - contentStr: 内容str
    ///   - lastLabel: 跟随的控件
    ///   - isLast: 是否是后一个控件
    /// - Returns: 内容控件
    private func setTitleAndContent(_ titleStr: String, contentStr: String, lastLabel: UILabel?, isLast: Bool) -> UILabel {
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout { (make) in
                make.top.equalTo(lastLabel!.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
            }
            .taxi.config { (label) in
                label.text = titleStr + "："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        let contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout { (make) in
                make.top.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
                make.right.lessThanOrEqualTo(whiteView).offset(-20)
                if isLast {
                    make.bottom.equalTo(agreeBtn.snp.top).offset(-15)
                }
            }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.text = contentStr.count == 0 ? " " : contentStr
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        return contentLabel
    }
    
    /// 时间处理
    private func timeHandle(date: Date) -> String {
        if date.isToday {
            return "今天\(date.dayTimeStr())"
        } else if date.isYesterday {
            return "昨天 \(date.dayTimeStr())"
        } else if date.isYear {
            return date.customTimeStr(customStr: "MM月dd日 HH:mm")
        } else {
            return date.customTimeStr(customStr: "yyyy年MM月dd日 HH:mm")
        }
    }
    
    // MARK: - 按钮点击
    /// 点击拒绝
    @objc private func refuseClick() {
        if data.0.processType == 1 || data.0.processType == 2 {
            let view = SeleVisitModelView(title: "拒绝原因", content: ["已存在项目/客户", "名字不合理"])
            view.didBlock = { [weak self] (seleIndex) in
                if self?.refuseBlock != nil {
                    self?.refuseBlock!(seleIndex)
                }
            }
            view.show()
        } else {
            if refuseBlock != nil {
                refuseBlock!(nil)
            }
        }
    }
    
    /// 点击同意
    @objc private func agreeClick() {
        if agreeBlock != nil {
            agreeBlock!()
        }
    }
}
