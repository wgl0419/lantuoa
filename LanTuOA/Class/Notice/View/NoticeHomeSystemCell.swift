//
//  NoticeHomeSystemCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/3.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  通知首页 系统通知 cell

import UIKit

class NoticeHomeSystemCell: UITableViewCell {
    
    /// 数据
    var data: NotifyListData? {
        didSet {
            if let data = data {
                nameLabel.text = data.title
                contentLabel.text = data.content
                let date = Date(timeIntervalSince1970: TimeInterval(data.createdTime))
                timeLabel.text = timeHandle(date: date)
                let type = data.type ?? "1"
                var imageNameStr = ""
                switch type {
                case "1": // 系统通知
                    imageNameStr = "system"
                case "2": // 审批通知
                    imageNameStr = "approval"
                case "3": // 工作交接
                    imageNameStr = "Invitation"
                case "4": // 工作组
                    imageNameStr = "Invitation"
                default: break
                }
                portraitImageView.image = UIImage(named: imageNameStr)
            }
        }
    }
    /// 系统类型
    var isSystem: Bool? {
        didSet {
            if let isSystem = isSystem {
                agreeBtn.isHidden = isSystem
                refuseBtn.isHidden = isSystem
            }
        }
    }
    
    /// 拒绝回调
    var refuseBlock: ((Int) -> ())?
    /// 同意回调
    var agreeBlock: (() -> ())?
    
    /// 白色背景图
    private var whiteView: UIView!
    /// 时间
    private var timeLabel: UILabel!
    /// 头像
    private var portraitImageView: UIImageView!
    /// 名称
    private var nameLabel: UILabel!
    /// 内容
    private var contentLabel: UILabel!
    /// 同意按钮
    private var agreeBtn: UIButton!
    /// 拒绝按钮
    private var refuseBtn: UIButton!
    
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
        
        portraitImageView = UIImageView().taxi.adhere(toSuperView: whiteView) // 头像
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(10)
                make.width.height.equalTo(20)
            })
            .taxi.config({ (imageView) in
                imageView.layer.cornerRadius = 10
                imageView.layer.masksToBounds = true
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(portraitImageView)
                make.left.equalTo(portraitImageView.snp.right).offset(5)
            })
            .taxi.config({ (label) in
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(nameLabel)
                make.right.equalToSuperview().offset(-20)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.numberOfLines = 0
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
        agreeBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 同意按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(20)
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
                make.left.equalTo(nameLabel)
                make.bottom.equalTo(agreeBtn)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#999999")
            })
    }
    
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
        let view = SeleVisitModelView(title: "拒绝原因", content: ["已存在项目/客户/拜访对象", "名字不合理"])
        view.didBlock = { [weak self] (seleIndex) in
            if self?.refuseBlock != nil {
                self?.refuseBlock!(seleIndex)
            }
        }
        view.show()
    }
    
    /// 点击同意
    @objc private func agreeClick() {
        if agreeBlock != nil {
            agreeBlock!()
        }
    }
}

