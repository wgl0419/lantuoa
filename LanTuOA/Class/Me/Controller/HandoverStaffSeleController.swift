//
//  HandoverStaffSeleController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/27.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作接手(工作交接 选择员工)  控制器

import UIKit

class HandoverStaffSeleController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    /// 搜索框
    private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "工作接手"
        view.backgroundColor = UIColor(hex: "#F3F3F3")
        
        let searchView = UIView().taxi.adhere(toSuperView: view) // 搜索框背景
            .taxi.layout { (make) in
                make.left.right.top.equalToSuperview()
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        searchBar = UISearchBar()
            .taxi.adhere(toSuperView: searchView) // 搜索框
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(searchView)
                make.top.left.equalTo(searchView).offset(10)
                make.right.equalTo(searchView).offset(-15)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
//                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = "员工名称"
                searchBar.returnKeyType = .done
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(searchView.snp.bottom).offset(10)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.register(HandoverStaffSeleCell.self, forCellReuseIdentifier: "HandoverStaffSeleCell")
            })
        
        self.perform(#selector(addClipRectCorner), with: nil, afterDelay: 0.01)
    }
    
    /// 添加圆角
    @objc private func addClipRectCorner() {
        let rectCorner = UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue
        tableView.clipRectCorner(UIRectCorner(rawValue: rectCorner), cornerRadius: 4)
    }
}

extension HandoverStaffSeleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HandoverStaffSeleCell", for: indexPath) as! HandoverStaffSeleCell
        return cell
    }
}
