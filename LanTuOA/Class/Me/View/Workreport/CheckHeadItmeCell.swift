//
//  CheckHeadItmeCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CheckHeadItmeCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var deleteBtn: UIButton!
    /// 删除回调
    var deleteBlock: (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 职位
            .taxi.layout(snapKitMaker: { (make) in
                make.top.leading.trailing.bottom.equalToSuperview().offset(5).priority(800)
                make.bottom.equalToSuperview().offset(0.1).priority(800)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#444444")
                label.layer.cornerRadius = 3
                label.layer.masksToBounds = true
                label.text = "库里"
                label.textAlignment = .center
                label.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        deleteBtn = UIButton().taxi.adhere(toSuperView: contentView) // 职位
            .taxi.layout(snapKitMaker: { (make) in
                make.trailing.equalToSuperview().offset(7.5)
                make.top.equalToSuperview()
                make.width.height.equalTo(15)

            })
            .taxi.config({ (button) in
                button.layer.cornerRadius = 7.5
                button.layer.masksToBounds = true
                button.setImage(UIImage(named: "input_clear"), for: .normal)
                button.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
            })
    }

    
    // MARK: - 按钮点击
    /// 点击删除
    @objc private func deleteClick() {
        
            if deleteBlock != nil {
                deleteBlock!()
            }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

