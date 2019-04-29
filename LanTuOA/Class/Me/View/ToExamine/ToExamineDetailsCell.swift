//
//  ToExamineDetailsCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批详情  cell

import UIKit

class ToExamineDetailsCell: UITableViewCell {
    
    /// 发起人数据
    var notifyCheckListData: NotifyCheckListData? {
        didSet {
            if let data = notifyCheckListData {
                topLineView.isHidden = true
                topLineView.snp.updateConstraints { (make) in
                    make.height.equalTo(12)
                }
                statusLabel.text = "(发起申请)"
                statusLabel.textColor = blackColor
                nameLabel.text = data.createdUserName ?? ""
                timeLabel.text = Date(timeIntervalSince1970: TimeInterval(data.createdTime)).getCommentTimeString()
            }
        }
    }
    /// 数据 (审批人数据  是否轮到这条数据审批  是否最后一个   是否展开)
    var data: ([NotifyCheckUserListData], Bool, Bool, Bool)? {
        didSet {
            if let listModel = data?.0, let approval = data?.1, let isLast = data?.2, let isOpen = data?.3 {
                var status: Int!
                // 处理是显示名称  还是  多人或签
                var model = listModel.filter { (model) -> Bool in
                    return model.status == 2 || model.status == 3
                }
                if model.count == 0 && listModel.count > 1 { // 多人或签状态下 还没有人处理
                    nameLabel.text = "\(listModel.count)人或签"
                    openBtn.isHidden = false
                    status = listModel[0].status
                } else {
                    if model.count == 0 { // 单人状态下  没有处理
                        model = listModel
                    }
                    nameLabel.text = model[0].checkUserName ?? ""
                    status = model[0].status
                }
                // 处理状态
                if !approval {
                    statusLabel.text = "(未审批)"
                    statusLabel.textColor = blackColor
                } else {
                    statusLabel.text = status == 0 ? "(发起申请)" : status == 1 ? "(审批中)" : status == 2 ? "(已同意)" : "(已拒绝)"
                    statusLabel.textColor = status == 0 ? blackColor : status == 1 ? UIColor(hex: "#FF7744") : status == 2 ? UIColor(hex: "#5FB9A1") : UIColor(hex: "#FF4444")
                }
                
                if listModel[0].checkedTime != 0 {
                    timeLabel.text = Date(timeIntervalSince1970: TimeInterval(listModel[0].checkedTime)).getCommentTimeString()
                } else {
                    timeLabel.text = ""
                }
                openBtn.isSelected = isOpen
                statusLabel.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview().offset(isLast && !isOpen ? -15 : -3)
                }
            }
        }
    }
    
    
    /// 审批人名称
    private var nameLabel: UILabel!
    /// 状态
    private var statusLabel: UILabel!
    /// 时间
    private var timeLabel: UILabel!
    /// 顶部线
    private var topLineView: UIView!
    /// 展开按钮
    private var openBtn: UIButton!
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topLineView.isHidden = false
        topLineView.snp.updateConstraints { (make) in
            make.height.equalTo(30)
        }
        statusLabel.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-3)
        }
        openBtn.isHidden = true
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        topLineView = UIView().taxi.adhere(toSuperView: contentView) // 顶部线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(23)
                make.top.equalToSuperview()
                make.height.equalTo(30)
                make.width.equalTo(3)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        nameLabel = UILabel().taxi.adhere(toSuperView: contentView) // 名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(topLineView.snp.bottom).offset(3)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 18)
            })
        
        openBtn = UIButton().taxi.adhere(toSuperView: contentView) // 展开按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(nameLabel.snp.right).offset(5)
                make.centerY.equalTo(nameLabel)
            })
            .taxi.config({ (btn) in
                btn.isHidden = true
                btn.isUserInteractionEnabled = false
                btn.setImage(UIImage(named: "toExamineDetails_arrow"), for: .normal)
                btn.setImage(UIImage(named: "toExamineDetails_arrow1"), for: .selected)
            })
        
        timeLabel = UILabel().taxi.adhere(toSuperView: contentView) // 时间
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(nameLabel)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 10)
            })
        
        statusLabel = UILabel().taxi.adhere(toSuperView: contentView) // 状态
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(2)
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-3)
            })
            .taxi.config({ (label) in
                label.font = UIFont.boldSystemFont(ofSize: 10)
            })
        
        
    }
}
