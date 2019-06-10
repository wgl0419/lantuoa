//
//  VisitDetailsController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/2.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访详情  控制器

import UIKit
import MBProgressHUD

class VisitDetailsController: UIViewController {

    
    /// 拜访数据
    var visitListData: VisitListData!
    /// 拜访id
    var visitListId: Int!
    
    /// tableview
    private var tableView: UITableView!
    /// 评论按钮
    private var commentBtn: UIButton!
    
    /// 拜访评论
    private var visitCommentData = [NotifyCheckCommentListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        if visitListId != nil {
            visitDetail()
        } else {
            visitListId = visitListData.id
        }
        visitCommentList()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "拜访详情"
        view.backgroundColor = .white
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮视图
            .taxi.layout { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(45 + (isIphoneX ? SafeH : 0))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        commentBtn = UIButton().taxi.adhere(toSuperView: btnView) // 评论按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(45)
            })
            .taxi.config({ (btn) in
                btn.setTitle("  留言评论", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.setImage(UIImage(named: "comment"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.setImage(UIImage(named: "comment"), for: .highlighted)
                btn.addTarget(self, action: #selector(commentClick), for: .touchUpInside)
            })
        
        
        tableView = UITableView(frame: .zero, style: .grouped).taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.separatorStyle = .none
                tableView.tableFooterView = UIView()
                tableView.sectionHeaderHeight = 0.01
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
                tableView.register(VisitDetailsCell.self, forCellReuseIdentifier: "VisitDetailsCell")
                tableView.register(VisitDetailsHeaderCell.self, forCellReuseIdentifier: "VisitDetailsHeaderCell")
                tableView.register(ToExamineCommentNameCell.self, forCellReuseIdentifier: "ToExamineCommentNameCell")
                tableView.register(ToExamineImagesCell.self, forCellReuseIdentifier: "ToExamineImagesCell")
                tableView.register(ToExamineEnclosureCell.self, forCellReuseIdentifier: "ToExamineEnclosureCell")
            })
    }
    
    /// 打开文件
    private func openFile(_ model: NotifyCheckListValue) {
        let objectName = model.objectName ?? ""
        let fileName = model.fileName ?? ""
        let type = fileName.components(separatedBy: ".").last ?? ""
        if type == "docx" || type == "png" || type == "jpg" || type == "jpeg" {
            MBProgressHUD.showWait("")
            let path = "/Visit/\(model.fileId)/" + fileName
            AliOSSClient.shared.download(url: objectName, path: path, isCache: true) { (data) in
                DispatchQueue.main.async(execute: {
                    if data != nil {
                        if #available(iOS 9.0, *) {
                            MBProgressHUD.dismiss()
                            let vc = WebController()
                            vc.enclosure = path
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            MBProgressHUD.showError("系统版本过低，无法预览")
                        }
                    } else {
                        MBProgressHUD.showError("打开失败，请重试")
                    }
                })
            }
        } else {
            MBProgressHUD.showError("不支持浏览该类型文件")
        }
    }
    
    // MARK: - Api
    /// 项目详情
    private func visitDetail() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.visitDetail(visitListId), t: VisitDetailModel.self, successHandle: { (result) in
            self.visitListData = result.data
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    /// 获取拜访评论
    private func visitCommentList() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.visitCommentList(visitListId), t: VisitCommentListModel.self, successHandle: { (result) in
            self.visitCommentData = result.data
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击评论
    @objc private func commentClick() {
        let vc = ToExamineCommentController()
        vc.title = visitListData.projectName ?? "留言评论"
        vc.checkListId = visitListId
        vc.descType = .visit
        vc.commentBlock = { [weak self] in
            self?.visitCommentList()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VisitDetailsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if visitListData != nil {
            return 3 + visitCommentData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return 1
        } else {
            let commentsModel = visitCommentData[section - 3].commentsFiles
            let imageArray = commentsModel.filter { (model) -> Bool in
                return model.fileType == 1
            }
            let fileArray = commentsModel.filter { (model) -> Bool in
                return model.fileType == 2
            }
            return 1 + fileArray.count + (imageArray.count > 0 ? 1 : 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailsHeaderCell", for: indexPath) as! VisitDetailsHeaderCell
            cell.data = visitListData
            return cell
        } else if  section < 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailsCell", for: indexPath) as! VisitDetailsCell
            let type: VisitDetailsCell.visitType = section == 1 ? .details : .result
            cell.visitListData = (visitListData, type)
            return cell
        } else {
            let commentsModel = visitCommentData[section - 3].commentsFiles
            let imageArray = commentsModel.filter { (model) -> Bool in
                return model.fileType == 1
            }
            if row == 0 { // 名称
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineCommentNameCell", for: indexPath) as! ToExamineCommentNameCell
                cell.data = visitCommentData[section - 3]
                return cell
            } else if imageArray.count > 0 && row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineImagesCell", for: indexPath) as! ToExamineImagesCell
                cell.isApproval = false
                cell.datas = imageArray
                cell.isComment = true
                return cell
            } else {
                let index = imageArray.count > 0 ? 2 : 1
                let fileArray = commentsModel.filter { (model) -> Bool in
                    return model.fileType == 2
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineEnclosureCell", for: indexPath) as! ToExamineEnclosureCell
                cell.data = fileArray[row - index]
                cell.isDelete = false
                cell.isComment = true
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < 2 || section == 2 + visitCommentData.count {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
            footerView.backgroundColor = .clear
            return footerView
        } else if section == 2 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
            footerView.backgroundColor = .clear
            _ = UILabel().taxi.adhere(toSuperView: footerView) // 评论
                .taxi.layout(snapKitMaker: { (make) in
                    make.left.equalToSuperview().offset(15)
                    make.centerY.equalToSuperview()
                })
                .taxi.config({ (label) in
                    label.text = "评论"
                    label.font = UIFont.regular(size: 12)
                    label.textColor = UIColor(hex: "#999999")
                })
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 2 || section == 2 + visitCommentData.count {
            return 10
        } else if section == 2 {
            return visitCommentData.count > 0 ? 40 : 0.01
        } else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section >= 3 {
            let row = indexPath.row
            let commentsModel = visitCommentData[section - 3].commentsFiles
            let imageArray = commentsModel.filter { (model) -> Bool in
                return model.fileType == 1
            }
            let index = imageArray.count > 0 ? 2 : 1
            if row >= index {
                let fileArray = commentsModel.filter { (model) -> Bool in
                    return model.fileType == 2
                }
                openFile(fileArray[row - index])
            }
        }
    }
}
