//
//  AchievementsDetailsEjectCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  绩效弹框 cell

import UIKit

class AchievementsDetailsEjectCell: UITableViewCell {

    /// 数据
    var data: (Int, NewPerformDetailData)! {
        didSet {
            setContent(isTitle: false, number: data.0, contract: data.1.title ?? "", money: data.1.money)
        }
    }
    /// 是标题
    var isTitle: Bool! {
        didSet {
            setContent(isTitle: true, number: nil, contract: nil, money: nil)
        }
    }
    
    /// 序号
    private var numberLabel: UILabel!
    /// 合同
    private var contractLabel: UILabel!
    /// 金额
    private var moneyLabel: UILabel!
    
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
        numberLabel = UILabel().taxi.adhere(toSuperView: contentView) // 序号
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(35).priority(800)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(35)
            })
            .taxi.config({ (label) in
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
        contractLabel = UILabel().taxi.adhere(toSuperView: contentView) // 合同编号
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(numberLabel.snp.right).offset(15)
                make.width.equalToSuperview().dividedBy(2.5)
            })
            .taxi.config({ (label) in
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
        moneyLabel = UILabel().taxi.adhere(toSuperView: contentView) // 金额
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(contractLabel.snp.right).offset(15)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
    }
    
    /// 设置内容
    private func setContent(isTitle: Bool, number: Int?, contract: String?, money: Float?) {
        if isTitle {
            numberLabel.textColor = UIColor(hex: "#999999")
            contractLabel.textColor = UIColor(hex: "#999999")
            moneyLabel.textColor = UIColor(hex: "#999999")
            numberLabel.text = "序号"
            contractLabel.text = "合同编号"
            moneyLabel.text = "绩效金额"
        } else {
            numberLabel.textColor = blackColor
            contractLabel.textColor = blackColor
            moneyLabel.textColor = UIColor(hex: "#FF7744")
            contractLabel.text = contract!
            moneyLabel.text = String(format: "%.2f元", money!)
            
            let numberStr = "\(number!)"
            numberLabel.text = numberStr.count == 1 ? "0\(number!)" : numberStr
        }
    }
}
