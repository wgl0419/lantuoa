//
//  CustomerEditVisitorCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户编辑 拜访人 cell

import UIKit

class CustomerEditVisitorCell: UITableViewCell {

    // 点击修改回调
    var modifyBlick: (() -> ())?
    
    var data: ProjectMemberListData? {
        didSet {
            if let data = data {
                nameLabel.text = data.userName
                departmentLabel.text = "后端未返回"
                phoneLabel.text = "后端未返回"
            }
        }
    }
    
    /// 名字
    private var nameLabel: UILabel!
    /// 部门名称
    private var departmentLabel: UILabel!
    /// 电话号码
    private var phoneLabel: UILabel!
    /// 移除按钮
    private var deleteBtn: UIButton!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名字
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(ScreenWidth / 4 - 10)
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(45).priority(800)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.text = "名字名字名字名字名字名字名字名字名字名字名字名字名字名字名字v"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
            })
        
        departmentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 部门
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(ScreenWidth / 4)
                make.width.equalTo(ScreenWidth / 3)
                make.top.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.text = "部门部门部门部门部门部门部门部门部门部门部门部门部门部门部门部门部门部门"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
            })
        
        phoneLabel = UILabel().taxi.adhere(toSuperView: contentView) // 电话号码
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(ScreenWidth / 3)
                make.left.equalTo(departmentLabel.snp.right).offset(5)
            })
            .taxi.config({ (label) in
                label.text = "123456789011"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 14)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 修改按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.right.equalToSuperview()
                make.width.equalTo(68)
            })
            .taxi.config({ (btn) in
                btn.setTitle("修改", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(modifyClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击修改
    @objc private func modifyClick() {
        if modifyBlick != nil {
            modifyBlick!()
        }
    }

}
