//
//  ContractScreenView.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/6.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户筛选  侧边view

import UIKit
import MBProgressHUD

class ContractScreenView: UIView {
    
    /// 点击确定回调 (发布时间戳  选中条件id数组  选中条件内容)
    var confirmBlock: ((Int?, [Int], [String]) -> ())?
    
    /// 白色背景图
    private var whiteView: UIView!
    /// tableview
    private var tableView: UITableView!
    /// 开始时间
    private var startBtn = UIButton()
    /// 结束时间
    private var endBtn = UIButton()
    
    /// 标题
    private let titleArray = ["客户", "项目", "业务人员"]
    /// 内容
    private var contentArray = ["", "", ""]
    /// 选中的id
    private var idArray = [-1, -1, -1]
    /// 发布时间
    private var releaseTimeStamp: Int!
    
    /// 客户数据
    private var customerData = [CustomerListStatisticsData]()
    /// 项目数据
    private var projectData = [ProjectListStatisticsData]()
    /// 业务人员数据
    private var usersData = [UsersData]()
    /// 加载过客户数据
    private var isCustomerData = false
    /// 加载或项目数据
    private var isProjectData = false
    /// 是否加载过客户数据
    private var isUsersData = false
    
    
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
    ///   - sele: 选中条件index
    func setDefault(release: Int?, id: [Int], content: [String]) {
        releaseTimeStamp = release
        idArray = id
        contentArray = content
        tableView.reloadData()
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
        
        tableView = UITableView().taxi.adhere(toSuperView: whiteView) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(SafeH)
                make.bottom.equalToSuperview().offset(-SafeH - 50)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                tableView.register(ContractScreenTimeCell.self, forCellReuseIdentifier: "ContractScreenTimeCell")
                tableView.register(ScreenOtherCell.self, forCellReuseIdentifier: "ScreenOtherCell")
            })
        
        /**************  底部块 **************/
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
    
    /// 选择时间
    private func seleTimeHandle() {
        let ejectView = SeleTimeEjectView(timeStamp: releaseTimeStamp, titleStr: "发布时间")
        ejectView.determineBlock = { [weak self] (timeStamp) in
            self?.releaseTimeStamp = timeStamp
            let timeStr = Date(timeIntervalSince1970: TimeInterval(timeStamp)).customTimeStr(customStr: "yyyy-MM-dd")
            self?.contentArray[0] = timeStr
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        ejectView.show()
    }
    
    /// 客户筛选
    private func customerScreening() {
        if !isCustomerData {
            customerList()
        } else {
            if customerData.count == 0 {
                MBProgressHUD.showError("暂无客户")
                return
            }
            let ejectView = ScreenEjectView(data: customerData)
            ejectView.seleBlock = { [weak self] (name, id) in
                if self?.idArray[0] == id { // 点击原本的数据
                    return
                } else {
                    self?.idArray[0] = id
                    self?.contentArray[0] = name
                    // 清空项目数据
                    self?.projectData = []
                    self?.idArray[1] = -1
                    self?.contentArray[1] = ""
                    self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)], with: .none)
                }
            }
            ejectView.show()
        }
    }
    
    /// 项目筛选
    private func projectScreening() {
        if !isProjectData {
            projectList()
        } else {
            if projectData.count == 0 {
                MBProgressHUD.showError("暂无项目")
                return
            }
            let ejectView = ScreenEjectView(data: projectData)
            ejectView.seleBlock = { [weak self] (name, id) in
                self?.idArray[1] = id
                self?.contentArray[1] = name
                self?.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
            }
            ejectView.show()
        }
    }
    
    private func usersScreening() {
        if !isUsersData {
            users()
        } else {
            if usersData.count == 0 {
                MBProgressHUD.showError("暂无业务人员")
                return
            }
            let ejectView = ScreenEjectView(data: usersData)
            ejectView.seleBlock = { [weak self] (name, id) in
                self?.idArray[2] = id
                self?.contentArray[2] = name
                self?.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
            }
            ejectView.show()
        }
    }
    
    // MAKR: - 按钮点击
    /// 点击重置
    @objc private func resetClick() {
        releaseTimeStamp = nil
        contentArray = ["", "", ""]
        idArray = [-1, -1, -1]
        tableView.reloadData()
    }
    
    /// 点击确定
    @objc private func confirmClick() {
        if confirmBlock != nil {
            confirmBlock!(releaseTimeStamp, idArray, contentArray)
        }
        hidden()
    }
    
    // MARK: - Api
    /// 客户列表
    private func customerList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.customerListStatistics("", nil, nil, 1, 99999), t: CustomerListStatisticsModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.isCustomerData = true
            self.customerData = result.data
            self.customerScreening()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取客户列表失败，请重试")
        })
    }
    
    /// 项目列表
    private func projectList() {
        let customerId = idArray[0]
        if customerId == -1 {
            MBProgressHUD.showError("请先选择客户")
            return
        }
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.projectList("", customerId, 1, 9999), t: ProjectListModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.isProjectData = true
            self.projectData = result.data
            self.projectScreening()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取项目失败，请重试")
        })
    }
    
    /// 业务人员列表
    private func users() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.users(1, 99999, "", 1), t: UsersModel.self, successHandle: { (result) in
            MBProgressHUD.dismiss()
            self.isUsersData = true
            self.usersData = result.data
            self.usersScreening()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取业务人员失败，请重试")
        })
    }
}

extension ContractScreenView: UIGestureRecognizerDelegate {
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

extension ContractScreenView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContractScreenTimeCell", for: indexPath) as! ContractScreenTimeCell
            cell.data = ("发布时间", "请选择", releaseTimeStamp)
            cell.screenBlock = { [weak self] in
                self?.seleTimeHandle()
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScreenOtherCell", for: indexPath) as! ScreenOtherCell
        cell.data = (titleArray[row - 1], "请选择", contentArray[row - 1])
        cell.screenBlock = { [weak self] in
            switch row {
            case 1: self?.customerScreening()
            case 2: self?.projectScreening()
            case 3: self?.usersScreening()
            default: break
            }
        }
        return cell
    }
}
