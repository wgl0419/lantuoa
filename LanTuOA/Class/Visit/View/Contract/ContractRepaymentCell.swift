//
//  ContractRepaymentCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  回款详情 cell

import UIKit

class ContractRepaymentCell: UITableViewCell {
    
    /// 修改回调
    var editBlock: (() -> ())?
    /// 数据
    var data: ContractPaybackListData! {
        didSet {
            nameLabel.text = data.desc
            moneyLabel.text = data.money.getMoneyStr()
            
            let timeStr = Date(timeIntervalSince1970: TimeInterval(data.payTime)).customTimeStr(customStr: "yyyy-MM-dd")
            timeLabel.text = timeStr
        }
    }
    
    /// 摘要
    private var nameLabel: UILabel!
    /// 回款
    private var moneyLabel: UILabel!
    /// 时间
    private var timeLabel: UILabel!
    /// 修改按钮
    private var editBtn: UIButton!

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
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 摘要
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(4).priority(800)
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(50).priority(800)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
        moneyLabel = UILabel().taxi.adhere(toSuperView: contentView) // 回款
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(3.3).priority(800)
                make.left.equalTo(nameLabel.snp.right).offset(5)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.minimumScaleFactor = 0.5
                label.adjustsFontSizeToFitWidth = true
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
        timeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(moneyLabel.snp.right).offset(5)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
            })
        
        editBtn = UIButton().taxi.adhere(toSuperView: contentView) // 修改按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-5)
            })
            .taxi.config({ (btn) in
                btn.setTitle(" 修改", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setImage(UIImage(named: "edit"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击修改
    @objc private func editClick() {
        if editBlock != nil {
            editBlock!()
        }
    }
}
