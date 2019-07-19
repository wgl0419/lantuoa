//
//  HandoverStaffCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  交接员工 cell

import UIKit

class HandoverStaffCell: UITableViewCell {
    
    /// 数据
    var data: WorkExtendListPersonData? {
        didSet {
            if let data = data {
                var nameStr = data.name ?? ""
                let newUserStr = data.lastExtend?.newUserName ?? ""
                let time = data.lastExtend?.createdTime ?? 0
                var timeStr = " "
                if time != 0 {
                    timeStr = Date(timeIntervalSince1970: TimeInterval(data.lastExtend?.createdTime ?? 0)).customTimeStr(customStr: "yyyy-MM-dd")
                }
                
                if data.status == 0 && time == 0 {
                    nameLabel.text = nameStr
                    nameLabel.textColor = UIColor(hex: "#999999")
                    handoverBtn.isHidden = true
                }else if data.status == 0 && time != 0 {
                    let changeStr = "（已交接\(newUserStr)\(timeStr)）"
                    nameStr = nameStr + changeStr
                    nameLabel.text = nameStr
                    nameLabel.textColor = UIColor(hex: "#999999")
                    handoverBtn.isHidden = true
                }else{
                    nameLabel.text = nameStr
                }
                
                
//                if newUserStr.count > 0 {
//                    let changeStr = "（已交接\(newUserStr)\(timeStr)）"
//                    nameStr = nameStr + changeStr
//
//                    let attriMuStr = NSMutableAttributedString(string: nameStr)
//                    attriMuStr.changeColor(str: changeStr, color: UIColor(hex: "#5FB9A1"))
//                    attriMuStr.changeFont(str: changeStr, font: UIFont.boldSystemFont(ofSize: 12))
//                    nameLabel.attributedText = attriMuStr
//                } else {
//                    nameLabel.text = nameStr
//                }
                
//                if newUserStr.count > 0 {
//                    let changeStr = "（已交接\(newUserStr)\(timeStr)）"
//                    nameStr = nameStr + changeStr
//                    nameLabel.text = nameStr
//                    nameLabel.textColor = UIColor(hex: "#999999")
//                    handoverBtn.isHidden = true
//                } else {
//                    nameLabel.text = nameStr
//                }
                
            }
        }
    }

    /// 项目名称
    private var nameLabel: UILabel!
    /// 交接按钮
    private var handoverBtn: UIButton!
    
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
        handoverBtn = UIButton().taxi.adhere(toSuperView: contentView) // 交接按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(48)
                make.top.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-5)
                make.bottom.equalToSuperview().offset(-10)
            })
            .taxi.config({ (btn) in
                btn.setTitle("交接", for: .normal)
                btn.isUserInteractionEnabled = false
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 项目名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(15)
                make.right.equalTo(handoverBtn.snp.left)
                make.bottom.equalToSuperview().offset(-10)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
    }
}
