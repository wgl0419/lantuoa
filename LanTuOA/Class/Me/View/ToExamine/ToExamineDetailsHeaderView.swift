//
//  ToExamineDetailsHeaderView.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ToExamineDetailsHeaderView: UIView {
    
    var ishiddenNuber: Bool!
    /// 数据
    var data: NotifyCheckListData? {
        didSet {
            if let data = data {
                initSubViews()
                titleLabel.text = data.createdUserName
                
                if ishiddenNuber {
                    frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 40)
                    numLabel.isHidden = true
                }else{
                    frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 60)
                    numLabel.attributedText = richText(title: "订单编号：", content: "\(data.id)")
                }
            }
        }
    }

    
    /// 标题
    private var titleLabel: UILabel!
    ///订单编号
    private var numLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {

        titleLabel = UILabel().taxi.adhere(toSuperView: self) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize:18)
            })
        
        numLabel = UILabel().taxi.adhere(toSuperView: self) // 订单编号
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 14)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
    }

    ///处理编号
    private func richText(title:String,content:String) -> NSMutableAttributedString{
        let attrs1 = [NSAttributedString.Key.font : UIFont.regular(size: 14), NSAttributedString.Key.foregroundColor : UIColor(hex: "#999999")]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.regular(size: 14), NSAttributedString.Key.foregroundColor : blackColor]
        
        let attributedString1 = NSMutableAttributedString(string:title, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:content, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        
        return attributedString1
    }
}
