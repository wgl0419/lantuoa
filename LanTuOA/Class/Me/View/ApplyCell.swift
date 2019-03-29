//
//  ApplyCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  申请 cell

import UIKit

class ApplyCell: UITableViewCell {
    
    /// 白色背景view
    private var whiteView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// 内容
    private var contentLabel = UILabel()
    /// 处理人
    private var disposeLabel = UILabel()
    /// 状态
    private var stateLabel = UILabel()
    
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
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = " "
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 蓝色标志条
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(2)
                make.height.equalTo(18)
                make.centerY.equalTo(titleLabel)
                make.left.equalToSuperview()
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        stateLabel = UILabel().taxi.adhere(toSuperView: whiteView)
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(titleLabel)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 12)
            })
        
        let content = setTitle(titleStr: "申请内容：", contentLabel: contentLabel, lastView: titleLabel, position: -1) // 内容
        let dispose = setTitle(titleStr: "当前处理人：", contentLabel: disposeLabel, lastView: content, position: 1) // 处理人
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
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
        whiteView.addSubview(contentLabel) // 内容
        
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
            make.right.lessThanOrEqualTo(contentLabel)
            }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
        }
        
        contentLabel.taxi.layout { (make) in
            make.top.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right)
            make.right.lessThanOrEqualToSuperview().offset(-15)
            }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
        }
        
        return titleLabel
    }
}
