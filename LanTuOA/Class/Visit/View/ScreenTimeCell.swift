//
//  ScreenTimeCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/5.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  筛选时间 cell

import UIKit

class ScreenTimeCell: UITableViewCell {

    /// 点击回调
    var clickBlock: ((Int) -> ())?
    /// 数据 (开始内容   结束内容)
    var data: (Int?, Int?)! {
        didSet {
            let startTimeStamp = data?.0
            setShowContent(startLabel, startTimeStamp, "开始时间")
            
            let endTimeStamp = data?.1
            setShowContent(endLabel, endTimeStamp, "结束时间")
        }
    }
    
    /// 开始时间按钮
    private var startBtn = UIButton()
    /// 开始时间label
    private var startLabel = UILabel()
    /// 结束时间按钮
    private var endBtn = UIButton()
    /// 结束时间label
    private var endLabel = UILabel()
    
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
        
        let titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(22)
        }
            .taxi.config { (label) in
                label.text = "时间"
                label.textColor = UIColor(hex: "#444444")
                label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        
        setTime(btn: startBtn, label: startLabel, lastLabel: titleLabel)
        
        let toLabel = UILabel().taxi.adhere(toSuperView: contentView) // “至”
            .taxi.layout { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(startBtn.snp.bottom).offset(5)
        }
            .taxi.config { (label) in
                label.text = "至"
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        setTime(btn: endBtn, label: endLabel, lastLabel: toLabel)
    }
    
    /// 设置时间块
    ///
    /// - Parameters:
    ///   - btn: 背景按钮
    ///   - label: 显示文本 (提示或选中内容)
    ///   - lastLabel: 跟随的控件
    private func setTime(btn: UIButton, label: UILabel, lastLabel: UILabel) {
        let lastStr = lastLabel.text ?? ""
        var isStart = false
        if lastStr == "时间" { // 开始时间
            isStart = true
        }
        
        btn.taxi.adhere(toSuperView: contentView) // 按钮
            .taxi.layout { (make) in
                make.height.equalTo(28)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15).priority(800)
                make.top.equalTo(lastLabel.snp.bottom).offset(isStart ? 10 : 5)
                if !isStart {
                    make.bottom.equalToSuperview().offset(-20)
                }
        }
            .taxi.config { (btn) in
                btn.tag = isStart ? 0 : 1
                btn.layer.borderWidth = 1
                btn.layer.cornerRadius = 4
                btn.layer.masksToBounds = true
                btn.layer.borderColor = UIColor(hex: "#999999").cgColor
                btn.backgroundColor = UIColor(hex: "#F9F9F9")
                btn.addTarget(self, action: #selector(screenClick(btn:)), for: .touchUpInside)
        }
        
        label.taxi.adhere(toSuperView: contentView) // 显示文本
            .taxi.layout { (make) in
                make.centerY.equalTo(btn)
                make.left.equalTo(btn).offset(10)
                make.right.equalTo(btn).offset(-20)
        }
        
        _ = UIImageView().taxi.adhere(toSuperView: contentView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalTo(btn).offset(-10)
                make.width.height.equalTo(14)
                make.centerY.equalTo(btn)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "date")
            })
    }
    
    /// 设置内容显示
    private func setShowContent(_ label: UILabel, _ timeStamp: Int?, _ tips: String) {
        if timeStamp == nil {
            label.text = tips
            label.textAlignment = .left
            label.font = UIFont.medium(size: 12)
            label.textColor = UIColor(hex: "#CCCCCC")
        } else {
            label.textAlignment = .center
            label.textColor = UIColor(hex: "#2E4695")
            label.font = UIFont.boldSystemFont(ofSize: 12)
            label.text = Date(timeIntervalSince1970: TimeInterval(timeStamp!)).customTimeStr(customStr: "yyyy-MM-dd")
        }
    }
    
    // MARK: - 按钮点击
    /// 点击筛选时间
    @objc private func screenClick(btn: UIButton) {
        if clickBlock != nil {
            clickBlock!(btn.tag)
        }
    }
}
