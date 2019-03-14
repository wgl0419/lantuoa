//
//  HomePageHeaderView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  首页tableview headerView

import UIKit

class HomePageHeaderView: UIView {
    
    /// 点击回调
    var btnBlock: (() -> ())?

    /// 图标
    private var logoImageView: UIImageView!
    /// 标题
    private var titleLabel: UILabel!
    /// 功能按钮
    private var btn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义公有方法
    /// 设置内容
    ///
    /// - Parameters:
    ///   - logoName: 图标名称
    ///   - attriMuStr: 标题富文本
    ///   - btnStr: 按钮文本
    func setContent(logoName: String, attriMuStr: NSMutableAttributedString, btnStr: String) {
        titleLabel.attributedText = attriMuStr
        btn.setTitle("  \(btnStr)  ", for: .normal)
        logoImageView.image = UIImage(named: logoName)
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        backgroundColor = .white
        logoImageView = UIImageView().taxi.adhere(toSuperView: self) /// 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(self)
                make.width.height.equalTo(16)
                make.left.equalTo(self).offset(15)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "")
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: self) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(logoImageView.snp.right).offset(7)
            })
            .taxi.config({ (label) in
                label.text = "我的项目"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
            })
        
        btn = UIButton().taxi.adhere(toSuperView: self)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.right.equalTo(self)
            })
            .taxi.config({ (btn) in
                btn.setTitle("  查看全部  ", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: self) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalTo(self)
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
    }
    
    // MARK: - 按钮点击
    /// 点击按钮
    @objc private func btnClick() {
        if btnBlock != nil {
            btnBlock!()
        }
    }
}
