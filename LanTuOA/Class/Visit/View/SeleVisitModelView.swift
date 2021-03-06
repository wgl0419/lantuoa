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
    /// 是否点击
    var isClick: Bool = true {
        didSet  {
            tableView.reloadData()
        }
    }
    /// 两行标题
    var attriMuTitleStr: NSMutableAttributedString? {
        didSet {
            if let attriMuStr = attriMuTitleStr {
                titleLabel.attributedText = attriMuStr
            }
        }
    }
    
    /// 灰色背景view
    private var grayView: UIView!
    /// tableview
    private var tableView: UITableView!
    /// 取消按钮
    private var cancelBtn: UIButton!
    /// 标题
    private var titleLabel: UILabel!
    
    /// 内容数组
    private var contentStrArray = [String]()
    ///状态
    private var statusArr = [Int]()
    /// 标题
    private var titleStr = ""
    
    var statusArray : [Int]? {
        didSet {
            if let statusArray = statusArray {
                statusArr = statusArray
                tableView.reloadData()
            }
            
        }
    }
    
    convenience init(title: String, content: [String]) {
        self.init(frame: ScreenBounds)
        titleStr = title
        contentStrArray = content
//        statusArray = status
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
                tableView.showsVerticalScrollIndicator = false
                tableView.separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
                tableView.register(SeleVisitModelCell.self, forCellReuseIdentifier: "SeleVisitModelCell")
            })
        
        layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableView.snp.updateConstraints { (make) in
            make.height.equalTo(contentHeight > 385 ? 400 : contentHeight)
        }
        
        titleLabel = UILabel().taxi.adhere(toSuperView: grayView) // "选择拜访方式"
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(50)
            })
            .taxi.config({ (label) in
                label.text = titleStr
                label.numberOfLines = 0
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
        cell.data = (contentStrArray[row], blackColor)

        if statusArr.count > 0 {
            cell.data1 = statusArr[row]
        }
        
        if !isClick { cell.selectionStyle = .none }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isClick else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if didBlock != nil {
            didBlock!(row)
        }
        hidden()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 55))
        footerView.backgroundColor = .white
        _ = UIView().taxi.adhere(toSuperView: footerView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: footerView) // 取消按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalToSuperview()
            })
            .taxi.config({ (btn) in
                if isClick {
                    btn.setTitle("取消", for: .normal)
                } else {
                    btn.setTitle("关闭", for: .normal)
                }
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
            })
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 55
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
