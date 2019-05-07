//
//  ContractListController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同列表    控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ContractListController: UIViewController {

    /// 筛选按钮
    private var screenBtn: UIButton!
    /// 搜索框
    private var searchBar: UISearchBar!
    /// 筛选内容
    private var screenView: ScreenView!
    /// tableview
    private var tableView: UITableView!
    
    /// 内容
    private var contentArray = ["", "", ""]
    /// 选中的id
    private var idArray = [-1, -1, -1]
    /// 发布时间
    private var releaseTimeStamp: Int!
    
    
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 页码
    private var page = 1
    /// 合同数据
    private var data = [ContractListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        contractList(isMore: false)
    }
    
    // MARk: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "合同"
        view.backgroundColor = UIColor(hex: "#F3F3F3")
        
        let barView = UIView().taxi.adhere(toSuperView: view) // bar背景view
            .taxi.layout { (make) in
                make.top.left.right.equalTo(view)
            }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        searchBar = UISearchBar().taxi.adhere(toSuperView: barView)
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(5)
                make.left.equalTo(barView).offset(10)
                make.right.equalTo(barView).offset(-55)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.placeholder = "项目名称/客户名称"
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
        
        screenView = ScreenView().taxi.adhere(toSuperView: view) // 筛选视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(barView.snp.bottom)
                make.left.right.equalToSuperview()
            })
            .taxi.config({ (view) in
                view.backgroundColor = .white
                view.layer.masksToBounds = true
                view.deleteBlock = { [weak self] (index) in
                    if index == 10086 { // 删除时间
                        self?.releaseTimeStamp = nil
                    } else { // 删除条件
                        self?.idArray[index] = -1
                        self?.contentArray[index] = ""
                    }
                    self?.contractList(isMore: false)
                }
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(screenView.snp.bottom)
                make.left.right.bottom.equalTo(view)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.register(ContractListCell.self, forCellReuseIdentifier: "ContractListCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    tableView.mj_footer.isHidden = true
                    self?.contractList(isMore: false)
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    tableView.mj_header.isHidden = true
                    self?.contractList(isMore: true)
                })
            })
        
        let str = "暂无合同！"
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: "noneData1")
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            contractList(isMore: false)
        }
    }
    
    /// 处理筛选视图
    private func setScreenView() {
        screenView.data = (releaseTimeStamp, nil, contentArray)
    }
    
    // MARK: - Api
    /// 历史合同
    private func contractList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        let customerId = idArray[0] == -1 ? nil : idArray[0] // 客户id
        let projectId = idArray[1] == -1 ? nil : idArray[1] // 项目id
        let userId = idArray[2] == -1 ? nil : idArray[2] // 用户id
        let startTimeStamp = releaseTimeStamp == 0 ? nil : releaseTimeStamp
        _ = APIService.shared.getData(.contractList(searchBar.text ?? "", customerId, projectId, userId, newPage, 10, startTimeStamp, nil), t: ContractListModel.self, successHandle: { (result) in
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
            self.tableView.isNoData = self.data.count == 0
        }, errorHandle: { (error) in
            if isMore {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
            } else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            MBProgressHUD.showError(error ?? "获取历史合同失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击筛选
    @objc private func screenClick() {
        UIApplication.shared.keyWindow?.endEditing(true)
        let showView = ContractScreenView()
        showView.setDefault(release: releaseTimeStamp, id: idArray, content: contentArray)
        showView.confirmBlock = { [weak self] (release, id, content) in
            self?.releaseTimeStamp = release
            self?.idArray = id
            self?.contentArray = content
            self?.contractList(isMore: false)
            self?.setScreenView()
        }
        showView.show()
    }
}

extension ContractListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContractListCell", for: indexPath) as! ContractListCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContractDetailsController()
        vc.contractListData = data[indexPath.row]
        vc.changeBlock = { [weak self] in
            self?.contractList(isMore: false)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ContractListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
