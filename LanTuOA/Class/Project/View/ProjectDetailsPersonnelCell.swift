//
//  ProjectDetailsPersonnelCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情 参与人员 cell

import UIKit

class ProjectDetailsPersonnelCell: UITableViewCell {

    // 点击删除回调
    var deleteBlock: (() -> ())?
    /// 锁定状态 （0：未锁定  1：锁定）
    var lockState: Int? {
        didSet {
            if let _ = lockState {
                deleteBtnHandle()
            }
        }
    }
    
    var data: ProjectMemberListData? {
        didSet {
            if let data = data {
                nameLabel.text = data.userName
                departmentLabel.text = "后端未返回" // TODO: 后端没有给数据
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
    }
    
    private func deleteBtnHandle() {
        if lockState == 1 { // 锁定状态
            // TODO: 添加尾视图
            if deleteBtn == nil {
                deleteBtn = UIButton().taxi.adhere(toSuperView: contentView) // 删除按钮
                    .taxi.layout(snapKitMaker: { (make) in
                        make.top.bottom.right.equalToSuperview()
                        make.width.equalTo(68)
                    })
                    .taxi.config({ (btn) in
                        btn.setTitle("移除", for: .normal)
                        btn.titleLabel?.font = UIFont.medium(size: 14)
                        btn.setTitleColor(UIColor(hex: "#FF4444"), for: .normal)
                        btn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
                    })
            }
        } else {
            if deleteBtn != nil {
                deleteBtn.removeFromSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteBtnHandle()
    }
    
    // MARK: - 按钮点击
    @objc private func deleteClick() {
        if deleteBlock != nil {
            deleteBlock!()
        }
    }
}
