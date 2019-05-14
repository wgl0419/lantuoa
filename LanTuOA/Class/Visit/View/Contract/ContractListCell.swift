//
//  ContractListCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同列表  cell

import UIKit

class ContractListCell: UITableViewCell {
    
    /// 数据
    var data: ContractListData? {
        didSet {
            if let data = data {
                nameLabel.text = data.name
                numberLabel.text = "(合同编号：\(data.code ?? ""))"
                
                contributionLabel.text = data.rebate.getSpotMoneyStr()
                totalLabel.text = data.totalMoney.getSpotMoneyStr()
                
                let moneyBackStr = data.paybackMoney.getSpotMoneyStr()
                moneyBackLabel.textColor = data.paybackMoney < data.totalMoney ? UIColor(hex: "#FF4444") : UIColor(hex: "#5FB9A1")
                let attriMuStr = NSMutableAttributedString(string: moneyBackStr)
                attriMuStr.changeColor(str: "元", color: blackColor)
                moneyBackLabel.attributedText = attriMuStr
                
                // 时间
                let startTimeStr = Date(timeIntervalSince1970: TimeInterval(data.startTime)).customTimeStr(customStr: "yyyy-MM-dd")
                let endTimeStr = Date(timeIntervalSince1970: TimeInterval(data.endTime)).customTimeStr(customStr: "yyyy-MM-dd")
                if data.startTime != 0 && data.endTime != 0 {
                    timeLabel.text = startTimeStr + " 至 " + endTimeStr
                } else if data.startTime != 0 {
                    timeLabel.text = startTimeStr + "开始"
                } else if data.endTime != 0 {
                    timeLabel.text = startTimeStr + "之前"
                } else {
                    timeLabel.text = "未设置"
                }
                
                // 参与人
                var participateStr = ""
                for model in data.contractUsers {
                    participateStr.append("、\(model.realname ?? "")")
                }
                if participateStr.count > 0 { participateStr.remove(at: participateStr.startIndex) }
                participateLabel.text = participateStr
                
                if data.signTime == 0 {
                    signingTimeLabel.text = "未设置"
                } else {
                    let signingTimeStr = Date(timeIntervalSince1970: TimeInterval(data.signTime)).customTimeStr(customStr: "yyyy-MM-dd")
                    signingTimeLabel.text = signingTimeStr
                }
            }
        }
    }

    /// 标题数组
    private let titleArray = ["实际发布时间：", "组稿费总额：", "合同总额：", "回款总额：", "签约时间：", "参与人员："]
    /// 内容控件数组
    private var contentLabelArray = [UILabel]()
    /// 白色背景框
    private var whiteView: UIView!
    /// 合同名称
    private var nameLabel: UILabel!
    /// 编号
    private var numberLabel = UILabel()
    /// 时间
    private var timeLabel = UILabel()
    /// 稿费
    private var contributionLabel = UILabel()
    /// 总额
    private var totalLabel = UILabel()
    /// 回款
    private var moneyBackLabel = UILabel()
    /// 签约时间
    private var signingTimeLabel = UILabel()
    /// 参与人员
    private var participateLabel = UILabel()
    
    
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
        backgroundColor = UIColor(hex: "#F3F3F3")
        
        whiteView = UIView().taxi.adhere(toSuperView: contentView) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15))
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
                view.layer.shadowColor = UIColor(hex: "#000000", alpha: 0.16).cgColor
                view.layer.shadowRadius = 3
                view.layer.cornerRadius = 4
                view.layer.shadowOpacity = 1
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 合同名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(13)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 蓝色块
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(14)
                make.left.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(3)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        _ = UIImageView().taxi.adhere(toSuperView: whiteView) // 箭头
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "arrow")
            })
        
        numberLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 合同编号
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        contentLabelArray = [timeLabel, contributionLabel, totalLabel, moneyBackLabel, signingTimeLabel, participateLabel]
        for index in 0..<titleArray.count {
            let lastLabel: UILabel! = index == 0 ? numberLabel : contentLabelArray[index - 1]
            let label = UILabel().taxi.adhere(toSuperView: whiteView)
            label.text  = titleArray[index]
            let content = contentLabelArray[index]
            _ = content.taxi.adhere(toSuperView: whiteView)
            setTitle(title: label, content: content, lastLabel: lastLabel, isFirst: index == titleArray.count - 1)
        }
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - lastLabel: 跟随控件
    ///   - isFirst: 是否是第一个控件
    private func setTitle(title: UILabel, content: UILabel, lastLabel: UILabel, isFirst: Bool = false) {
        title.taxi.layout { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(lastLabel.snp.bottom).offset(5)
        }
            .taxi.config { (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        content.taxi.layout { (make) in
            make.top.equalTo(title)
            make.left.equalTo(title.snp.right)
            make.right.lessThanOrEqualToSuperview().offset(-23)
            if isFirst {
                make.bottom.equalToSuperview().offset(-15)
            }
        }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}
