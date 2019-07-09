//
//  NewAchievementsListCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class NewAchievementsListCell: UITableViewCell {

    var data :NewPerformUnderData? {
        didSet {
            if let data = data {
                titleLabel.text = data.name
                let tota = data.totalValue.getMoneyStr()
                totalLabel.attributedText = richText(title: "合计：", content: tota)
                let arrData = data.data
                var lastView: UIView = titleLabel
                for inex in 0..<10 {
                    let deltelab = viewWithTag(inex)
                    deltelab?.removeFromSuperview()
                }
                for index in 0..<arrData.count {
                    let model = arrData[index]
                    let testStr = model.value ?? ""
                    let inde = testStr.characters.index(of: ".")
                    var totStr:String?
                    if let inde = inde {
                        let subStr = testStr.substring(to: inde)
                        totStr = subStr
                    }
                    if totStr == ""{
                        totStr = "0"
                    }
                        let label = setTitleAndContent(model.name ?? "", contentStr: totStr ?? "0", lastView: lastView, isLast: index == arrData.count - 1)
                        lastView.tag = index
                        lastView = label
                }
            }
        }
    }
    
    /// 标题
    private var titleLabel: UILabel!
    private var totalLabel: UILabel!
    private var contentLabel:UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews(){
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize:18)
            })
        
        totalLabel = UILabel().taxi.adhere(toSuperView: contentView) // 合计
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(0)
                make.left.equalToSuperview().offset(ScreenWidth/2+40)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(contentView.snp.height)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.textAlignment = .right
                label.font = UIFont.boldSystemFont(ofSize:14)
            })
        
        let rightImage = UIImageView().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(0)
                make.width.equalTo(6)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(contentView.snp.height)
            })
        rightImage.image = UIImage(named: "arrow")
        rightImage.contentMode = .scaleAspectFit
        titleLabel.isUserInteractionEnabled = true
    }
    
    /// 生成标题+内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题str
    ///   - contentStr: 内容str
    ///   - lastLabel: 跟随的控件
    ///   - isLast: 是否是后一个控件
    /// - Returns: 内容控件
    private func setTitleAndContent(_ titleStr: String, contentStr: String, lastView: UIView, isLast: Bool) -> UILabel {
        contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-(ScreenWidth/2-40))
                if isLast {
                    make.bottom.equalToSuperview().offset(-10)
                }
            }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.regular(size: 14)
                let string = titleStr + "："
                label.attributedText = richText(title: string, content: contentStr)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        return contentLabel
    }
    
    ///处理合计
    private func richText(title:String,content:String) -> NSMutableAttributedString{
        let attrs1 = [NSAttributedString.Key.font : UIFont.regular(size: 14), NSAttributedString.Key.foregroundColor : UIColor(hex: "#999999")]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.regular(size: 14), NSAttributedString.Key.foregroundColor : UIColor(hex: "#FF7744")]
        
        let attributedString1 = NSMutableAttributedString(string:title, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:content, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        
        return attributedString1
    }


}
