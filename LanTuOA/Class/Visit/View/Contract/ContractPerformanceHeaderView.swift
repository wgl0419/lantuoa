//
//  ContractPerformanceHeaderView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同  业绩详情  顶部视图

import UIKit

class ContractPerformanceHeaderView: UIView {

    /// 选择新的人回调
    var seleBlock: ((Int) -> ())?
    /// 参与合同人员  （用于业绩详情）
    var contractUsersData = [ContractListContractUsers]()
    /// 数据 (发布总额  选择人名称  百分百  总业绩)
    var data: (Float, String, Int, Float)? {
        didSet {
            if let data = data {
                totalLabel.text = data.0.getAllMoneyStr()
                let seleStr = "选择参与人：\(data.1)（\(data.2)%）"
                seleBtn.setTitle(seleStr, for: .normal)
                seleLabel.text = "\(data.1)业绩详情："
                totalPerformanceLabel.text = data.3.getAllMoneyStr()
            }
        }
    }
    
    /// 总金额
    private var totalLabel: UILabel!
    /// 选择人按钮
    private var seleBtn: UIButton!
    /// 选择人
    private var seleLabel: UILabel!
    /// 总业绩
    private var totalPerformanceLabel: UILabel!
    
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
        
        let total = UILabel().taxi.adhere(toSuperView: self) // "发布总额"
            .taxi.layout { (make) in
                make.top.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "发布总额："
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        totalLabel = UILabel().taxi.adhere(toSuperView: self) // 发布总额
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(total)
                make.left.equalTo(total.snp.right)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        seleBtn = UIButton().taxi.adhere(toSuperView: self) // 选择人按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(total)
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (btn) in
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(seleClick), for: .touchUpInside)
            })
        
        let totalPerformance = UILabel().taxi.adhere(toSuperView: self) // ”总业绩“
            .taxi.layout { (make) in
                make.bottom.equalToSuperview().offset(-10)
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = "总业绩："
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        
        totalPerformanceLabel = UILabel().taxi.adhere(toSuperView: self) // 总业绩
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(totalPerformance.snp.right)
                make.top.equalTo(totalPerformance)
            })
            .taxi.config({ (label) in
                label.text = "总业绩："
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        seleLabel = UILabel().taxi.adhere(toSuperView: self) // 选择人
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalTo(totalPerformance.snp.top).offset(-5)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 14)
            })
        
    }
    
    // MARK: - 按钮点击
    /// 点击选择人
    @objc private func seleClick() {
        var contentArray = [String]()
        for model in contractUsersData {
            let contentStr = "\(model.realname ?? "")(\(model.propPerform)%)"
            contentArray.append(contentStr)
        }
        let view = SeleVisitModelView(title: "选择参与人员", content: contentArray)
        view.didBlock = { [weak self] (seleIndex) in
            if self?.seleBlock != nil {
                self?.seleBlock!(seleIndex)
            }
        }
        view.show()
    }
}
