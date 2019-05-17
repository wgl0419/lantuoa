//
//  UpdateHintsEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/23.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  更新提示  弹出框

import UIKit

class UpdateHintsEjectView: UIView {
    
    /// 数据
    var data: VersionData? {
        didSet {
            if let data = data {
                let versionNo = data.versionNo ?? ""
                if versionNo.count > 0 {
                    versionLabel.text = data.versionNo
                    let versionWidth = versionNo.getTextSize(font: UIFont.boldSystemFont(ofSize: 10), maxSize: CGSize(width: ScreenWidth, height: ScreenHeight)).width
                    versionLabel.snp.updateConstraints { (make) in
                        make.width.equalTo(versionWidth + 10).priority(800)
                    }
                }
                
                let contentStr = data.updateDesc ?? ""
                if contentStr.count > 0 {
                    let attriMuStr = NSMutableAttributedString(string: contentStr)
                    attriMuStr.changeFont(str: contentStr, font: UIFont.medium(size: 14))
                    attriMuStr.addLineSpacing(distance: 8)
                    contentLabel.attributedText = attriMuStr
                    let contentHeight = attriMuStr.getRect(maxSize: CGSize(width: 260, height: ScreenHeight)).height
                    scrollView.snp.updateConstraints { (make) in
                        make.height.equalTo(contentHeight).priority(800)
                    }
                }
                
                let isForceUpdate = data.forceUpdate // 1.强更，0.不强更
                if isForceUpdate == 1 {
                    updateBtn.snp.updateConstraints { (make) in
                        make.left.equalToSuperview().offset(0)
                    }
                }
            }
        }
    }
    
    
    /// 白色背景框
    private var whiteView: UIView!
    /// 版本号
    private var versionLabel: UILabel!
    /// 内容
    private var contentLabel: UILabel!
    /// 滚动视图
    private var scrollView: UIScrollView!
    /// 更新按钮
    private var updateBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: ScreenBounds)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR: - 自定义公有方法
    /// 弹出
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(hex: "#000000", alpha: 0.5)
        }
    }
    
    /// 隐藏
    @objc func hidden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = .clear
            self.removeAllSubviews()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景框
            .taxi.layout(snapKitMaker: { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(300)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
            })
        
        _ = UIImageView().taxi.adhere(toSuperView: self) // 更新logo
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(whiteView.snp.top)
                make.centerX.equalTo(whiteView)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "updateHints")
            })
        
        let updateLabel = UILabel().taxi.adhere(toSuperView: whiteView) // “新版本更新”
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(74)
        }
            .taxi.config { (label) in
                label.text = "新版本更新"
                label.textColor = blackColor
                label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        versionLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 版本号
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalTo(updateLabel)
                make.width.equalTo(0).priority(800)
                make.height.equalTo(updateLabel).offset(-4)
                make.left.equalTo(updateLabel.snp.right).offset(5)
            })
            .taxi.config({ (label) in
                label.layer.cornerRadius = 4
                label.layer.masksToBounds = true
                label.backgroundColor = UIColor(hex: "#DCE4FF")
                
                label.textAlignment = .center
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 10)
            })
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: whiteView) // 滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(updateLabel.snp.bottom).offset(16)
                make.right.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(20)
                make.height.equalTo(0).priority(800)
                make.height.lessThanOrEqualTo(95)
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: scrollView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.width.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#666666")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(scrollView.snp.bottom).offset(10)
                make.left.bottom.equalToSuperview()
                make.height.equalTo(55)
            })
            .taxi.config({ (btn) in
                btn.setTitle("稍后", for: .normal)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(scrollView.snp.bottom).offset(9)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(scrollView.snp.bottom).offset(9)
                make.bottom.centerX.equalToSuperview()
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        updateBtn = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(scrollView.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(150)
                make.right.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.backgroundColor = .white
                btn.setTitle("更新", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(updateClick), for: .touchUpInside)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    // 升级
    @objc private func updateClick() {
        let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1463525035")
        UIApplication.shared.openURL(url!)
    }
}
