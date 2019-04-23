//
//  CostomerDetailsContractCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户详情  合同cell

import UIKit

class CostomerDetailsContractCell: UITableViewCell {

    /// 数据
    var data: ContractListData? {
        didSet {
            if let data = data {
                nameLabel.text = data.name
                numberLabel.text = data.code
                
                var participateStr = ""
                for model in data.contractUsers {
                    participateStr.append("、\(model.realname ?? "")")
                }
                if participateStr.count > 0 { participateStr.remove(at: participateStr.startIndex) }
                participateLabel.text = participateStr
            }
        }
    }
    
    /// 合同名称
    private var nameLabel: UILabel!
    /// 合同编号
    private var numberLabel: UILabel!
    /// 参与人员
    private var participateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 合同名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        let number = UILabel().taxi.adhere(toSuperView: contentView) // “编号”
            .taxi.layout { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "合同编号："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        numberLabel = UILabel().taxi.adhere(toSuperView: contentView) // 编号
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(number.snp.right)
                make.top.equalTo(number)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
        
        let participate = UILabel().taxi.adhere(toSuperView: contentView) // "参与人员"
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(number.snp.bottom)
        }
            .taxi.config { (label) in
                label.text = "参与人员："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        participateLabel = UILabel().taxi.adhere(toSuperView: contentView) // 参与人员
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview().offset(-15)
                make.left.equalTo(participate.snp.right)
                make.top.equalTo(participate)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
            })
    }
}
