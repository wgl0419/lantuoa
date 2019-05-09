//
//  AchievementsDetailsCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  业绩详情  cell

import UIKit
import MBProgressHUD

class AchievementsDetailsCell: UITableViewCell {
    
    /// 查看细节回调
    var detailsBlock: (() -> ())?
    
    /// 数据 (年份  月份  金额)
    var data: (String, Int, Float)! {
        didSet {
            timeLabel.text = String(format: "%@年%d月", data.0, data.1)
            
            let attriStr = data.2.getSpotMoneyStr()
            let attriMuStr = NSMutableAttributedString(string: attriStr)
            attriMuStr.changeColor(str: attriStr, color: UIColor(hex: "#FF7744"))
            attriMuStr.addUnderline(color: UIColor(hex: "#FF7744"), range: NSRange(location: 0, length: attriMuStr.length))
            moneyBtn.setAttributedTitle(attriMuStr, for: .normal)
        }
    }
    
    /// 月份
    private var timeLabel: UILabel!
    /// 金额
    private var moneyBtn: UIButton!

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
        timeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(40)
                make.height.equalTo(30).priority(800)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        moneyBtn = UIButton().taxi.adhere(toSuperView: contentView) // 金额
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(timeLabel.snp.right).offset(10)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                btn.addTarget(self, action: #selector(moneyClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击金额
    @objc private func moneyClick() {
        guard data.2 > 0 else {
            MBProgressHUD.showError("本月无绩效")
            return
        }
        if detailsBlock != nil {
            detailsBlock!()
        }
    }
}
