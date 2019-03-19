//
//  VisitHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  我的拜访 首页  控制器

import UIKit

class VisitHomeController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    /// 选择器
    private var segmentView: ProjectSegmentView!
    /// 搜索框
    private var searchBar: UISearchBar!
    
    
    
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 设置导航栏
    private func setNav() {
        navigationItem.title = "拜访"
        let nav = navigationController as! MainNavigationController
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        nav.backBtn.isHidden = false
    }
    
    /// 初始化子控件
    private func initSubViews() {
        
        let barView = UIView().taxi.adhere(toSuperView: view) // bar背景view
            .taxi.layout { (make) in
                make.top.left.right.equalTo(view)
        }
            .taxi.config { (view) in
                
        }
        
        searchBar = UISearchBar().taxi.adhere(toSuperView: barView)
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(barView)
                make.top.left.equalTo(barView).offset(10)
                make.right.equalTo(barView).offset(-15)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = "项目名称/拜访人"
                searchBar.returnKeyType = .done
            })
        
        
        segmentView = ProjectSegmentView(title: ["全部", "我发起的", "我接手的", "工作组"])
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(barView.snp.bottom)
                make.left.right.equalTo(view)
                make.height.equalTo(50)
            })
            .taxi.config({ (segmentView) in
                segmentView.delegate = self
                segmentView.changeBtn(page: 0)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(segmentView.snp.bottom)
                make.left.right.bottom.equalTo(view)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(VisitHomeCell.self, forCellReuseIdentifier: "VisitHomeCell")
            })
        
        _ = UIButton().taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.width.height.equalTo(80)
                make.right.equalTo(view).offset(-15)
                make.bottom.equalTo(view).offset(-50 - TabbarH)
            })
            .taxi.config({ (btn) in
                btn.layer.cornerRadius = 40
                btn.layer.masksToBounds = true
                btn.setTitle("填写拜访", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#FF7744")
                btn.titleLabel?.font = UIFont.medium(size: 12)
                btn.setImage(UIImage(named: "fillVisit"), for: .normal)
                btn.setImage(UIImage(named: "fillVisit"), for: .highlighted)
                btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                btn.setSpacing(spacing: 5)
            })
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            
        }
    }

    // MARK: - 按钮点击
    /// 填写拜访按钮
    @objc private func btnClick() {
        let vc = NewlyBuildVisitController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VisitHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitHomeCell", for: indexPath) as! VisitHomeCell
        return cell
    }
    
}

extension VisitHomeController: ProjectSegmentDelegate {
    func changeScrollView(page: Int) {
        // TODO: 处理数据切换
    }
}


extension VisitHomeController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
