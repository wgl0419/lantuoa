//
//  SeleVisitModelView.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  选择拜访方式

import UIKit

class SeleVisitModelView: UIView {

    /// 点击结果回调
    var didBlock: ((Int) -> ())?
    
    /// 灰色背景view
    private var grayView: UIView!
    /// tableview
    private var tableView: UITableView!
    
    /// 内容数组
    private var contentStrArray = [String]()
    /// 标题
    private var titleStr = ""
    
    
    convenience init(title: String, content: [String]) {
        self.init(frame: ScreenBounds)
        titleStr = title
        contentStrArray = content
        contentStrArray.append("取消")
        initSubViews()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidden))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        grayView = UIView().taxi.adhere(toSuperView: self) // 白色背景view
            .taxi.layout(snapKitMaker: { (make) in
                make.center.equalToSuperview()
                make.width.equalToSuperview().offset(-76)
            })
            .taxi.config({ (view) in
                view.layer.cornerRadius = 4
                view.layer.masksToBounds = true
                view.backgroundColor = UIColor(hex: "#F1F1F1")
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: grayView) // 主要显示tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(275) // 默认5行 -> 55 * 5
                make.top.equalToSuperview().offset(50)
                make.bottom.left.right.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.bounces = false
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 56
                tableView.separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
                tableView.register(SeleVisitModelCell.self, forCellReuseIdentifier: "SeleVisitModelCell")
            })
        
        layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(contentHeight > 385 ? 400 : contentHeight)
        }
        
        _ = UILabel().taxi.adhere(toSuperView: grayView) // "选择拜访方式"
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(50)
            })
            .taxi.config({ (label) in
                label.text = titleStr
                label.textColor = blackColor
                label.textAlignment = .center
                label.font = UIFont.medium(size: 16)
            })
    }
}

extension SeleVisitModelView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentStrArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeleVisitModelCell", for: indexPath) as! SeleVisitModelCell
        let row = indexPath.row
        cell.data = (contentStrArray[row], row == contentStrArray.count - 1 ? UIColor(hex: "#6B83D1") : blackColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row != contentStrArray.count - 1 {
            if didBlock != nil {
                didBlock!(row)
            }
        }
        hidden()
    }
}


extension SeleVisitModelView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        let grayViewFrame = grayView.convert(grayView.bounds, to: self)
        if grayViewFrame.contains(touchPoint) {
            return false
        } else {
            return true
        }
    }
}
