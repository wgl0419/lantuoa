//
//  VisitHomeController.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/13.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  我的拜访 首页  控制器

import UIKit
import SnapKit
import MJRefresh
import MBProgressHUD

class VisitHomeController: UIViewController {

    /// tableview
    private var tableView: UITableView!
    /// 筛选按钮
    private var screenBtn: UIButton!
    /// 搜索框
    private var searchBar: UISearchBar!
    /// 筛选内容
    private var screenView: ScreenView!
    
    /// 列表数据
    private var data = [VisitListData]()
    /// 记录输入次数  -> 用于减少计算次数
    private var inputCout = 0
    /// 页码
    private var page = 1
    /// 开始时间戳
    private var startTimeStamp: Int!
    /// 结束时间戳
    private var endTimeStamp: Int!
    /// 内容
    private var contentArray = ["全部", "", "", ""]
    /// 选中的id
    private var idArray = [0, -1, -1, -1]
    
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "合同",
                                                            titleColor: .white,
                                                            titleFont: UIFont.medium(size: 15),
                                                            titleEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                                            target: self,
                                                            action: #selector(rightClick))
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
                searchBar.placeholder = "客户名称/项目名称/员工姓名"
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
                view.isVisit = true
                view.backgroundColor = .white
                view.layer.masksToBounds = true
                view.deleteBlock = { [weak self] (index) in
                    if index == 10086 { // 删除时间
                        self?.startTimeStamp = nil
                        self?.endTimeStamp = nil
                    } else if index == 0 { // 删除条件 -> 变回默认选项 id:0  str:全部
                        self?.idArray[0] = 0
                        self?.contentArray[0] = "全部"
                    } else if index == 1 { // 删除客户 -> 一起删除项目
                        self?.idArray[1] = -1
                        self?.contentArray[1] = ""
                        self?.idArray[2] = -1
                        self?.contentArray[2] = ""
                    } else {
                        self?.idArray[index] = -1
                        self?.contentArray[index] = ""
                    }
                    self?.visitList(isMore: false)
                }
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(screenView.snp.bottom)
                if #available(iOS 9.0, *) {
                    make.left.right.bottom.equalToSuperview()
                } else {
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-TabbarH)
                }
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
    
    /// 处理筛选视图
    private func setScreenView() {
        screenView.data = (startTimeStamp, endTimeStamp, contentArray)
    }
    
    /// 设置无数据信息
    ///
    /// - Parameters:
    ///   - str: 提示内容
    ///   - imageStr: 提示图片名称
    private func setNoneData(str: String, imageStr: String) {
        
        let attriMuStr = NSMutableAttributedString(string: str)
        attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
        attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
        tableView.noDataLabel?.attributedText = attriMuStr
        tableView.noDataImageView?.image = UIImage(named: imageStr)
    }
    
    /// 处理无数据
    private func noneDataHandle() {
        if data.count == 0 {
            let searchStr = searchBar.text ?? ""
            if searchStr.count == 0 {
                setNoneData(str: "暂无拜访", imageStr: "noneData2")
            } else {
                setNoneData(str: "搜索不到相关内容！", imageStr: "noneData4")
            }
        }
        tableView.isNoData = data.count == 0
    }
    
    // MARK: - Api
    /// 获取拜访列表
    ///
    /// - Parameter isMore: 是否获取更多
    private func visitList(isMore: Bool) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        let queryType = idArray[0] + 1 // 选择类型
        let cutomerId = idArray[1] == -1 ? nil : idArray[1] // 客户id
        let projectId = idArray[2] == -1 ? nil : idArray[2] // 项目id
        let createdUser = idArray[3] == -1 ? nil : idArray[3] // 用户id
        _ = APIService.shared.getData(.visitList(searchBar.text ?? "", startTimeStamp, endTimeStamp, queryType, newPage, 10, cutomerId, projectId, createdUser), t: VisitListModel.self, successHandle: { (result) in
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
            self.noneDataHandle()
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
    /// 点击我的合同
    @objc private func rightClick() {
        let vc = ContractListController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
        UIApplication.shared.keyWindow?.endEditing(true)
        let showView = VisitSeleTimeView()
        showView.setDefault(start: startTimeStamp, end: endTimeStamp, id: idArray, content: contentArray)
        showView.confirmBlock = { [weak self] (start, end, id, content) in
            self?.startTimeStamp = start
            self?.endTimeStamp = end
            self?.idArray = id
            self?.contentArray = content
            self?.visitList(isMore: false)
            self?.setScreenView()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = VisitDetailsController()
        vc.visitListData = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
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
