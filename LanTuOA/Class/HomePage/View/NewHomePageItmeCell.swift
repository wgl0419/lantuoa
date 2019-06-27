//
//  NewHomePageItmeCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class NewHomePageItmeCell: UICollectionViewCell {
    
    var nameLabel: UILabel!
    var numberLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews(){
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(5)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#999999")
                label.font = UIFont.medium(size: 14)
                label.textAlignment = .center
                label.text = "田园"
            })
        
        numberLabel = UILabel().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(17)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#222222")
                label.font = UIFont.medium(size: 12)
                label.textAlignment = .center
                label.text = "6200元"
            })
    }
    
}
