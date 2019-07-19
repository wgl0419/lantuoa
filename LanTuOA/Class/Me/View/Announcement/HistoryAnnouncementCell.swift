//
//  HistoryAnnouncementCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class HistoryAnnouncementCell: UITableViewCell {
    
    var data : AnnouncementListData? {
        didSet {
            if let data = data {
                titleLabel.text = data.createdUserName
                contentLabel.text = data.content
                if data.createdTime != 0 {
                    timeLabel.text = Date(timeIntervalSince1970: TimeInterval(data.createdTime)).yearTimeStr()
                }else{
                    timeLabel.text = "未设置"
                }
            }
        }
    }
    
    /// 白色背景
    private var whiteView: UIView!
    ///图片
    private var imgView : UIImageView!
    ///标题
    private var titleLabel : UILabel!
    ///内容
    private var contentLabel :UILabel!
    ///时间
    private var timeLabel : UILabel!
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle  = .none
        backgroundColor = kMainBackColor
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  initSubViews(){
        
        whiteView = UIView().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview().offset(0)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.cornerRadius = 5
                view.layer.masksToBounds = true
            })

        
        imgView = UIImageView().taxi.adhere(toSuperView: whiteView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(16)
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(10)
            })
            .taxi.config({ (image) in
                image.layer.cornerRadius = 8
                image.layer.masksToBounds = true
                image.image = UIImage(named: "组 348")
            })
        
        titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(imgView.snp.right).offset(5)
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalTo(imgView.snp.top)
                make.height.equalTo(16)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(red: CGFloat(95 / 255.0), green: CGFloat(185 / 255.0), blue: CGFloat(161 / 255.0), alpha:1.0)
                label.font = UIFont.boldSystemFont(ofSize: 11)
                label.text = "新增客户申请"
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(imgView.snp.right).offset(5)
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.height.equalTo(16)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#444444")
                label.font = UIFont.regular(size: 11)
                label.text = "BRT站台喷 绘合同条款"
            })
        
        timeLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(imgView.snp.right).offset(5)
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalTo(contentLabel.snp.bottom).offset(5)
                make.height.equalTo(16)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#777777")
                label.font = UIFont.regular(size: 11)
                label.text = "2019年7月19日 16点40分"
            })
        
    }
}
