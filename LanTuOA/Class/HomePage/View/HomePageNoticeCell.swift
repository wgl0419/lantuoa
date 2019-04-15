//
//  HomePageNoticeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  首页 通知 cell

import UIKit

class HomePageNoticeCell: UITableViewCell {
    
    /// 第一个通知的时间
    private var firstTimeLabel: UILabel!
    /// 第一个通知的内容
    private var firstContentLabel: UILabel!
    /// 第一个通知前面的点
    private var firstSpot: UIView!
    /// 第二个通知的时间
    private var secondTimeLabel: UILabel!
    /// 第二个通知的内容
    private var secondContentLabel: UILabel!
    /// 第二个通知前面的点
    private var secondSpot: UIView!

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
        let imageView = UIImageView().taxi.adhere(toSuperView: contentView) // 通知图标
            .taxi.layout { (make) in
                make.width.height.equalTo(40).priority(800)
                make.top.equalTo(contentView).offset(10)
                make.left.equalTo(contentView).offset(15)
                make.bottom.equalTo(contentView).offset(-10)
        }
            .taxi.config { (imageView) in
                imageView.image = UIImage(named: "notice")
        }
        
        firstContentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 第一个内容
        firstTimeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 第一个时间
        
        firstContentLabel.taxi.layout { (make) in
            make.top.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(24)
        }
            .taxi.config { (label) in
                label.text = "123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        firstTimeLabel.taxi.layout { (make) in
            make.right.lessThanOrEqualTo(contentView)
            make.top.equalTo(firstContentLabel)
            make.left.equalTo(firstContentLabel.snp.right).offset(8)
        }
            .taxi.config { (label) in
                label.text = "123分钟"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        firstSpot = UIView().taxi.adhere(toSuperView: contentView) // 第一个通知前面的点
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(3)
                make.centerY.equalTo(firstContentLabel)
                make.right.equalTo(firstContentLabel.snp.left).offset(-9)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 1.5
                view.layer.masksToBounds = true
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        secondContentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 第一个内容
        secondTimeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 第一个时间
        
        secondContentLabel.taxi.layout { (make) in
            make.bottom.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(24)
            }
            .taxi.config { (label) in
                label.text = "123123123123123123123"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        secondTimeLabel.taxi.layout { (make) in
            make.right.lessThanOrEqualTo(contentView)
            make.top.equalTo(secondContentLabel)
            make.left.equalTo(secondContentLabel.snp.right).offset(8)
            }
            .taxi.config { (label) in
                label.text = "123分钟"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        secondSpot = UIView().taxi.adhere(toSuperView: contentView) // 第一个通知前面的点
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(3)
                make.centerY.equalTo(secondContentLabel)
                make.right.equalTo(secondContentLabel.snp.left).offset(-9)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 1.5
                view.layer.masksToBounds = true
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
    }
}
