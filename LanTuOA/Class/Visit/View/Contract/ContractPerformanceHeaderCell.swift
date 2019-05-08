//
//  ContractPerformanceHeaderCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情   业绩详情   表头cell

import UIKit

class ContractPerformanceHeaderCell: UITableViewCell {
    
    /// 数据 (年份  金额  是否展开)
    var data: (String, Float, Bool)! {
        didSet {
            yearLabel.text = String(format: "%@年", data.0)
            moneyLabel.text = data.1.getMoneyStr()
            arrowBtn.isSelected = data.2
            setArrow()
        }
    }
    
    /// 年份
    private var yearLabel: UILabel!
    /// 绩效金额
    private var moneyLabel: UILabel!
    /// 箭头
    private var arrowBtn: UIButton!
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义共有方法
    /// 展开方式变化
    func changeOpen() {
        arrowBtn.isSelected = !arrowBtn.isSelected
        setArrow()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        _ = UIView().taxi.adhere(toSuperView: contentView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.top.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        yearLabel = UILabel().taxi.adhere(toSuperView: contentView) // 年份
            .taxi.layout(snapKitMaker: { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(40).priority(800)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        moneyLabel = UILabel().taxi.adhere(toSuperView: contentView) // 绩效金额
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(yearLabel.snp.right).offset(7)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#FF7744")
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        arrowBtn = UIButton().taxi.adhere(toSuperView: contentView) // 箭头
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .taxi.config({ (btn) in
                //原始图片
                let srcImage = UIImage(named: "arrow")!
                
                //翻转图片的方向
                let flipImageOrientation = (srcImage.imageOrientation.rawValue + 3) % 8
                //翻转图片
                let flipImage =  UIImage(cgImage:srcImage.cgImage!,
                                         scale:srcImage.scale,
                                         orientation: UIImage.Orientation(rawValue: flipImageOrientation)!
                )

                btn.setImage(flipImage, for: .normal)
                btn.isUserInteractionEnabled = false
            })
    }
    
    @objc private func setArrow() {
        let anim = CABasicAnimation()
        anim.keyPath = "transform.rotation"
        if arrowBtn.isSelected {
            anim.toValue = Double.pi
        } else {
            anim.toValue = 0
        }
        anim.duration = 0.3
        anim.isRemovedOnCompletion = false
        anim.fillMode = CAMediaTimingFillMode.forwards
        arrowBtn.imageView?.layer.add(anim, forKey: nil)
    }
}

