//
//  FillInApplyMoneyBackCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  回款设置 cell

import UIKit
import SnapKit

class FillInApplyMoneyBackCell: UITableViewCell {

    /// 点击添加回调
    var addBlock: (() -> ())?
    /// 删除回调
    var deleteBlock: ((Int) -> ())?
    /// 数据  (金额   时间戳)
    var data: [(Float, Int)]? {
        didSet {
            if let data = data {
                initSubViews()
                var lastLabel: UILabel! = personnelLabel
                for index in 0..<data.count {
                    let attriMuStr = initAttriMuStr(data: (index, data[index].0, data[index].1))
                    lastLabel = setPersonnelData(attriMuStr: attriMuStr, lastLabel: lastLabel, isLast: index == data.count - 1, index: index)
                }
            }
        }
    }
    
    /// 标题
    private var personnelLabel: UILabel!
    /// 标题下面的约束
    private var noneConstraint: Constraint!
    /// 名称下面的约束
    private var nameConstraint: Constraint!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.removeAllSubviews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        personnelLabel = UILabel().taxi.adhere(toSuperView: contentView) // “合同人员”
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.equalToSuperview().offset(15)
                noneConstraint = make.bottom.equalToSuperview().offset(-15).priority(800).constraint
            })
            .taxi.config({ (label) in
                label.text = "回款设置"
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
                noneConstraint.activate()
            })
        
        _ = UILabel().taxi.adhere(toSuperView: contentView) // 必填 星星
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(personnelLabel)
                make.left.equalToSuperview().offset(5)
            })
            .taxi.config({ (label) in
                label.text = "*"
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#FF4444")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 添加按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalTo(personnelLabel)
            })
            .taxi.config({ (btn) in
                btn.setTitle(" 添加", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setImage(UIImage(named: "add"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
            })
    }
    
    /// 生成富文本 (第几个  金额   时间戳)
    private func initAttriMuStr(data: (Int, Float, Int)) -> NSMutableAttributedString {
        let moneyStr = data.1.getSpotMoneyStr()
        let timeStr = Date(timeIntervalSince1970: TimeInterval(data.2)).customTimeStr(customStr: "yyyy-MM-dd")
        let contentStr = "第\(data.0 + 1)期  " + moneyStr + "  " + timeStr + "前"
        let attriMuStr = NSMutableAttributedString(string: contentStr)
        attriMuStr.changeColor(str: moneyStr, color: UIColor(hex: "#FF7744"))
        return attriMuStr
    }
    
    /// 添加人员数据
    ///
    /// - Parameters:
    ///   - attriMuStr: 富文本
    ///   - lastLabel: 跟随的控件
    ///   - isLast: 是否是最后一个
    ///   - index: 提供位置  -> 删除按钮的tag
    /// - Returns: 返回名称label -> 提供给下行跟随
    private func setPersonnelData(attriMuStr: NSMutableAttributedString, lastLabel: UILabel, isLast: Bool, index: Int) -> UILabel {
        let contentLabel = UILabel().taxi.adhere(toSuperView: contentView) // 内容
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(lastLabel.snp.bottom).offset(lastLabel != personnelLabel ? 10 : 15).priority(800)
                if isLast {
                    nameConstraint = make.bottom.equalToSuperview().offset(-15).constraint
                }
            }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.attributedText = attriMuStr
                if isLast {
                    noneConstraint.deactivate()
                    nameConstraint.activate()
                }
        }
        
        _ = UIButton().taxi.adhere(toSuperView: contentView) // 删除按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(contentLabel)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (btn) in
                btn.tag = index
                btn.setImage(UIImage(named: "input_clear"), for: .normal)
                btn.addTarget(self, action: #selector(deleteClick(btn:)), for: .touchUpInside)
            })
        
        return contentLabel
    }
    
    // MARK: - 按钮点击
    /// 点击添加
    @objc private func addClick() {
        if addBlock != nil {
            addBlock!()
        }
    }
    
    /// 点击删除
    @objc private func deleteClick(btn: UIButton) {
        if deleteBlock != nil {
            deleteBlock!(btn.tag)
        }
    }
}
