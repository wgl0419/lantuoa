//
//  ToExamineDetailsTitleCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ToExamineDetailsTitleCell: UITableViewCell {
    /// 标题
    private var titleLabel: UILabel!
    
    ///线
    private var line: UIView!
    private var line2: UIView!
    
    /// 数据
    var data: NotifyCheckListSmallData? {
        didSet {
            if let data = data {
                if data.type == 1{
                    let str = data.title ?? ""
                    let stringStr = str + "："
                    titleLabel.attributedText = richText(title: stringStr, content: data.value ?? "")
                }else if data.type == 2 {
                    titleLabel.text = data.title ?? ""
                    line2.isHidden = false
                }else if data.type == 3 {
                    self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 20)
                    line.isHidden = false
                }

            }
        }
    }//type 2
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        contentView.removeAllSubviews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(5)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-20)
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 14)
                label.textColor = UIColor(hex: "#999999")
            })
        
        
        line = UIView().taxi.adhere(toSuperView: contentView) // 线
            .taxi.layout(snapKitMaker: { (make) in
//                make.top.equalToSuperview().offset(40)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(0)
                make.height.equalTo(1)
            })
            .taxi.config({ (line) in
                line.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                line.isHidden = true

            })
        
        line2 = UIView().taxi.adhere(toSuperView: contentView) // 线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(0)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (line) in
                line.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
                line.isHidden = true

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
