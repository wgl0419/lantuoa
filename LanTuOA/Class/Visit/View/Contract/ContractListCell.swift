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
                numberLabel.text = data.code
                
                contributionLabel.text = String(format: "%.2f元", data.rebate)
                totalLabel.text = String(format: "%.2f元", data.totalMoney)
                moneyBackLabel.text = String(format: "%.2f元", data.paybackMoney)
                
                // 时间
                let startTimeStr = Date(timeIntervalSince1970: TimeInterval(data.startTime)).customTimeStr(customStr: "yyyy-MM-dd")
                let endTimeStr = Date(timeIntervalSince1970: TimeInterval(data.endTime)).customTimeStr(customStr: "yyyy-MM-dd")
                timeLabel.text = startTimeStr + " 至 " + endTimeStr
                
                // 参与人
                var participateStr = ""
                for model in data.contractUsers {
                    participateStr.append("、\(model.realname ?? "")")
                }
                if participateStr.count > 0 { participateStr.remove(at: participateStr.startIndex) }
                participateLabel.text = participateStr
                
                if data.signTime == 0 {
                    let signingTimeStr = Date(timeIntervalSince1970: TimeInterval(data.signTime)).customTimeStr(customStr: "yyyy-MM-dd")
                    signingTimeLabel.text = signingTimeStr
                } else {
                    signingTimeLabel.text = "未设置"
                }
            }
        }
    }

    /// 标题数组
    private let titleArray = ["合同编号：", "实际发布时间：", "组稿费总额：", "合同总额：", "回款总额：", "签约时间：", "参与人员："]
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
        
        contentLabelArray = [numberLabel, timeLabel, contributionLabel, totalLabel, moneyBackLabel, signingTimeLabel, participateLabel]
        for index in 0..<titleArray.count {
            let lastLabel: UILabel! = index == 0 ? nameLabel : contentLabelArray[index - 1]
            setTitle(titleStr: titleArray[index], contentLabel: contentLabelArray[index], lastLabel: lastLabel, isLast: index == titleArray.count - 1)
        }
    }
    
    /// 设置文本
    ///
    /// - Parameters:
    ///   - titleStr: 标题
    ///   - contentLabel: 内容控件
    ///   - lastLabel: 跟随的文本
    ///   - isLast: 是否是最后一行
    private func setTitle(titleStr: String, contentLabel: UILabel, lastLabel: UILabel, isLast: Bool) {
        let titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout { (make) in
                make.top.equalTo(lastLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        contentLabel.taxi.adhere(toSuperView: whiteView) // 内容
            .taxi.layout { (make) in
                make.top.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
                make.right.equalToSuperview().offset(-23)
                if isLast {
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
