//
//  NoticeHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class NoticeHomeController: UIViewController {

    /// 选择器
    private var segmentView: SegmentView!
    /// 装载tableview的滚动视图
    private var scrollView: UIScrollView!
    /// 待处理信息 tableview
    private var waitTableView: UITableView!
    /// 系统信息 tableview
    private var systemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        navigationItem.title = "通知"
        let nav = navigationController as! MainNavigationController
        nav.backBtn.isHidden = false
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
    }
    
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = .white
        edgesForExtendedLayout = .top
        
        segmentView = SegmentView(title: ["待处理", "系统消息"])
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(44)
                make.top.left.right.equalToSuperview()
            })
            .taxi.config({ (segmentView) in
                segmentView.delegate = self
                segmentView.setTips(index: 0, showTips: true)
            })
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: view) // 装载tableview的滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(segmentView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
            .taxi.config({ (scrollView) in
                scrollView.delegate = self
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.isPagingEnabled = true
            })
        
        waitTableView = UITableView().taxi.adhere(toSuperView: scrollView) // 待处理信息 tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.height.width.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(NoticeHomeCell.self, forCellReuseIdentifier: "NoticeHomeCell")
            })
        
        systemTableView = UITableView().taxi.adhere(toSuperView: scrollView) // 系统信息 tableView
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(waitTableView.snp.right)
                make.top.right.height.width.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(NoticeHomeCell.self, forCellReuseIdentifier: "NoticeHomeCell")
            })
    }
}

extension NoticeHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeHomeCell", for: indexPath) as! NoticeHomeCell
        return cell
    }
}


extension NoticeHomeController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // 监听快速滑动，惯性慢慢停止
        if scrollView is UITableView {
            return
        }
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            let page = Int(scrollView.contentOffset.x / ScreenWidth)
            segmentView.changeBtn(page: page)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { // 手指控制直接停止
        if scrollView is UITableView {
            return
        }
        if !decelerate {
            let dragToDragStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if dragToDragStop {
                let page = Int(scrollView.contentOffset.x / ScreenWidth)
                segmentView.changeBtn(page: page)
            }
        }
    }
}

extension NoticeHomeController: SegmentViewDelegate {
    func changeScrollView(page: Int) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(page) * ScreenWidth, y: 0), animated: true)
    }
}
