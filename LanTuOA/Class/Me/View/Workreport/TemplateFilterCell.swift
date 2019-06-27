//
//  TemplateFilterCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/25.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class TemplateFilterCell: UICollectionViewCell {
    
    private var titleLabel: UILabel!
//    private var nameBtn: UIButton!
    /// 数据
    var data: WorkReportListData? {
        didSet {
            if let data = data {
                titleLabel.text = data.name
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 职位
            .taxi.layout(snapKitMaker: { (make) in
                make.top.leading.trailing.bottom.equalToSuperview().offset(0.1).priority(800)
                make.bottom.equalToSuperview().offset(-10).priority(800)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#444444")
                label.layer.cornerRadius = 3
                label.layer.masksToBounds = true
                label.text = "库里"
                label.textAlignment = .center
            })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isSelect:Bool? {
        didSet {
            guard let isSelect = isSelect else {
                return
            }
            if isSelect {
                titleLabel.textColor = UIColor.white
                titleLabel.backgroundColor = kMainColor
            }else{
                titleLabel.textColor = UIColor(hex: "#444444")
                titleLabel.backgroundColor = UIColor(hex: "#E5E5E5")

            }
        }
    }
    

}
