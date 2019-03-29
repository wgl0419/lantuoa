//
//  VisitHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  我的拜访 首页  控制器

import UIKit
import MJRefresh
import MBProgressHUD

class VisitHomeController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    /// 筛选按钮
    private var screenBtn: UIButton!
    /// 选择器
    private var segmentView: ProjectSegmentView!
    /// 搜索框
    private var searchBar: UISearchBar!
    
    
    /// 列表数据
    private var data = [VisitListData]()
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 页码
    private var page = 1
    /// 选择类型
    private var visitType = 0
    /// 开始时间戳
    private var startTimeStamp: Int!
    /// 结束时间戳
    private var endTimeStamp: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initSubViews()
        visitList(isMore: false)
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
                view.backgroundColor = .white
        }
        
        searchBar = UISearchBar().taxi.adhere(toSuperView: barView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(5)
                make.left.equalTo(barView).offset(10)
                make.bottom.equalToSuperview().offset(-5)
                make.right.equalTo(barView).offset(-55)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = "项目名称/拜访人"
                searchBar.returnKeyType = .done
            })
        
        screenBtn = UIButton().taxi.adhere(toSuperView: barView) // 筛选按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.right.equalToSuperview()
                make.top.equalToSuperview().offset(5)
                make.width.equalTo(barView.snp.height)
            })
            .taxi.config({ (btn) in
                btn.setTitle("筛选", for: .normal)
                btn.setTitleColor(blackColor, for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 10)
                btn.setImage(UIImage(named: "screen"), for: .normal)
                btn.addTarget(self, action: #selector(screenClick), for: .touchUpInside)
            })
        screenBtn.setSpacing()
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(barView.snp.bottom)
                make.left.right.bottom.equalTo(view)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(VisitHomeCell.self, forCellReuseIdentifier: "VisitHomeCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.visitList(isMore: false)
                    tableView.mj_footer.isHidden = true
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    self?.visitList(isMore: true)
                    tableView.mj_header.isHidden = true
                })
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
            visitList(isMore: false)
        }
    }
    
    // MARK: - Api
    /// 获取拜访列表
    ///
    /// - Parameter isMore: 是否获取更多
    private func visitList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.visitList(searchBar.text ?? "", nil, nil, 2, newPage, 10, nil, nil), t: VisitListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.data.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.data = result.data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.tableView.reloadData()
        }, errorHandle: { (error) in
            if isMore {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
            } else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }

    // MARK: - 按钮点击
    /// 填写拜访按钮
    @objc private func btnClick() {
        let vc = NewlyBuildVisitController()
        vc.addBlock = { [weak self] in
            self?.visitList(isMore: false)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击筛选
    @objc private func screenClick() {
        let showView = VisitSeleTimeView()
        showView.setDefault(start: startTimeStamp, end: endTimeStamp, sele: visitType)
        showView.confirmBlock = { [weak self] (start, end, index) in
            self?.startTimeStamp = start
            self?.endTimeStamp = end
            self?.visitType = index
            // TODO: 调用接口
        }
        showView.show()
    }
}

extension VisitHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitHomeCell", for: indexPath) as! VisitHomeCell
        cell.data = data[indexPath.row]
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
