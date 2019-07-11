//
//  FillInApplyApprovalCollectionCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/19.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请  审批人  collectioncell

import UIKit

//class FillInApplyApprovalCollectionCell: UICollectionViewCell {
//
//    /// 点击删除回调
//    var deleteBlock: (() -> ())?
//    /// 是否显示删除
//    var isCanDelete = false {
//        didSet {
//            deleteBtn.isHidden = !isCanDelete
//        }
//    }
//    /// 数据
//    var data: [ProcessUsersCheckUsers] = [] {
//        didSet {
//            if data.count > 1 {
//                nameBtn.setTitle("\(data.count)人审批", for: .normal)
//                nameBtn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
//            } else if data.count == 1 {
//                let model = data[0]
//                nameBtn.setTitleColor(blackColor, for: .normal)
//                nameBtn.setTitle(model.realname ?? "", for: .normal)
//                if model.checkUserId == 0 {
//                    nameBtn.setTitleColor(UIColor(hex: "#FF4444"), for: .normal)
//                } else {
//                    nameBtn.setTitleColor(blackColor, for: .normal)
//                }
//            } else {
//                nameBtn.setTitleColor(blackColor, for: .normal)
//                nameBtn.setTitleColor(.white, for: .normal)
//            }
//        }
//    }
//
//    /// 申请详情中的数据
//    var detailsData: NotifyCheckUserListData? {
//        didSet {
//            if let data = detailsData {
//                nameBtn.setTitle(data.checkUserName, for: .normal)
//            }
//        }
//    }
//
//    /// 名称/审批
//    private var nameBtn: UIButton!
//    /// 删除按钮
//    private var deleteBtn: UIButton!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initSubViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MAKR: - 自定义私有方法
//    /// 初始化子控件
//    private func initSubViews() {
//        nameBtn = UIButton().taxi.adhere(toSuperView: contentView) // 名称/审批
//            .taxi.layout(snapKitMaker: { (make) in
//                make.width.lessThanOrEqualToSuperview().offset(-10).priority(800)
//                make.top.equalToSuperview().offset(5)
//                make.centerX.equalToSuperview()
//                make.centerY.equalToSuperview()
//            })
//            .taxi.config({ (btn) in
//                btn.setTitleColor(blackColor, for: .normal)
//                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//                btn.addTarget(self, action: #selector(nameClick), for: .touchUpInside)
//            })
//
//        deleteBtn = UIButton().taxi.adhere(toSuperView: contentView) // 删除按钮
//            .taxi.layout(snapKitMaker: { (make) in
//                make.top.right.equalToSuperview()
//            })
//            .taxi.config({ (btn) in
//                btn.setImage(UIImage(named: "cc_delete"), for: .normal)
//                btn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
//            })
//    }
//
//    // MARK: - 按钮点击
//    /// 点击名称
//    @objc private func nameClick() {
//        guard data.count > 0 else {
//            return
//        }
//        var contentArray = [String]()
//        for model in data {
//            contentArray.append(model.realname ?? "")
//        }
//        guard contentArray.count > 1 else {
//            return
//        }
//        let view = SeleVisitModelView(title: "", content: contentArray)
//        let attriMuStr = NSMutableAttributedString(string: "\(data.count)人审批\n其中一人通过即可")
//        attriMuStr.changeFont(str: "其中一人通过即可", font: UIFont.medium(size: 13))
//        attriMuStr.addLineSpacing(distance: 5, alignment: .center)
//        view.attriMuTitleStr = attriMuStr
//        view.isClick = false
//        view.show()
//    }
//
//    /// 删除
//    @objc private func deleteClick() {
//        if deleteBlock != nil {
//            deleteBlock!()
//        }
//    }
//}

class FillInApplyApprovalCollectionCell: UICollectionViewCell {
    
    /// 点击删除回调
    var deleteBlock: (() -> ())?
    /// 是否显示删除
    var isCanDelete = false {
        didSet {
            deleteBtn.isHidden = !isCanDelete
        }
    }
    /// 数据
    var data: [ProcessUsersCheckUsers] = [] {
        didSet {
            if data.count > 1 {
                nameBtn.setTitle("\(data.count)人审批", for: .normal)
                nameBtn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
                positionLabel.isHidden = true
            } else if data.count == 1 {
                let model = data[0]
                nameBtn.setTitleColor(blackColor, for: .normal)
                nameBtn.setTitle(model.realname ?? "", for: .normal)
                positionLabel.isHidden = false
                if model.checkUserId == 0 {
                    nameBtn.setTitleColor(UIColor(hex: "#FF4444"), for: .normal)
                    positionLabel.isHidden = true
                } else {
                    nameBtn.setTitleColor(blackColor, for: .normal)
                }
                let str = model.roleName ?? ""
                if str.count == 0 {
                    positionLabel.isHidden = true
                } else {
                    positionLabel.text = str
                    let width = str.getTextSize(font: UIFont.boldSystemFont(ofSize: 10), maxSize: CGSize(width: 999, height: 999)).width
                    positionLabel.snp.updateConstraints { (make) in
                        make.width.equalTo(width + 10)
                    }
                }
            } else {
                nameBtn.setTitleColor(blackColor, for: .normal)
                nameBtn.setTitleColor(.white, for: .normal)
                positionLabel.isHidden = true
            }
        }
    }
    
    /// 申请详情中的数据
    var detailsData: NotifyCheckUserListData? {
        didSet {
            if let data = detailsData {
                nameBtn.setTitle(data.checkUserName, for: .normal)
                positionLabel.isHidden = true
            }
        }
    }
    
    /// 名称/审批
    private var nameBtn: UIButton!
    /// 职位
    private var positionLabel: UILabel!
    /// 删除按钮
    private var deleteBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        nameBtn = UIButton().taxi.adhere(toSuperView: contentView) // 名称/审批
            .taxi.layout(snapKitMaker: { (make) in
                make.width.lessThanOrEqualToSuperview().offset(-10).priority(800)
                make.top.equalToSuperview().offset(5)
                make.centerX.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitleColor(blackColor, for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                btn.addTarget(self, action: #selector(nameClick), for: .touchUpInside)
            })
        
        positionLabel = UILabel().taxi.adhere(toSuperView: contentView) // 职位
            .taxi.layout(snapKitMaker: { (make) in
                make.width.lessThanOrEqualToSuperview().offset(-10).priority(800)
                make.bottom.equalToSuperview().offset(-10).priority(800)
                make.top.equalToSuperview().offset(40)
                make.height.equalTo(20).priority(800)
                make.centerX.equalToSuperview()
                make.width.equalTo(60)
            })
            .taxi.config({ (label) in
                label.layer.cornerRadius = 4
                label.textAlignment = .center
                label.layer.masksToBounds = true
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 10)
                label.backgroundColor = UIColor(hex: "#DCE4FF")
            })
        
        deleteBtn = UIButton().taxi.adhere(toSuperView: contentView) // 删除按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.right.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "cc_delete"), for: .normal)
                btn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击名称
    @objc private func nameClick() {
        guard data.count > 0 else {
            return
        }
        var contentArray = [String]()
        for model in data {
            contentArray.append(model.realname ?? "")
        }
        guard contentArray.count > 1 else {
            return
        }
        let view = SeleVisitModelView(title: "", content: contentArray)
        let attriMuStr = NSMutableAttributedString(string: "\(data.count)人审批\n其中一人通过即可")
        attriMuStr.changeFont(str: "其中一人通过即可", font: UIFont.medium(size: 13))
        attriMuStr.addLineSpacing(distance: 5, alignment: .center)
        view.attriMuTitleStr = attriMuStr
        view.isClick = false
        view.show()
    }
    
    /// 删除
    @objc private func deleteClick() {
        if deleteBlock != nil {
            deleteBlock!()
        }
    }
}

