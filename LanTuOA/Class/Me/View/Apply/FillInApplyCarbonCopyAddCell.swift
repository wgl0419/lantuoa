//
//  FillInApplyCarbonCopyAddCell.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/19.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请  抄送  添加 cell

import UIKit

class FillInApplyCarbonCopyAddCell: UICollectionViewCell {
    
    /// 添加回调
    var addBlock: (() -> ())?
    
    /// 添加按钮
    private var addBtn: UIButton!
    
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
        
        addBtn = UIButton().taxi.adhere(toSuperView: contentView) // 添加按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview().offset(-15).priority(800)
                make.width.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(13)
                make.centerX.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "carbonCopy_add"), for: .normal)
                btn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击添加
    @objc private func addClick() {
        if addBlock != nil {
            addBlock!()
        }
    }
}
