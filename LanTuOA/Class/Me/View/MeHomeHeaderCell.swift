//
//  MeHomeHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  “我”模块  首页 顶部cell

import UIKit

class MeHomeHeaderCell: UITableViewCell {
    
    /// 名称
    private var nameLabel: UILabel!
    /// 职位
    private var positionLabel: UILabel!
    
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
        nameLabel.text = UserInfo.share.userName
        positionLabel.text = UserInfo.share.position
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        backgroundColor = .white
        
        _ = UIImageView().taxi.adhere(toSuperView: contentView) // 背景图
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(159).priority(800) // 没有这句会出现一条灰色分割线
                make.edges.equalToSuperview()
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "me_background")
            })
        
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名字
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(65)
                make.left.equalToSuperview().offset(30)
            })
            .taxi.config({ (label) in
                label.textColor = .white
                label.text = UserInfo.share.userName
                label.font = UIFont.boldSystemFont(ofSize: 24)
            })
        
        positionLabel = UILabel().taxi.adhere(toSuperView: contentView) // 职位
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
            })
            .taxi.config({ (label) in
                label.textColor = .white
                label.font = UIFont.medium(size: 14)
                label.text = UserInfo.share.position
            })
        
        let filletView = UIView().taxi.adhere(toSuperView: contentView) // 圆角
            .taxi.layout { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(16)
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        self.perform(#selector(addClipRectCorner(view:)), with: filletView, afterDelay: 0.01)
    }
    
    // MARK: 定时触发
    /// 设置上面两个脚的圆角
    @objc private func addClipRectCorner(view: UIView) {
        let rectCorner = UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue
        view.clipRectCorner(UIRectCorner(rawValue: rectCorner), cornerRadius: 8)
    }

}

