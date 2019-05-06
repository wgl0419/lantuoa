//
//  ScreenOtherCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/5.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  筛选 除时间外的其他 cell

import UIKit

class ScreenOtherCell: UITableViewCell {
    
    // 筛选回调
    var screenBlock: (() -> ())?
    
    /// 数据 (标题   提示   内容)
    var data: (String, String, String)? {
        didSet {
            if let titleStr = data?.0, let placeholderStr = data?.1, let contentStr = data?.2 {
                titleLabel.text = titleStr
                if contentStr.count == 0 {
                    screenLabel.text = placeholderStr
                    screenLabel.font = UIFont.medium(size: 12)
                    screenLabel.textColor = UIColor(hex: "#CCCCCC")
                } else {
                    screenLabel.text = contentStr
                    screenLabel.textColor = UIColor(hex: "#2E4695")
                    screenLabel.font = UIFont.boldSystemFont(ofSize: 12)
                }
            }
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    /// 筛选内容
    private var screenLabel: UILabel!

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
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        let screenView = UIView().taxi.adhere(toSuperView: contentView) // 筛选背景框
            .taxi.layout { (make) in
                make.height.equalTo(28)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-20)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
            .taxi.config { (view) in
                view.layer.borderWidth = 1
                view.layer.cornerRadius = 4
                view.layer.borderColor = UIColor(hex: "#999999").cgColor
                view.backgroundColor = UIColor(hex: "#F9F9F9")
        }
        
        _ = UIButton().taxi.adhere(toSuperView: screenView) // 按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.addTarget(self, action: #selector(screenClick), for: .touchUpInside)
            })
        
        screenLabel = UILabel().taxi.adhere(toSuperView: screenView) // 筛选内容
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-20)
            })

        _ = UIImageView().taxi.adhere(toSuperView: screenView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "arrow")
            })
    }
    
    // MARK: - 按钮点击
    /// 点击筛选
    @objc private func screenClick() {
        if screenBlock != nil {
            screenBlock!()
        }
    }
}
