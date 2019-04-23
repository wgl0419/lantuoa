//
//  DepartmentalStaffCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  部门人员 cell

import UIKit

class DepartmentalStaffCell: UITableViewCell {
    
    /// 点击更多回调
    var moreBlock: ((UIButton) -> ())?
    /// 数据
    var data: DepartmentsUsersData? {
        didSet {
            if let data = data {
                nameLabel.text = data.realname
                let positionStr = data.departmentUserTypeName ?? ""
                positionLabel.text = positionStr.count > 0 ? positionStr : "员工"
                phoneLabel.text = data.phone
            }
        }
    }
    
    /// 人员名称
    private var nameLabel: UILabel!
    /// 职位
    private var positionLabel: UILabel!
    /// 电话号码
    private var phoneLabel: UILabel!

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
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 员工名称
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(50).priority(800)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
        positionLabel = UILabel().taxi.adhere(toSuperView: contentView) // 职位
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(nameLabel.snp.right).offset(15)
                make.left.greaterThanOrEqualToSuperview().offset(70)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
        phoneLabel = UILabel().taxi.adhere(toSuperView: contentView) // 电话号码
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(positionLabel.snp.right).offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
        if Jurisdiction.share.isModifyPerson || Jurisdiction.share.isLeavePerson { // 有修改部门或离职员工权限
            _ = UIButton().taxi.adhere(toSuperView: contentView) // 功能按钮
                .taxi.layout(snapKitMaker: { (make) in
                    make.right.equalToSuperview().offset(-5)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(40)
                })
                .taxi.config({ (btn) in
                    btn.setImage(UIImage(named: "more"), for: .normal)
                    btn.addTarget(self, action: #selector(moreClick(btn:)), for: .touchUpInside)
                })
        }
    }
    
    // MARK: - 按钮点击
    /// 点击更多功能
    @objc private func moreClick(btn: UIButton) {
        if moreBlock != nil {
            moreBlock!(btn)
        }
    }
}
