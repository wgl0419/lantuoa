//
//  ProjectSegmentView.swift
//  DanJuanERP
//
//  Created by HYH on 2019/2/19.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目类型选项卡（两行数据）

import UIKit

class ProjectSegmentView: UIView {
    
    /// 标记选中按钮的tag
    var seleTag = -1
    /// 代理
    weak var delegate: ProjectSegmentDelegate?
    
    /// 标题
    private var titleArray = [String]()

    // MARK: - 自定义公有方法
    /// 初始化方法
    ///
    /// - Parameter title: 文字标题
    convenience init(title: [String]) {
        self.init()
        titleArray = title
        initSubViews()
    }
    
    /// 修改显示按钮
    func changeBtn(page: Int) {
        let btn = self.viewWithTag(page + 100) as! UIButton
        btnChange(btn: btn)
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        var lastBtn: UIButton!
        for index in 0..<titleArray.count {
            /**************** 添加按钮 ****************/
            let btn = UIButton().taxi.adhere(toSuperView: self) // 按钮
                .taxi.layout { (make) in
                    make.width.equalTo(74)
                    make.top.equalTo(self).offset(12)
                    make.bottom.equalTo(self).offset(-12)
                    if index == 0 {
                        make.left.equalTo(self).offset(15)
                    } else {
                        make.left.equalTo(lastBtn.snp.right).offset(10)
                    }
            }
                .taxi.config { (btn) in
                    btn.tag = index + 100
                    btn.layer.borderWidth = 1
                    btn.setTitleColor(.white, for: .selected)
                    btn.setTitle(titleArray[index], for: .normal)
                    btn.titleLabel?.font = UIFont.medium(size: 12)
                    btn.layer.borderColor = UIColor(hex: "#D5D5D5").cgColor
                    btn.setTitleColor(UIColor(hex: "#787E82"), for: .normal)
                    btn.addTarget(self, action: #selector(btnClick(but:)), for: .touchUpInside)
            }
            lastBtn = btn
            /**************** 分割线 ****************/
            if index != 0 {
                _ = UIView().taxi.adhere(toSuperView: self) // 分割线
                    .taxi.layout(snapKitMaker: { (make) in
                        make.width.equalTo(1)
                        make.left.equalTo(btn)
                        make.height.equalTo(23)
                        make.centerY.equalTo(self)
                    })
                    .taxi.config({ (view) in
                        view.backgroundColor = UIColor(hex: "#CCCCCC")
                    })
            }
        }
    }
    
    /// 修改按钮状态
    ///
    /// - Parameter btn: 选中的按钮
    private func btnChange(btn: UIButton) {
        if btn.tag - 100 == seleTag {
            return
        }
        if seleTag != -1 {
            let oldBtn = viewWithTag(seleTag + 100) as! UIButton
            oldBtn.isSelected = false
            oldBtn.backgroundColor = .white
            oldBtn.layer.borderColor = UIColor(hex: "#D5D5D5").cgColor
        }
        seleTag = btn.tag - 100
        btn.isSelected = true
        btn.backgroundColor = UIColor(hex: "#2E4695")
        btn.layer.borderColor = UIColor(hex: "#6B83D1").cgColor
        
    }
    
    // MARK: - 按钮点击
    /// 点击按钮
    @objc private func btnClick(but: UIButton) {
        btnChange(btn: but)
        delegate?.changeScrollView(page: but.tag - 100)
    }
}

@objc
protocol ProjectSegmentDelegate: NSObjectProtocol {
    func changeScrollView(page: Int)
}
