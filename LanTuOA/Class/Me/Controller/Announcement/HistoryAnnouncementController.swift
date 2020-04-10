//
//  HistoryAnnouncementController.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import MBProgressHUD
class HistoryAnnouncementController: UIViewController {
    
    private var tableView: UITableView!
    /// 页码
    private var page = 1
    ///公告数据
    private var announcementData = [AnnouncementListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "历史公告"
        view.backgroundColor = .white
        
        checkAnnouncement(isMore: false)
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview()
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
                tableView.estimatedRowHeight = 85
                tableView.backgroundColor = kMainBackColor
                tableView.register(HistoryAnnouncementCell.self, forCellReuseIdentifier: "HistoryAnnouncementCell")
                tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                    self?.checkAnnouncement(isMore: false)
                    tableView.mj_footer.isHidden = true
                })
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                    self?.checkAnnouncement(isMore: true)
                    tableView.mj_header.isHidden = true
                    tableView.mj_footer.isHidden = true
                })
            })
    }
    
     // MARK: - Api
    /// 获取公告列表
    private func checkAnnouncement(isMore: Bool) {
        
        MBProgressHUD.showWait("")
        let newPage = isMore ? page + 1 : 1
        _ = APIService.shared.getData(.AnnouncementList(1,newPage,15), t: AnnouncementModel.self, successHandle: { (result) in
            
            if isMore {
                for model in result.data {
                    self.announcementData.append(model)
                }
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.isHidden = false
                self.page += 1
            } else {
                self.page = 1
                self.announcementData = result.data
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.isHidden = false
            }
            if result.data.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.resetNoMoreData()
            }
            MBProgressHUD.dismiss()
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
        if announcementData.count == 0 {
            setNoneData(str: "暂无公告内容！", imageStr: "noneData2")
        }
        tableView.isNoData = announcementData.count == 0
    }
    
}

extension HistoryAnnouncementController: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryAnnouncementCell", for: indexPath) as! HistoryAnnouncementCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: ScreenWidth, bottom: 0, right: 0)
        cell.data = announcementData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        UIApplication.shared.keyWindow?.endEditing(true)
        let announcement = AnnouncementView()
        announcement.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        announcement.data = self.announcementData[indexPath.row]
        UIApplication.shared.delegate?.window??.addSubview(announcement)
    }
}
