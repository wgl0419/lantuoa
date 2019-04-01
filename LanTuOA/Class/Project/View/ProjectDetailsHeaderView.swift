//
//  ProjectDetailsHeaderView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情 顶部视图

import UIKit

class ProjectDetailsHeaderView: UIView {

    var data: (ProjectListStatisticsData, Int)? {
        didSet {
            if let projectData = data?.0, let type = data?.1 {
                projectNameLabel.text = projectData.name
                customerNameLabel.text = projectData.customerName
                addressLabel.text = projectData.address
                manageLabel.text = projectData.manageUserName
                if type == 2 {
                    lockImageView.image = UIImage()
                    lockLabel.text = ""
                } else {
                    lockImageView.image = projectData.isLock == 1 ? UIImage(named: "project_lock") : UIImage(named: "project_unlock")
                    lockLabel.textColor = projectData.isLock == 1 ? UIColor(hex: "#2E4695") : UIColor(hex: "#999999")
                    lockLabel.text = projectData.isLock == 1 ? "已锁定" : "未锁定"
                }
            }
        }
    }
    /// 点击修改回调
    var modifyBlock: (() -> ())?
    
    /// 项目名称
    private var projectNameLabel: UILabel!
    /// 客户名称
    private var customerNameLabel = UILabel()
    /// 项目地址
    private var addressLabel = UILabel()
    /// 项目管理人
    private var manageLabel = UILabel()
    /// 锁定图标
    private var lockImageView: UIImageView!
    /// 锁定文本
    private var lockLabel: UILabel!
    /// 修改按钮
    private var modifyBtn: UIButton!
    
    /// 锁定状态 （0：未锁定   1：锁定   2：无状态）
    private var lockState = 0
    
    
    /// 初始化
    ///
    /// - Parameter state: 锁定状态
    convenience init(state: Int) {
        self.init()
        self.lockState = state
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        backgroundColor = .white
        
        projectNameLabel = UILabel().taxi.adhere(toSuperView: self) // 项目名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(lockState == 2 ? -15 : -55).priority(800)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 24)
            })
        
        _ = UIView().taxi.adhere(toSuperView: self) // 蓝色线条
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(projectNameLabel)
                make.height.equalTo(20)
                make.width.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        let customerName = UILabel()
        customerName.text = "客户："
        setTitle(title: customerName, content: customerNameLabel, lastLabel: projectNameLabel)

        let address = UILabel()
        address.text = "项目地址："
        setTitle(title: address, content: addressLabel, lastLabel: customerNameLabel)

        let manage = UILabel()
        manage.text = "项目管理人："
        setTitle(title: manage, content: manageLabel, lastLabel: addressLabel, isLast: true)
        
        _ = UIView().taxi.adhere(toSuperView: self) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.bottom.right.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(15).priority(800)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        lockImageView = UIImageView().taxi.adhere(toSuperView: self) // 锁定图标
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(18)
                make.height.equalTo(21)
                make.centerY.equalTo(projectNameLabel)
                make.right.equalToSuperview().offset(-27)
            })
        
        lockLabel = UILabel().taxi.adhere(toSuperView: self) // 锁定文本
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(lockImageView)
                make.top.equalTo(lockImageView.snp.bottom).offset(3)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 10)
                label.textColor = UIColor(hex: "#2E4695")
            })
        
        modifyBtn = UIButton().taxi.adhere(toSuperView: self) // 修改按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-5)
                make.top.equalTo(manage.snp.bottom)
                make.width.equalTo(58)
            })
            .taxi.config({ (btn) in
                btn.setTitle(" 修改", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setImage(UIImage(named: "edit"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(modifyClick), for: .touchUpInside)
            })
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - lastLabel: 跟随的最后一个控件
    ///   - isLast: 是否是最后一个
    private func setTitle(title: UILabel, content: UILabel, lastLabel: UILabel, isLast: Bool = false) {
        title.taxi.adhere(toSuperView: self)
            .taxi.layout { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(lastLabel.snp.bottom).offset(10)
        }
            .taxi.config { (label) in
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        content.taxi.adhere(toSuperView: self)
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(title.snp.bottom).offset(5)
                make.right.equalToSuperview().offset(-15).priority(800)
                if isLast {
                    make.bottom.equalToSuperview().offset(-35)
                }
        }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
        }
    }
    
    // MARK: - 按钮点击
    @objc private func modifyClick() {
        if modifyBlock != nil {
            modifyBlock!()
        }
    }
}
