//
//  ApplyHeaderView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ApplyHeaderView: UICollectionReusableView {
    
    /// 展开回调
    var openBlock: (() -> ())?
    /// 是否显示展开按钮
    var canOpen: Bool! {
        didSet {
            openBtn.isHidden = !canOpen
        }
    }
    /// 是否展开
    var isOpen: Bool! {
        didSet {
            openBtn.setTitle(isOpen ? "收起" : "更多", for: .normal)
        }
    }
    /// 标题
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    
    /// 标题
    private var titleLabel: UILabel!
    /// 展开按钮
    private var openBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        titleLabel = UILabel().taxi.adhere(toSuperView: self) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        openBtn = UIButton().taxi.adhere(toSuperView: self) // 展开按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(openClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: self) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击展开
    @objc private func openClick() {
        if openBlock != nil {
            openBlock!()
        }
    }
}
