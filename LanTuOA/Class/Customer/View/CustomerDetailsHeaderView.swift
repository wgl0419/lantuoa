//
//  CustomerDetailsHeaderView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户详情顶部视图

import UIKit

class CustomerDetailsHeaderView: UIView {
    
    
    /// 数据
    var data: CustomerListStatisticsData? {
        didSet {
            if let data = data {
                let industryStr = "(\(data.industryName ?? ""))"
                if industryStr.count > 2 {
                    let nameAttriMuStr = NSMutableAttributedString(string: "\(data.name ?? "") \(industryStr)")
                    nameAttriMuStr.changeFont(str: industryStr, font: UIFont.boldSystemFont(ofSize: 16))
                    nameAttriMuStr.changeColor(str: industryStr, color: UIColor(hex: "#999999"))
                    nameLabel.attributedText = nameAttriMuStr
                } else {
                    nameLabel.text = data.name ?? " "
                }
                
                companyLabel.text = data.fullName ?? " "
                addressLabel.text = data.address ?? " "
                
                let customerTypeName = data.type == 1 ? "customer_company" : data.type == 2 ? "customer_ordinary" : "customer_development"
                typeBtn.setImage(UIImage(named: customerTypeName), for: .normal)
            }
        }
    }
    
    /// 点击修改回调
    var modifyBolck: (() -> ())?
    
    /// 客户名称
    private var nameLabel: UILabel!
    /// 公司名称
    private var companyLabel = UILabel()
    /// 客户类型
    private var typeBtn = UIButton()
    /// 公司地址
    private var addressLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        backgroundColor = .white
        
        nameLabel = UILabel().taxi.adhere(toSuperView: self) // 客户名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-70)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 24)
            })
        
        if Jurisdiction.share.isEditCustomer { // 可修客户信息
            _ = UIButton().taxi.adhere(toSuperView: self) // 修改按钮
                .taxi.layout(snapKitMaker: { (make) in
                    make.right.equalToSuperview().offset(-10)
                    make.top.equalTo(nameLabel)
                    make.height.equalTo(20)
                    make.width.equalTo(60)
                })
                .taxi.config({ (btn) in
                    btn.setTitle(" 修改", for: .normal)
                    btn.titleLabel?.font = UIFont.medium(size: 14)
                    btn.setImage(UIImage(named: "edit"), for: .normal)
                    btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                    btn.addTarget(self, action: #selector(modifyClick), for: .touchUpInside)
                })
        }
        
        _ = UIView().taxi.adhere(toSuperView: self) // 蓝色标识块
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(3)
                make.height.equalTo(18)
                make.left.equalToSuperview()
                make.centerY.equalTo(nameLabel)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        _ = setTitle(titleStr: "公司全称：", content: companyLabel, lastView: nameLabel, position: -1)
        
        let type = setTitle(titleStr: "客户类型：", content: typeBtn, lastView: companyLabel)
        
        _ = setTitle(titleStr: "公司地址：", content: addressLabel, lastView: type, position: 1)
        
        _ = UIView().taxi.adhere(toSuperView: self) // 灰色块
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(10)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
    }
    
    /// 设置标题和内容
    ///
    /// - Parameters:
    ///   - titleStr: 标题内容
    ///   - content: 内容控件
    ///   - lastView: 跟随控件
    ///   - position: 位置 （-1顶部  0中间部分  1底部）
    /// - Returns: 标题控件
    private func setTitle(titleStr: String, content: UIView, lastView: UIView, position: Int = 0) -> UILabel {
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: self) // 标题
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                if position == -1 {
                    make.top.equalTo(lastView.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(lastView.snp.bottom).offset(5)
                }
            }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        self.addSubview(content)
        if content is UIButton {
            let btn: UIButton = content as! UIButton
            btn.taxi.layout { (make) in
                make.centerY.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
            }
                .taxi.config { (btn) in
                    btn.isUserInteractionEnabled = false
            }
        } else {
            let label: UILabel = content as! UILabel
            label.taxi.layout { (make) in
                make.top.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
                make.right.lessThanOrEqualToSuperview().offset(-15)
                if position == 1 {
                    make.bottom.equalToSuperview().offset(-25)
                }
            }
                .taxi.config { (label) in
                    label.text = " "
                    label.numberOfLines = 0
                    label.textColor = blackColor
                    label.font = UIFont.medium(size: 14)
                    label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            }
        }
        
        return titleLabel
    }
    
    // MARK: - 按钮点击
    /// 点击修改
    @objc private func modifyClick() {
        if modifyBolck != nil {
            modifyBolck!()
        }
    }
}
