//
//  NoticeHomeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  通知 首页 cell

import UIKit

class NoticeHomeCell: UITableViewCell {

    /// 拒绝回调
    var refuseBlock: (() -> ())?
    /// 同意回调
    var agreeBlock: (() -> ())?
    
    /// 时间
    private var timeLabel: UILabel!
    /// 头像
    private var portraitImageView: UIImageView!
    /// 名称
    private var nameLabel: UILabel!
    /// 标题
    private var titleLabel: UILabel!
    /// 内容
    private var contentLabel: UILabel!
    /// 状态按钮 -> 遮挡拒绝 同意按钮
    private var stateBtn: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        backgroundColor = UIColor(hex: "#F3F3F3")
        
        let str = "3月18日 08:18"
        let width = str.getTextSize(font: UIFont.medium(size: 10), maxSize: CGSize(width: 999, height: 999)).width
        timeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(24)
                make.width.equalTo(width + 20)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "3月18日 08:18"
                label.textColor = .white
                label.textAlignment = .center
                label.font = UIFont.medium(size: 10)
                label.backgroundColor = UIColor(hex: "#D9D9D9")
                
                label.layer.cornerRadius = 4
                label.layer.masksToBounds = true
            })
        
        portraitImageView = UIImageView().taxi.adhere(toSuperView: contentView) // 头像
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(40)
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(timeLabel.snp.bottom).offset(20)
            })
            .taxi.config({ (imageView) in
                imageView.backgroundColor = .gray
                imageView.layer.cornerRadius = 20
                imageView.layer.masksToBounds = true
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 姓名
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(portraitImageView)
                make.left.equalTo(portraitImageView.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.text = "测试"
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#999999")
            })
        
        let whiteView = UIView().taxi.adhere(toSuperView: contentView) // 白色背景框
            .taxi.layout { (make) in
                make.left.equalTo(nameLabel)
                make.right.equalToSuperview().offset(-41)
                make.top.equalTo(portraitImageView.snp.centerY)
                make.bottom.equalToSuperview().offset(-15)
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
                view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
                view.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.16).cgColor
                view.layer.shadowRadius = 3
                view.layer.cornerRadius = 4
                view.layer.shadowOpacity = 1
        }
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "测试"
                label.font = UIFont.medium(size: 14)
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
            })
            .taxi.config({ (label) in
                label.text = "蒙冠州邀请您加入“1号小分队”工作组"
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 拒绝按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(37)
                make.left.bottom.equalToSuperview()
                make.top.equalTo(contentLabel.snp.bottom).offset(15)
                make.width.equalToSuperview().dividedBy(2).priority(800)
            })
            .taxi.config({ (btn) in
                btn.setTitle("拒绝", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.setTitleColor(UIColor(hex: "#FF4444"), for: .normal)
                btn.addTarget(self, action: #selector(refuseClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 同意按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.bottom.equalToSuperview()
                make.top.equalTo(contentLabel.snp.bottom).offset(15)
                make.width.equalToSuperview().dividedBy(2).priority(800)
            })
            .taxi.config({ (btn) in
                btn.setTitle("同意", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(agreeClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(15)
                make.bottom.centerX.equalToSuperview()
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        stateBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 状态按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(15)
                make.left.right.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.isHidden = true
                btn.titleLabel?.font = UIFont.medium(size: 12)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(15)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击拒绝
    @objc private func refuseClick() {
        if refuseBlock != nil {
            refuseBlock!()
        }
    }
    
    /// 点击同意
    @objc private func agreeClick() {
        if agreeBlock != nil {
            agreeBlock!()
        }
    }
}
