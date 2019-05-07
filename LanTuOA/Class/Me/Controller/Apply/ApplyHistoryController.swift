//
//  ApplyHistoryController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  申请记录  控制器

import UIKit
import MJRefresh
import MBProgressHUD

class ApplyHistoryController: UIViewController {

    /// 选择器
    private var segmentView: ProjectSegmentView!
    /// 滚动视图
    private var scrollView: UIScrollView!
    
    /// 页码
    private var page = [1, 1, 1, 1]
    /// 数据
    private var data = [[ProcessHistoryData](), [ProcessHistoryData](), [ProcessHistoryData](), [ProcessHistoryData]()]
    /// 是否加载过
    private var isLoaded = [true, false, false, false]
    /// tableview集合
    private var tableViewArray = [UITableView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        processHistory(isMore: false, tag: 0)
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "申请记录"
        view.backgroundColor = .white
        
        let titleArray = ["全部", "申请中", "已通过", "未通过"]
        segmentView = ProjectSegmentView(title: titleArray)
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
            })
            .taxi.config({ (segmentView) in
                segmentView.delegate = self
                segmentView.changeBtn(page: 0)

            })
        
        scrollView = UIScrollView().taxi.adhere(toSuperView: view) // 滚动视图
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(segmentView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
            .taxi.config({ (scrollView) in
                scrollView.delegate = self
                scrollView.isPagingEnabled = true
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.backgroundColor = UIColor(hex: "#F3F3F3")
            })
        
        var lastTableView: UITableView!
        for index in 0..<titleArray.count {
            let tableView = UITableView().taxi.adhere(toSuperView: scrollView) // tableview
                .taxi.layout { (make) in
                    make.top.width.height.equalToSuperview()
                    if index == 0 {
                        make.left.equalToSuperview()
                    } else {
                        make.left.equalTo(lastTableView.snp.right)
                    }
                    if index == titleArray.count - 1 {
                        make.right.equalToSuperview()
                    }
            }
                .taxi.config { (tableView) in
                    tableView.tag = index
                    tableView.delegate = self
                    tableView.dataSource = self
                    tableView.separatorStyle = .none
                    tableView.estimatedRowHeight = 50
                    tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                    tableView.register(ApplyHistoryCell.self, forCellReuseIdentifier: "ApplyHistoryCell")
                    tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                        tableView.mj_footer.isHidden = true
                        self?.processHistory(isMore: false, tag: index)
                    })
                    tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                        tableView.mj_header.isHidden = true
                        self?.processHistory(isMore: true, tag: index)
                    })
                    
                    let str = "暂无记录！"
                    let attriMuStr = NSMutableAttributedString(string: str)
                    attriMuStr.changeFont(str: str, font: UIFont.medium(size: 14))
                    attriMuStr.changeColor(str: str, color: UIColor(hex: "#999999"))
                    tableView.noDataLabel?.attributedText = attriMuStr
                    tableView.noDataImageView?.image = UIImage(named: "noneData2")
            }
            tableViewArray.append(tableView)
            lastTableView = tableView
        }
    }
    
    /// 刷新数据
    private func reloadData() {
        for index in 0..<isLoaded.count {
            let load = isLoaded[index]
            if load {
                processHistory(isMore: false, tag: index)
            }
        }
    }
    
    // MARK: - Api
    /// 历史申请列表
    private func processHistory(isMore: Bool, tag: Int) {
        MBProgressHUD.showWait("")
        let newPage = isMore ? page[tag] + 1 : 1
        var status: Int!
        if tag != 0 {
            status = tag
        }
        _ = APIService.shared.getData(.processHistory(status, newPage, 10), t: ProcessHistoryModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            if isMore {
                for model in result.data {
                    self.data[tag].append(model)
                }
                self.tableViewArray[tag].mj_footer.endRefreshing()
                self.tableViewArray[tag].mj_header.isHidden = false
                if result.data.count == 0 {
                    self.tableViewArray[tag].mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self.tableViewArray[tag].mj_footer.resetNoMoreData()
                }
                self.page[tag] += 1
            } else {
                self.page[tag] = 1
                self.data[tag] = result.data
                self.tableViewArray[tag].mj_header.endRefreshing()
                self.tableViewArray[tag].mj_footer.isHidden = false
            }
            self.tableViewArray[tag].isNoData = self.data[tag].count == 0
            self.tableViewArray[tag].reloadData()
        }, errorHandle: { (error) in
            if isMore {
                self.tableViewArray[tag].mj_footer.endRefreshing()
                self.tableViewArray[tag].mj_header.isHidden = false
            } else {
                self.tableViewArray[tag].mj_header.endRefreshing()
                self.tableViewArray[tag].mj_footer.isHidden = false
            }
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
}

extension ApplyHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[tableView.tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyHistoryCell", for: indexPath) as! ApplyHistoryCell
        cell.data = data[tableView.tag][indexPath.row]
        return cell
    }
}


extension ApplyHistoryController: ProjectSegmentDelegate {
    func changeScrollView(page: Int) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(page) * ScreenWidth, y: 0), animated: true)
        if !isLoaded[page] {
            isLoaded[page] = true
            processHistory(isMore: false, tag: page)
        }
    }
}


extension ApplyHistoryController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // 监听快速滑动，惯性慢慢停止
        if scrollView is UITableView {
            return
        }
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            let page = Int(scrollView.contentOffset.x / ScreenWidth)
            segmentView.changeBtn(page: page)
            if !isLoaded[page] {
                isLoaded[page] = true
                processHistory(isMore: false, tag: page)
            }
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
                if !isLoaded[page] {
                    isLoaded[page] = true
                    processHistory(isMore: false, tag: page)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ToExamineDetailsController()
        vc.checkListId = data[tableView.tag][indexPath.row].id
        vc.checkListName = data[tableView.tag][indexPath.row].name ?? ""
        vc.changeBlock = { [weak self] in
            self?.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
