//
//  UpdateHintsEjectView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/23.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  更新提示  弹出框

import UIKit

class UpdateHintsEjectView: UIView {

    /// 白色背景框
    private var whiteView: UIView!
    /// 版本号
    private var versionLabel: UILabel!
    /// 内容
    private var contentLabel: UILabel!
    
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
        
        let scrollView = UIScrollView().taxi.adhere(toSuperView: whiteView) // 滚动视图
            .taxi.layout { (make) in
                make.top.equalTo(updateLabel.snp.bottom).offset(16)
                make.right.equalToSuperview().offset(-20)
                make.left.equalToSuperview().offset(20)
                make.height.lessThanOrEqualTo(95)
        }
        
        contentLabel = UILabel().taxi.adhere(toSuperView: scrollView) // 内容
            .taxi.layout(snapKitMaker: { (make) in
                make.left.top.width.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                let aa = "前后端分离架构。前端 nodejs WEB服务器，后端  tomcat WEB服务器。 前端POST数据时，后端@RequestBody  自动对参数转换成类对象时报错。 在filter中打印了 content-type ，发现是 application/x-www-form-urlencoded. --------------------- 作者：Zonson9999 来源：CSDN 原文：https://blog.csdn.net/wuzhong8809/article/details/84579209 版权声明：本文为博主原创文章，转载请附上博文链接！"
                let attriMuStr = NSMutableAttributedString(string: aa)
                attriMuStr.addLineSpacing(distance: 8)
                label.attributedText = attriMuStr
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
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().dividedBy(2).priority(800)
                make.top.equalTo(scrollView.snp.bottom).offset(10)
                make.right.bottom.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle("更新", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(updateClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(scrollView.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(scrollView.snp.bottom).offset(10)
                make.bottom.centerX.equalToSuperview()
                make.width.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
    }
    
    // MARK: - 按钮点击
    /// 点击取消
    @objc private func cancelClick() {
        hidden()
    }
    
    // 升级
    @objc private func updateClick() { // TODO:需更新后面的id
        let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1281436084")
        UIApplication.shared.openURL(url!)
    }
}
