//
//  ToExamineCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ToExamineCell: UITableViewCell {
    
    /// 拒绝回调
    var refuseBlock: (() -> ())?
    /// 同意回调
    var agreeBlock: (() -> ())?
    
    
    /// 白色背景view
    private var whiteView: UIView!
    /// 内容视图
    private var detailsView: UIView!
    /// 申请人
    private var applicantLabel = UILabel()
    /// 项目
    private var projectLabel = UILabel()
    /// 客户
    private var cusiomerLabel = UILabel()
    /// 联系人
    private var visitLabel = UILabel()
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
        
        whiteView = UIView().taxi.adhere(toSuperView: contentView) // 白色背景view
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(5)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-5)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.shadowRadius = 3
                view.layer.cornerRadius = 4
                view.layer.shadowOpacity = 1
                view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
                view.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.16).cgColor
            })
        
        detailsView = UIView().taxi.adhere(toSuperView: whiteView) // 内容视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
            })
        
        _ = UIView().taxi.adhere(toSuperView: detailsView) // 底部分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        let applicant = setTitle(titleStr: "申请人：", contentLabel: applicantLabel, lastView: detailsView, position: -1) // 申请人
        let project = setTitle(titleStr: "新增项目：", contentLabel: projectLabel, lastView: applicant) // 新增项目
        let cusiomer = setTitle(titleStr: "新增客户：", contentLabel: cusiomerLabel, lastView: project) // 新增客户
        _ = setTitle(titleStr: "新增联系人：", contentLabel: visitLabel, lastView: cusiomer, position: 1) // 新增联系人
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(55)
                make.left.bottom.equalToSuperview()
                make.top.equalTo(detailsView.snp.bottom)
                make.width.equalToSuperview().dividedBy(2).priority(800)
            })
            .taxi.config({ (btn) in
                btn.setTitle("拒绝", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.setTitleColor(UIColor(hex: "#FF4444"), for: .normal)
                btn.addTarget(self, action: #selector(refuseClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 同意按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.bottom.equalToSuperview()
                make.top.equalTo(detailsView.snp.bottom)
                make.width.equalToSuperview().dividedBy(2).priority(800)
            })
            .taxi.config({ (btn) in
                btn.setTitle("同意", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(agreeClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 中间分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(detailsView.snp.bottom)
                make.bottom.centerX.equalToSuperview()
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        stateBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 状态按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(detailsView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.isHidden = true
                btn.backgroundColor = .white
                btn.titleLabel?.font = UIFont.medium(size: 16)
            })
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题内容
    ///   - contentLabel: 内容文本
    ///   - lastView: 跟随控件
    ///   - position: 位置 (-1顶部  0中间部分 1底部)
    /// - Returns: 标题控件
    private func setTitle(titleStr: String, contentLabel: UILabel, lastView: UIView, position: Int = 0) -> UILabel {
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: detailsView) // 标题
        detailsView.addSubview(contentLabel) // 内容
        
        titleLabel.taxi.layout { (make) in
            make.left.equalToSuperview().offset(15)
            if position == -1 {
                make.top.equalTo(lastView).offset(15)
            } else {
                make.top.equalTo(lastView.snp.bottom).offset(5)
            }
            if position == 1 {
                make.bottom.equalToSuperview().offset(-15)
            }
        }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        contentLabel.taxi.layout { (make) in
            make.top.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right)
            make.right.lessThanOrEqualToSuperview().offset(-15)
        }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        return titleLabel
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

