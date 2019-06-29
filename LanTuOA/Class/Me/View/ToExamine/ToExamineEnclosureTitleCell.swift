//
//  ToExamineEnclosureTitleCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批 附件标题 cell

import UIKit

class ToExamineEnclosureTitleCell: UITableViewCell {

    /// 必选星星
    private var mustLabel: UILabel!
    var contentLabel: UILabel!
    var enclosureLabel:UILabel!
    /// 点击回调
    var enclosureBlock: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 必选(默认非必选)
    var isMust: Bool? {
        didSet {
            if let isMust = isMust {
                mustLabel.isHidden = !isMust
            }
        }
    }
    
    var dataTile: (String, String)? {
        didSet {
            if let dataTile = dataTile {
                let currentCharactorCount = dataTile.1.count
                if currentCharactorCount > 5 {
                    let sub1 = dataTile.1.prefix(5)
                    contentLabel.text = String(sub1) + "..."
                }else{
                    contentLabel.text = dataTile.1
                }
            }

        }
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        enclosureLabel = UILabel().taxi.adhere(toSuperView: contentView) // “附件”
            .taxi.layout { (make) in
                make.top.equalToSuperview().offset(15)
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-11)
            }
            .taxi.config { (label) in
                label.text = "附件"
                label.textColor = blackColor
                label.font = UIFont.regular(size: 16)
        }
        
        mustLabel = UILabel().taxi.adhere(toSuperView: contentView) // 必选星星
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(enclosureLabel)
                make.right.equalTo(enclosureLabel.snp.left).offset(-3)
            })
            .taxi.config({ (label) in
                label.text = "*"
                label.isHidden = true
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#FF4444")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 点击按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.right.equalToSuperview()
                make.centerY.equalTo(enclosureLabel)
                make.width.equalTo(53)
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "enclosure"), for: .normal)
                btn.addTarget(self, action: #selector(enclosureClick), for: .touchUpInside)
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // “内容”
            .taxi.layout { (make) in
                make.left.equalTo(enclosureLabel.snp.right)
                make.top.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-45)
            }
            .taxi.config { (label) in
                label.text = "提示语言"
                label.textColor = UIColor(hex: "#666666")
                label.font = UIFont.regular(size: 14)
                label.textAlignment = .right
        }
    }
    
    // MARK: - 按钮点击
    /// 点击附件
    @objc private func enclosureClick() {
        if enclosureBlock != nil {
            enclosureBlock!()
        }
    }
}
