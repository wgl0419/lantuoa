//
//  CustomerEditDetailsCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户编辑 详情cell

import UIKit

class CustomerEditDetailsCell: UITableViewCell {

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
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 客户名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-60)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#999999")
                label.font = UIFont.boldSystemFont(ofSize: 16)
                
                let attriMuStr = NSMutableAttributedString(string: "蛋卷科技（IT行业）")
                attriMuStr.changeFont(str: "蛋卷科技", font: UIFont.boldSystemFont(ofSize: 24))
                attriMuStr.changeColor(str: "蛋卷科技", color: UIColor(hex: "#2E4695"))
                label.attributedText = attriMuStr
            })
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 修改按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview()
                make.top.equalTo(nameLabel)
                make.height.equalTo(20)
                make.width.equalTo(60)
            })
            .taxi.config({ (btn) in
                btn.setTitle("修改", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(modifyClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: contentView) // 蓝色标识块
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
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.lessThanOrEqualToSuperview().offset(-15)
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
        }
        
        contentView.addSubview(content)
        if content is UIButton {
            let btn: UIButton = content as! UIButton
            btn.taxi.layout { (make) in
                make.width.equalTo(33)
                make.height.equalTo(18)
                make.centerY.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
            }
                .taxi.config { (btn) in
                    btn.isEnabled = false
                    btn.layer.borderWidth = 1
                    btn.layer.cornerRadius = 4
                    btn.layer.masksToBounds = true
                    btn.layer.borderColor = UIColor(hex: "#6B83D1").cgColor
                    
                    btn.backgroundColor = UIColor(hex: "#E9EDF9")
                    btn.titleLabel?.font = UIFont.medium(size: 10)
                    btn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
            }
        } else {
            let label: UILabel = content as! UILabel
            label.taxi.layout { (make) in
                make.top.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
                make.right.lessThanOrEqualToSuperview().offset(-15)
                if position == 1 {
                    make.bottom.equalToSuperview().offset(-15)
                }
            }
                .taxi.config { (label) in
                    label.text = " "
                    label.numberOfLines = 0
                    label.textColor = blackColor
                    label.font = UIFont.medium(size: 14)
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
