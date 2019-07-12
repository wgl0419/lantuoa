//
//  HandoverStaffSeleCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作接手(工作交接 选择员工) cell

import UIKit

class HandoverStaffSeleCell: UITableViewCell {
    
    /// 数据
    var data: (WorkExtendListData, Bool)? {
        didSet {
            if let usersData = data?.0, let isSele = data?.1 {
                seleBtn.isSelected = isSele
                let nameStr = (usersData.realname ?? "") + " " + (usersData.phone ?? "")
                nameLabel.text = nameStr
                departmentLabel.text = usersData.departmentName
            }
        }
    }
    
    /// 选中按钮
    private var seleBtn: UIButton!
    /// 名称 + 电话号码
    private var nameLabel: UILabel!
    /// 部门
    private var departmentLabel: UILabel!

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
        seleBtn = UIButton().taxi.adhere(toSuperView: contentView) // 选中按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(15)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "unsele"), for: .normal)
                btn.setImage(UIImage(named: "sele"), for: .selected)
                btn.isUserInteractionEnabled = false
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称 + 电话号码
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(50).priority(800)
                make.left.equalTo(seleBtn.snp.right).offset(10)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
        
        departmentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 部门
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.right.lessThanOrEqualToSuperview().offset(-10)
                make.left.equalTo(nameLabel.snp.right).offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            })
    }
}
