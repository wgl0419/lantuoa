//
//  VisitSeleTimeView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访 选择时间 侧边弹出视图

import UIKit

class VisitSeleTimeView: UIView {

    /// 点击确定回调 (开始时间戳   结束时间戳  选中条件index)
    var confirmBlock: ((Int?, Int?, Int) -> ())?
    
    /// 白色背景图
    private var whiteView: UIView!
    /// 开始时间
    private var startBtn = UIButton()
    /// 结束时间
    private var endBtn = UIButton()
    
    /// 记录按钮
    private var btnArray = [UIButton]()
    /// 标记选中按钮 tag -> index + 100
    private var seleTag = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: ScreenBounds)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义公有方法
    /// 弹出
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(hex: "#000000", alpha: 0.5)
            self.whiteView.snp.updateConstraints({ (make) in
                make.right.equalToSuperview()
            })
            self.layoutIfNeeded()
        }
    }
    
    /// 隐藏
    @objc func hidden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = .clear
            self.whiteView.snp.updateConstraints({ (make) in
                make.right.equalToSuperview().offset(232)
            })
            self.layoutIfNeeded()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 设置默认值
    ///
    /// - Parameters:
    ///   - start: 开始时间戳
    ///   - end: 结束时间戳
    ///   - sele: 选中条件index
    func setDefault(start: Int?, end: Int?, sele: Int) {
        var startStr = ""
        if start != nil {
            startStr = Date(timeIntervalSince1970: TimeInterval(start!)).yearTimeStr()
        }
        startBtn.setTitle(startStr, for: .normal)
        
        var endStr = ""
        if end != nil {
            endStr = Date(timeIntervalSince1970: TimeInterval(end!)).yearTimeStr()
        }
        endBtn.setTitle(endStr, for: .normal)
        
        let btn = btnArray[sele]
        seleClick(btn: btn)
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidden))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        whiteView = UIView().taxi.adhere(toSuperView: self) // 白色背景图
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalTo(232)
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview().offset(232)
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
            })
        
        /**************  时间块  **************/
        let time = setModularHeader(titleStr: "时间", lastBtn: nil) // “时间”
        setTime(titleStr: "开始", btn: startBtn, lastView: time)
        setTime(titleStr: "开始", btn: endBtn, lastView: startBtn)
        
        /**************  条件块  **************/
        let condition = setModularHeader(titleStr: "条件", lastBtn: endBtn) // ”条件“
        
        let titleArray = ["全部", "我发起的", "我接手的", "工作组"]
        for index in 0..<4 {
            let row = index % 2
            let section = index / 2
            let btn = UIButton().taxi.adhere(toSuperView: whiteView)
                .taxi.layout { (make) in
                    make.top.equalTo(condition.snp.bottom).offset(section == 0 ? 30 : 72)
                    make.left.equalToSuperview().offset(row == 0 ? 15 : 104)
                    make.height.equalTo(26)
                    make.width.equalTo(74)
            }
                .taxi.config { (btn) in
                    btn.tag = index + 100
                    btn.layer.borderWidth = 1
                    btn.layer.cornerRadius = 4
                    btn.setTitleColor(.white, for: .selected)
                    btn.setTitle(titleArray[index], for: .normal)
                    btn.titleLabel?.font = UIFont.medium(size: 12)
                    btn.layer.borderColor = UIColor(hex: "#CCCCCC").cgColor
                    btn.setTitleColor(UIColor(hex: "#787E82"), for: .normal)
                    btn.addTarget(self, action: #selector(seleClick(btn:)), for: .touchUpInside)
            }
            btnArray.append(btn)
        }
        
        /**************  顶部块 **************/
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // "重置"
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview().offset(-SafeH)
                make.left.equalToSuperview()
                make.height.equalTo(50)
                make.width.equalTo(80)
            })
            .taxi.config({ (btn) in
                btn.setTitle("重置", for: .normal)
                btn.backgroundColor = UIColor(hex: "#E5E5E5")
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
                btn.addTarget(self, action: #selector(resetClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: whiteView) // “确定”
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(50)
                make.right.equalToSuperview()
                make.left.equalToSuperview().offset(80)
                make.bottom.equalToSuperview().offset(-SafeH)
            })
            .taxi.config({ (btn) in
                btn.setTitle("确定", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#2E4695")
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
            })
    }
    
    /// 设置模块头部
    ///
    /// - Parameters:
    ///   - titleStr: 标题
    ///   - lastBtn: 跟随的按钮
    /// - Returns: 标题label
    private func setModularHeader(titleStr: String, lastBtn: UIButton?) -> UILabel {
        let titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // “时间”
            .taxi.layout { (make) in
                if lastBtn == nil {
                    make.top.equalToSuperview().offset(22 + SafeH)
                } else {
                    make.top.equalTo(lastBtn!.snp.bottom).offset(38)
                }
                make.left.equalToSuperview().offset(15)
            }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
        }
        
        _ = UIView().taxi.adhere(toSuperView: whiteView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(7)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        return titleLabel
    }
    
    /// 设置时间块
    ///
    /// - Parameters:
    ///   - titleStr: 标题
    ///   - btn: 按钮
    ///   - lastView: 跟随的控件
    private func setTime(titleStr: String, btn: UIButton, lastView: UIView) {
        let titleLabel = UILabel().taxi.adhere(toSuperView: whiteView) // 标题
            .taxi.layout { (make) in
                if lastView is UILabel {
                    make.top.equalTo(lastView.snp.bottom).offset(22)
                } else {
                    make.top.equalTo(lastView.snp.bottom).offset(15)
                }
                make.left.equalToSuperview().offset(15)
        }
            .taxi.config { (label) in
                label.text = titleStr
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
        }
        
        btn.taxi.adhere(toSuperView: whiteView) // 按钮
            .taxi.layout { (make) in
                make.height.equalTo(30)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
            .taxi.config { (btn) in
                btn.layer.borderWidth = 1
                btn.layer.cornerRadius = 4
                btn.setTitleColor(blackColor, for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.layer.borderColor = UIColor(hex: "#CCCCCC").cgColor
                btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -7, bottom: 0, right: 7)
                btn.addTarget(self, action: #selector(setTimeClick(btn:)), for: .touchUpInside)
        }

        _ = UIImageView().taxi.adhere(toSuperView: whiteView) // 图标
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalTo(btn).offset(-10)
                make.width.height.equalTo(14)
                make.centerY.equalTo(btn)
            })
            .taxi.config({ (imageView) in
                imageView.image = UIImage(named: "date")
            })
    }
    
    // MAKR: - 按钮蒂娜及
    /// 设置选中时间
    @objc private func setTimeClick(btn: UIButton) {
        let ejectView = SeleVisitTimeView()
        ejectView.seleBlock = { (timeStr) in
            btn.setTitle(timeStr, for: .normal)
        }
        ejectView.show()
    }
    
    /// 选中按钮
    @objc private func seleClick(btn: UIButton) {
        if seleTag != btn.tag + 100 {
            if seleTag != 0 {
                let oldBnt = btnArray[seleTag - 100]
                oldBnt.isSelected = false
                oldBnt.backgroundColor = .white
                oldBnt.layer.borderColor = UIColor(hex: "#CCCCCC").cgColor
            }
            btn.isSelected = true
            btn.backgroundColor = UIColor(hex: "#2E4695")
            btn.layer.borderColor = UIColor(hex: "#2E4695").cgColor
            seleTag = btn.tag
        }
    }
    
    /// 点击重置
    @objc private func resetClick() {
        setDefault(start: nil, end: nil, sele: 0)
    }
    
    /// 点击确定
    @objc private func confirmClick() {
        if confirmBlock != nil {
            var startTimeStamp: Int! // 开始时间戳
            let startStr = startBtn.titleLabel?.text ?? ""
            if startStr.count > 0 {
                startTimeStamp = startStr.getTimeStamp(customStr: "yyyy-MM-dd HH:mm")
            }
            
            var endTimeStamp: Int! // 结束时间戳
            let endStr = endBtn.titleLabel?.text ?? ""
            if endStr.count > 0 {
                endTimeStamp = endStr.getTimeStamp(customStr: "yyyy-MM-dd HH:mm")
            }
            confirmBlock!(startTimeStamp, endTimeStamp, seleTag - 100)
        }
        hidden()
    }
}

extension VisitSeleTimeView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        let frame = whiteView.convert(whiteView.bounds, to: self)
        if frame.contains(touchPoint) {
            return false
        } else {
            return true
        }
    }
}
