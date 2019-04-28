//
//  ScreenView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  筛选视图

import UIKit

class ScreenView: UIView {

    /// 删除回调
    var deleteBlock: (() -> ())?
    /// 数据
    var contentStr: String! {
        didSet {
            /// 内容宽
            let labelWidth = contentStr.getTextSize(font: UIFont.boldSystemFont(ofSize: 12), maxSize: CGSize(width: ScreenWidth, height: 24)).width
            contentLabel.text = contentStr
            contentLabel.snp.updateConstraints { (make) in
                make.width.equalTo(labelWidth + 20)
            }
        }
    }
    
    /// 内容
    private var contentLabel: UILabel!
    /// 删除按钮
    private var deleteBtn: UIButton!
    
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
        
        contentLabel = UILabel().taxi.adhere(toSuperView: self) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(24).priority(800)
                make.width.equalTo(10)
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 7)) // 添加删除按钮的位置
            })
            .taxi.config({ (label) in
                label.textColor = blackColor
                label.layer.cornerRadius = 4
                label.textAlignment = .center
                label.layer.masksToBounds = true
                label.font = UIFont.boldSystemFont(ofSize: 12)
                label.backgroundColor = UIColor(hex: "#F1F1F1")
            })
        
        deleteBtn = UIButton().taxi.adhere(toSuperView: self) // 删除按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.centerX.equalTo(contentLabel.snp.right)
                make.centerY.equalTo(contentLabel.snp.top)
                make.width.height.equalTo(13)
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "input_clear"), for: .normal)
                btn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击删除
    @objc private func deleteClick() {
        if deleteBlock != nil {
            deleteBlock!()
        }
    }
}
