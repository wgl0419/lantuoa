//
//  FillInApplyController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  填写申请  控制器

import UIKit
import MBProgressHUD
import AssetsLibrary
import ZLPhotoBrowser

class FillInApplyController: UIViewController {
    
    /// 流程名称
    var processName = "流程名称"
    /// 流程id
    var processId = 0
    /// 流程类型
    var pricessType = 0
    /// 是否允许上传图片、附件，1允许，0不允许
    var canUpload = 0

    /// tableview
    private var tableView: UITableView!
    /// 提交按钮
    private var submissionBtn: UIButton!
    
    /// 数据
    private var data = [ProcessParamsData]()
    /// 审核人数据
    private var processUsersData: ProcessUsersData!
    /// 添加的抄送人数据
    private var carbonCopyData = [ProcessUsersCheckUsers]()
    /// 添加合同人员数据
    private var contractData = [(UsersData, String, String)]()
    /// 添加回款设置数据
    private var moneyBackData = [(Float, Int)]()
    /// 选中内容
    private var seleStrArray = [[String]]()
    /// 项目所在section
    private var projectPosition = -1
    /// 客户id
    private var customerId = -1
    /// 项目id
    private var projectId = -1
    /// 图片数据
    private var imageArray: [UIImage] = []
    /// 图片信息数据
    private var PHAssetArray: Array<PHAsset> = []
    /// 原图选项
    private var isOriginal = false
    /// 选中文件
    private var fileArray = [(Data, String)]()
    /// 上报的图片
    private var uploadImageIds = [Int]()
    /// 上报附件
    private var uploadFileIds = [Int]()

    
    /// 没有审批人
    private var isProcess = true {
        didSet {
            submissionBtn.setTitle("缺少审批人，不能提交", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        processParams()
        processUsers()
    }
    
    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = processName
        view.backgroundColor = .white
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮背景
            .taxi.layout { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(62 + (isIphoneX ? SafeH : 18))
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        submissionBtn = UIButton().taxi.adhere(toSuperView: btnView) // 提交按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().offset(-30)
                make.top.equalToSuperview().offset(18)
                make.centerX.equalToSuperview()
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitle("提交", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(submissionClick), for: .touchUpInside)
            })
        
        
        tableView = UITableView(frame: .zero, style: .grouped).taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.sectionHeaderHeight = 0.01
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
                tableView.register(NewlyBuildVisitSeleCell.self, forCellReuseIdentifier: "NewlyBuildVisitSeleCell")
                tableView.register(FillInApplyTextViewCell.self, forCellReuseIdentifier: "FillInApplyTextViewCell")
                tableView.register(FillInApplyFieldViewCell.self, forCellReuseIdentifier: "FillInApplyFieldViewCell")
                tableView.register(FillInApplyApprovalCell.self, forCellReuseIdentifier: "FillInApplyApprovalCell")
                tableView.register(FillInApplyPersonnelCell.self, forCellReuseIdentifier: "FillInApplyPersonnelCell")
                tableView.register(FillInApplyMoneyBackCell.self, forCellReuseIdentifier: "FillInApplyMoneyBackCell")
                tableView.register(ToExamineImageCell.self, forCellReuseIdentifier: "ToExamineImageCell")
                tableView.register(ToExamineEnclosureCell.self, forCellReuseIdentifier: "ToExamineEnclosureCell")
                tableView.register(ToExamineEnclosureTitleCell.self, forCellReuseIdentifier: "ToExamineEnclosureTitleCell")
            })
    }
    
    /// 确认按钮处理
    private func confirmHandle() {
        if isProcess {
            var isEnabled = true
            for index in 0..<data.count {
                let model = data[index]
                if model.isNecessary == 1 && seleStrArray[index].count == 0 {
                    isEnabled = false
                    break
                }
            }
            if isEnabled && pricessType == 5 {
                isEnabled = contractData.count > 0 && moneyBackData.count > 0
            }
            
            if isEnabled {
                submissionBtn.backgroundColor = UIColor(hex: "#2E4695")
                submissionBtn.isEnabled = true
            } else {
                submissionBtn.isEnabled = false
                submissionBtn.backgroundColor = UIColor(hex: "#CCCCCC")
            }
        }
    }
    
    /// 选择时间
    private func seleTimeHandle(indexPath: IndexPath) {
        UIApplication.shared.keyWindow?.endEditing(true)
        let row = indexPath.row
        let section = indexPath.section
        let timeStr = seleStrArray[section][row]
        var timeStamp: Int!
        if timeStr.count > 0 {
            timeStamp = timeStr.getTimeStamp(customStr: "yyyy-MM-dd")
        }
        let titleStr = data[section].type != 8 ? data[section].title : data[section].children[row].name
        let ejectView = SeleTimeEjectView(timeStamp: timeStamp, titleStr: titleStr ?? "")
        ejectView.determineBlock = { [weak self] (timeStamp) in
            let timeStr = Date(timeIntervalSince1970: TimeInterval(timeStamp)).customTimeStr(customStr: "yyyy-MM-dd")
            self?.seleStrArray[section][row] = timeStr
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)
            self?.confirmHandle()
        }
        ejectView.show()
    }
    
    /// 单选
    private func singleSeleHandle(indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        var contentArray = [String]()
        let choicesData = data[section].type != 8 ? data[section].choices : data[section].children[row].choices
        for model in choicesData {
            contentArray.append(model.name ?? "")
        }
        let view = SeleVisitModelView(title: "选择拜访方式", content: contentArray)
        view.didBlock = { [weak self] (seleIndex) in
            self?.seleStrArray[section][row] = contentArray[seleIndex]
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)
            self?.confirmHandle()
        }
        view.show()
    }
    
    /// 多选处理
    private func multipleSeleHandle(indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        var contentArray = [String]()
        let choicesData = data[section].type != 8 ? data[section].choices : data[section].children[row].choices
        for model in choicesData {
            contentArray.append(model.name ?? "")
        }
        let vc = MultipleSeleController()
        vc.contentArray = contentArray
        vc.didBlock = { [weak self] (seleArray) in
            var seleStr = ""
            for str in seleArray {
                seleStr.append("、" + str)
            }
            if seleStr.count > 0 { seleStr.remove(at: seleStr.startIndex) }
            self?.seleStrArray[section][row] = seleStr
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择客户
    private func seleCustomerHandle(indexPath: IndexPath) {
        let vc = NewlyBuildVisitSeleController()
        vc.isAdd = false
        vc.type = .customer
        let row = indexPath.row
        let section = indexPath.section
        vc.seleBlock = { [weak self] (customerArray) in
            if self?.customerId != customerArray.first?.0 ?? -1 {
                let position = self?.projectPosition ?? 0
                self?.customerId = customerArray.first?.0 ?? -1
                self?.seleStrArray[section][row] = customerArray.first?.1 ?? ""
                // 重置数据 -> 防止出现选择项目后 修改客户
                self?.projectId = -1
                if position != -1 {
                    self?.seleStrArray[position][0] = ""
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: position)], with: .none)
                }
                
                self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)
                self?.confirmHandle()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择项目
    private func seleProjectHandle(indexPath: IndexPath) {
        guard customerId != -1 else {
            MBProgressHUD.showError("请先选择客户")
            return
        }
        let row = indexPath.row
        let section = indexPath.section
        let customerName = seleStrArray[projectPosition][0]
        let vc = NewlyBuildVisitSeleController()
        vc.type = .project(customerId, customerName)
        vc.isAdd = false
        
        vc.seleBlock = { [weak self] (customerArray) in
            self?.projectId = customerArray.first?.0 ?? -1
            self?.seleStrArray[section][row] = customerArray.first?.1 ?? ""
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)
            self?.confirmHandle()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 数据处理
    private func dataHandld() {
        data.sort { (model1, model2) -> Bool in
            return model1.sort < model2.sort
        }
        for index in 0..<data.count {
            let model = data[index]
            if model.type == 7 { // 客户
                projectPosition = index
            }
            if model.type == 8 { // 表单
                data[index].children.sort { (model1, model2) -> Bool in
                    return model1.sort < model2.sort
                }
                let smallArray = data[index].children
                var array = [String]()
                for _ in smallArray {
                    array.append("")
                }
                seleStrArray.append(array)
            } else {
                seleStrArray.append([""])
            }
            
        }
    }
    
    /// 审批人梳理
    private func processHandld() {
        for model in processUsersData.checkUsers {
            if model.checkUserId == 0 {
                isProcess = false
            }
        }
    }
    
    /// 添加抄送人处理
    private func addCarbonCopyHandle(indexPath: IndexPath) {
        let vc = SelePersonnelController()
        var prohibitIds = [Int]()
        for model in processUsersData.ccUsers {
            prohibitIds.append(model.checkUserId)
        }
        vc.prohibitIds = prohibitIds
        vc.displayData = ("请选择", "添加", .back)
        vc.backBlock = { [weak self] (users) in
            for model in users {
                var newModel = ProcessUsersCheckUsers()
                newModel.checkUserId = model.id
                newModel.realname = model.realname
                let position = model.roleList.count == 0 ? "员工" : model.roleList[0].name ?? "员工"
                newModel.roleName = position
                self?.carbonCopyData.append(newModel)
                self?.processUsersData.ccUsers.append(newModel)
            }
            self?.tableView.reloadRows(at: [indexPath], with: .none)
            self?.confirmHandle()
            self?.perform(#selector(self?.reloadRows(indexPath:)), with: indexPath, afterDelay: 0.1)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func reloadRows(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    /// 删除抄送人处理
    private func deleteCarbonCopyHandle(indexPath: IndexPath, row: Int) {
        let oldCount = processUsersData.ccUsers.count - carbonCopyData.count
        let deleteRow = row - oldCount
        carbonCopyData.remove(at: deleteRow)
        processUsersData.ccUsers.remove(at: row)
        tableView.reloadRows(at: [indexPath], with: .none)
        confirmHandle()
    }
    
    /// 处理添加人员
    private func addPersonnelHandle() {
        // 剩余的业绩百分比和提成百分比
        var achievemenhtsPercentage = 100
        var royaltyPercentage = 100
        for model in contractData {
            achievemenhtsPercentage -= Int(model.1) ?? 0
            royaltyPercentage -= Int(model.2) ?? 0
        }
        
        if achievemenhtsPercentage == 0 && royaltyPercentage == 0 {
            MBProgressHUD.showError("分配完毕，无法继续添")
            return
        }
        
        let ejectView = FillInApplyAddPersonnelEjectView()
        
        ejectView.maxInput = [achievemenhtsPercentage, royaltyPercentage]
        ejectView.determineBlock = { [weak self] (userData, achievemenhts, royalty) in
            self?.contractData.append((userData, achievemenhts, royalty))
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: self?.data.count ?? 0)], with: .none)
            self?.confirmHandle()
        }
        ejectView.seleBlock = { [weak self] in
            ejectView.isHidden = true
            let vc = SelePersonnelController()
            var prohibitIds = [Int]()
            for model in (self?.contractData)! {
                prohibitIds.append(model.0.id)
            }
            vc.prohibitIds = prohibitIds
            vc.isMultiple = false
            vc.displayData = ("选择人员", "选定", .back)
            vc.backBlock = { (users) in
                if users.count > 0 {
                    ejectView.userData = users[0]
                }
                ejectView.isHidden = false
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        ejectView.show()
    }
    
    /// 处理添加人员
    private func addMoneyBackHandle() {
        if moneyBackData.count == 9 {
            MBProgressHUD.showSuccess("回款设置过多，不能继续添加")
            return
        }
        let ejectView = AddMoneyBackEjectView()
        ejectView.titleStr = "新增回款时间"
        ejectView.addBlock = { [weak self] (money, timeStamp) in
            self?.moneyBackData.append((money, timeStamp))
            self?.tableView.reloadRows(at: [IndexPath(row: 0, section: (self?.data.count ?? 0) + 1)], with: .none)
            self?.confirmHandle()
        }
        ejectView.show()
    }
    
    /// 处理添加人员
    private func deletePersonnelHandle(index: Int) {
        let alertController = UIAlertController(title: "提示", message: "是否删除该合同人员", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (_) in
            self.contractData.remove(at: index)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: self.data.count)], with: .none)
            self.confirmHandle()
        }
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 处理添加人员
    private func deleteMoneyBackHandle(index: Int) {
        let alertController = UIAlertController(title: "提示", message: "是否该回款设置", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (_) in
            self.moneyBackData.remove(at: index)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: self.data.count + 1)], with: .none)
            self.confirmHandle()
        }
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 审批人cell
    private func getApprovalCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyApprovalCell", for: indexPath) as! FillInApplyApprovalCell
        cell.isApproval = true
        cell.isProcess = isProcess
        cell.data = processUsersData.checkUsers
        return cell
    }
    
    /// 图片cell
    private func getImageCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineImageCell", for: indexPath) as! ToExamineImageCell
        cell.data = imageArray
        cell.imageBlock = { [weak self] in
            UIApplication.shared.keyWindow?.endEditing(true)
            self?.imageClick()
        }
        cell.deleteBlock = { [weak self] (row) in
            self?.imageArray.remove(at: row)
            self?.PHAssetArray.remove(at: row)
            self?.reloadImageCell()
        }
        return cell
    }
    
    /// 附件标题cell
    private func getEnclosureTitleCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineEnclosureTitleCell", for: indexPath) as! ToExamineEnclosureTitleCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: ScreenWidth, bottom: 0, right: 0)
        cell.enclosureBlock = {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "相册", style: .default) { _ in
                self.addImageEnclosure()
            }
            let albumAction = UIAlertAction(title: "文档", style: .default) { _ in
                let vc = UIDocumentPickerViewController(documentTypes: ["public.content","public.text"], in: .open)
                vc.delegate = self
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(albumAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    /// 附件cell
    private func getEnclosureCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineEnclosureCell", for: indexPath) as! ToExamineEnclosureCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: ScreenWidth, bottom: 0, right: 0)
        cell.enclosureData = fileArray[indexPath.row - 2]
        cell.deleteBlock = { [weak self] in
            self?.fileArray.remove(at: indexPath.row - 2)
            self?.reloadImageCell()
        }
        return cell
    }
    
    /// 抄送人cell
    private func getCarbonCopyCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyApprovalCell", for: indexPath) as! FillInApplyApprovalCell
        cell.isApproval = false
        cell.isProcess = true
        let oldCount = processUsersData.ccUsers.count - carbonCopyData.count // 原本的抄送人数量
        cell.oldCount = oldCount
        cell.data = processUsersData.ccUsers
        cell.addBlock = { [weak self] in
            self?.addCarbonCopyHandle(indexPath: indexPath)
        }
        cell.deleteBlock = { [weak self] (row) in
            self?.deleteCarbonCopyHandle(indexPath: indexPath, row: row)
        }
        return cell
    }
    
    /// 点击添加图片
    @objc private func imageClick() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "摄像", style: .default) { _ in
            self.showImagePicker(.camera)
        }
        let albumAction = UIAlertAction(title: "从手机相册选择", style: .default) { _ in
            self.changeImage()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(albumAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 打开照相机
    private func showImagePicker(_ sourceType: UIImagePickerController.SourceType) {
        // 弹出相片选择器
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    /// 刷新图片cell
    private func reloadImageCell() {
        let section = pricessType == 5 ? data.count + 3 : data.count + 1
        tableView.reloadSections(IndexSet(arrayLiteral: section), with: .fade)
    }
    
    /// 相册修改图片
    private func changeImage(indexPath: Int = -1) {
        let photoSheet = ZLPhotoActionSheet()
        photoSheet.sender = self
        photoSheet.configuration.allowEditImage = false
        photoSheet.selectImageBlock = { [weak self] images, assets, isOriginal in
            self?.imageArray = images!
            self?.PHAssetArray = assets
            self?.isOriginal = isOriginal
            self?.reloadImageCell()
        }
        if indexPath < 0 { // 添加图片
            let arrSelectedAssets = NSMutableArray()
            for item in PHAssetArray {
                arrSelectedAssets.add(item)
            }
            photoSheet.arrSelectedAssets = arrSelectedAssets
            photoSheet.configuration.maxSelectCount = 9
            photoSheet.configuration.allowSelectGif = false
            photoSheet.configuration.allowSelectVideo = false
            photoSheet.configuration.allowSlideSelect = false
            photoSheet.configuration.allowSelectLivePhoto = false
            photoSheet.configuration.allowTakePhotoInLibrary = false
            photoSheet.showPhotoLibrary()
        } else { // 浏览图片
            photoSheet.previewSelectedPhotos(imageArray, assets: PHAssetArray, index: indexPath, isOriginal: isOriginal)
//            photoSheet.previewPhotos(<#T##photos: [[AnyHashable : Any]]##[[AnyHashable : Any]]#>, index: <#T##Int#>, hideToolBar: <#T##Bool#>, complete: <#T##([Any]) -> Void#>)
        }
    }
    
    /// 上传文件
    private func uploadGetKey() {
        uploadImageIds = []
        uploadFileIds = []
        if imageArray.count == 0 && fileArray.count == 0 {
            self.processCommit()
        } else {
            var uploadDataArray = [Any]()
            for image in imageArray {
                uploadDataArray.append(image)
            }
            for file in fileArray {
                uploadDataArray.append(file)
            }
            for index in 0..<uploadDataArray.count {
                var size = 0
                var type: Int!
                var name: String!
                var uploadData: Data!
                if index < imageArray.count {
                    type = 1
                    name = "".randomStringWithLength(len: 8) + ".png"
                    uploadData = imageArray[index].jpegData(compressionQuality: 0.5) ?? Data()
                } else {
                    type = 2
                    name = fileArray[index - imageArray.count].1
                    uploadData = fileArray[index - imageArray.count].0
                    size = fileArray[index - imageArray.count].0.count
                }
                fileUploadGetKey(type: type, name: name, size: size) { (status, body, path) in
                    if status {
                        self.uploadData(uploadData, name: path ?? "", body: body!, type: type, isLast: index == uploadDataArray.count - 1)
                    }
                }
            }
        }
    }
    
    /// 上传数据
    private func uploadData(_ data: Data, name: String, body: Int, type: Int, isLast: Bool) {
        AliOSSClient.shared.uploadData(data, name: name, body: body) { (status) in
            if status {
                if type == 1 {
                    self.uploadImageIds.append(body)
                } else {
                    self.uploadFileIds.append(body)
                }
                if isLast {
                    DispatchQueue.main.async(execute: {
                        if self.uploadFileIds.count == self.fileArray.count && self.uploadImageIds.count == self.imageArray.count {
                            self.processCommit()
                        } else {
                            MBProgressHUD.showError("上传失败")
                        }
                    })
                    
                }
            }
        }
    }
    
    
    /// 获取提交时的data部分的数据处理
    private func processDataHnadle(_ model: ProcessParamsData, str: String) -> String {
        var contentStr = str
        if model.type == 3 { // 时间
            contentStr = "\(contentStr.getTimeStamp(customStr: "yyyy-MM-dd"))"
        } else if model.type == 6 { // 客户
            contentStr = "\(customerId)"
        } else if model.type == 7 { // 项目
            contentStr = "\(projectId)"
        }
        return contentStr
    }
    
    /// 生成文件名称
    private func initFileName(_ name: String) -> String {
        let fileName = name.components(separatedBy: ".").first ?? ""
        let type = name.components(separatedBy: ".").last ?? ""
        let similarName = fileArray.filter { (model) -> Bool in
            return model.1.contains(fileName)
        }
        if similarName.count > 0 {
            let lastSimilar = similarName.last ?? (Data(), "")
            if lastSimilar.1.contains("(") {
                var index = lastSimilar.1.components(separatedBy: "(").last ?? ""
                index = index.components(separatedBy: ")").first ?? ""
                let number = 1 + (Int(index) ?? 0)
                return fileName + "(\(number))." + type
            } else {
                return fileName + "(1)." + type
            }
        } else {
            return name
        }
    }
    
    /// 添加图片附件
    private func addImageEnclosure() {
        let photoSheet = ZLPhotoActionSheet()
        photoSheet.sender = self
        photoSheet.configuration.allowEditImage = false
        photoSheet.selectImageBlock = { [weak self] images, assets, isOriginal in
            let image = images![0]
            let fileName = "".randomStringWithLength(len: 8) + ".png"
            let fileData = image.pngData() ?? Data()
            self?.fileArray.append((fileData, fileName))
            self?.reloadImageCell()
        }
        photoSheet.configuration.maxSelectCount = 1
        photoSheet.configuration.allowSelectGif = false
        photoSheet.configuration.allowSelectVideo = false
        photoSheet.configuration.allowSlideSelect = false
        photoSheet.configuration.allowSelectLivePhoto = false
        photoSheet.configuration.allowTakePhotoInLibrary = false
        photoSheet.showPhotoLibrary()
    }
    
    // MARK: - Api
    /// 获取流程内容
    private func processParams() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.processParams(processId), t: ProcessParamsModel.self, successHandle: { (result) in
            self.data = result.data
            self.dataHandld()
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "获取流程内容失败,请下拉重新加载")
        })
    }
    
    /// 获取流程默认审批/抄送人
    private func processUsers() {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.processUsers(processId), t: ProcessUsersModel.self, successHandle: { (result) in
            self.processUsersData = result.data
            self.processHandld()
            self.tableView.reloadData()
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "")
        })
    }
    
    /// 提交流程
    private func processCommit() {
        MBProgressHUD.showWait("")
        
        /// 数据
        var dataDic: [String:Any] = [:]
        for index in 0..<data.count {
            let model = data[index]
            if model.type < 8 {
                var contentStr = seleStrArray[index][0]
                contentStr = processDataHnadle(model, str: contentStr)
                dataDic.updateValue(contentStr, forKey: model.name ?? "")
            } else { // 表单
                var dic: [String:String] = [:]
                let children = model.children
                for childrenIndex in 0..<children.count {
                    let smallModel = children[childrenIndex]
                    var contentStr = seleStrArray[index][childrenIndex]
                    contentStr = processDataHnadle(model, str: contentStr)
                    dic.updateValue(contentStr, forKey: smallModel.name ?? "")
                }
                dataDic.updateValue(dic, forKey: model.name ?? "")
            }
        }
        
        /// 成员
        var memberArray = [[String:String]]()
        if pricessType == 5 {
            for index in 0..<contractData.count {
                let model = contractData[index]
                var dic: [String:String] = [:]
                dic["userId"] = "\(model.0.id)"
                dic["propPerform"] = model.1
                dic["propMoney"] = model.2
                memberArray.append(dic)
            }
        }
        
        /// 抄送人
        var ccUsersArray = [[String:String]]()
        for index in 0..<carbonCopyData.count {
            let model = carbonCopyData[index]
            var dic: [String:String] = [:]
            dic["checkUser"] = "\(model.checkUserId)"
            dic["checkUserName"] = model.realname ?? ""
            ccUsersArray.append(dic)
        }
        
        /// 金额设置
        var moneyBackArray = [[String:String]]()
        for index in 0..<moneyBackData.count {
            let model = moneyBackData[index]
            var dic: [String:String] = [:]
            dic["money"] = "\(model.0)"
            dic["payTime"] = "\(model.1)"
            moneyBackArray.append(dic)
        }
        
        /// 文件
        var files = [[String:String]]()
        for index in 0..<uploadFileIds.count {
            let fileId = uploadFileIds[index]
            var dic: [String:String] = [:]
            dic["fileId"] = "\(fileId)"
            files.append(dic)
        }
        
        /// 图片
        var imgs = [[String:String]]()
        for index in 0..<uploadImageIds.count {
            let fileId = uploadImageIds[index]
            var dic: [String:String] = [:]
            dic["fileId"] = "\(fileId)"
            imgs.append(dic)
        }
        
        _ = APIService.shared.getData(.processCommit(processId, dataDic, memberArray, ccUsersArray, moneyBackArray, files, imgs), t: LoginModel.self, successHandle: { (result) in
            MBProgressHUD.showSuccess("申请成功")
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "申请失败")
        })
    }
    
    /// 上传文件报备
    ///
    /// - Parameters:
    ///   - type: 文件类型 1.图片，2.文件
    ///   - type: 文件名称
    ///   - size: 文件大小
    private func fileUploadGetKey(type: Int, name: String, size: Int, block: @escaping ((Bool, Int?, String?) -> ())) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.fileUploadGetKey(type, name, size), t: FileUploadGetKeyModel.self, successHandle: { (result) in
            block(true, result.data?.id, result.data?.objectName)
        }, errorHandle: { (error) in
            block(false, nil, nil)
            MBProgressHUD.showError(error ?? "上传失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击提交
    @objc private func submissionClick() {
        if pricessType == 5 {
            // 剩余的业绩百分比和提成百分比
            var achievemenhtsPercentage = 100
            var royaltyPercentage = 100
            for model in contractData {
                achievemenhtsPercentage -= Int(model.1) ?? 0
                royaltyPercentage -= Int(model.2) ?? 0
            }

            if achievemenhtsPercentage != 0 {
                MBProgressHUD.showError("业绩比例未分配完全")
                return
            } else if royaltyPercentage != 0 {
                MBProgressHUD.showError("提成比例未分配完全")
                return
            }
        }
        uploadGetKey()
    }
}

extension FillInApplyController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if processUsersData != nil {
            let pricesCount = pricessType == 5 ? data.count + 4 : data.count + 2
            return pricesCount + canUpload
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if canUpload == 1 {
            let upload = pricessType == 5 ? data.count + 3 : data.count + 1
            if section == upload {
                return 2 + fileArray.count
            }
        }
        if section < seleStrArray.count && seleStrArray.count > 0 {
            return seleStrArray[section].count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if section == data.count {
            if pricessType == 5 { // 合同人员
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyPersonnelCell", for: indexPath) as! FillInApplyPersonnelCell
                cell.data = contractData
                cell.addBlock = { [weak self] in
                    UIApplication.shared.keyWindow?.endEditing(true)
                    self?.addPersonnelHandle()
                    self?.confirmHandle()
                }
                cell.deleteBlock = { [weak self] (index) in
                    self?.deletePersonnelHandle(index: index)
                }
                return cell
            } else { // 审批人
                return getApprovalCell(indexPath)
            }
        } else if section == data.count + 1 {
            if pricessType == 5 { // 回款设置
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyMoneyBackCell", for: indexPath) as! FillInApplyMoneyBackCell
                cell.data = moneyBackData
                cell.addBlock = { [weak self] in
                    UIApplication.shared.keyWindow?.endEditing(true)
                    self?.addMoneyBackHandle()
                    self?.confirmHandle()
                }
                cell.deleteBlock = { [weak self] (index) in
                    self?.deleteMoneyBackHandle(index: index)
                }
                return cell
            } else {
                if canUpload == 1 { // 上传部分
                    if indexPath.row == 0 {
                        return getImageCell(indexPath)
                    } else if indexPath.row == 1 {
                        return getEnclosureTitleCell(indexPath)
                    } else {
                        return getEnclosureCell(indexPath)
                    }
                } else { // 抄送人cell
                    return getCarbonCopyCell(indexPath)
                }
            }
        } else if section > data.count {
            if pricessType == 5 && section == data.count + 2 { // 审批人
                return getApprovalCell(indexPath)
            } else if pricessType == 5 && section == data.count + 3 {
                if canUpload == 1 { // 上传部分
                    if indexPath.row == 0 {
                        return getImageCell(indexPath)
                    } else if indexPath.row == 1 {
                        return getEnclosureTitleCell(indexPath)
                    } else {
                        return getEnclosureCell(indexPath)
                    }
                } else { // 抄送人cell
                    return getCarbonCopyCell(indexPath)
                }
            } else { // 抄送
                return getCarbonCopyCell(indexPath)
            }
        } else {
            var model = data[section]
            if model.type == 8 {
                model = model.children[row]
            }
            switch model.type {
            case 1: // 1.文本
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyTextViewCell", for: indexPath) as! FillInApplyTextViewCell
                cell.data = (model.title ?? "", model.hint ?? "")
                cell.contentStr = seleStrArray[section][row]
                cell.isMust = model.isNecessary == 1
                cell.inputBlock = { [weak self] (contentStr) in
                    self?.seleStrArray[section][row] = contentStr
                    self?.confirmHandle()
                }
                return cell
            case 2: // 2.数字
                let cell = tableView.dequeueReusableCell(withIdentifier: "FillInApplyFieldViewCell", for: indexPath) as! FillInApplyFieldViewCell
                cell.data = (model.title ?? "", model.hint ?? "")
                cell.specialStr = seleStrArray[section][row]
                cell.isMust = model.isNecessary == 1
                cell.isSpecial = true
                cell.inputBlock = { [weak self] (contentStr) in
                    self?.seleStrArray[section][row] = contentStr
                    self?.confirmHandle()
                }
                return cell
            case 3, 4, 5, 6, 7: // 3.日期，4.单选，5.多选，6.客户，7.项目
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewlyBuildVisitSeleCell", for: indexPath) as! NewlyBuildVisitSeleCell
                cell.data = (model.title ?? "", model.hint ?? "")
                cell.contentStr = seleStrArray[section][row]
                cell.isMust = model.isNecessary == 1
                return cell
            default: return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var isUpdata = false
        if canUpload == 1 {
            let count = pricessType == 5 ? 2 : 0
            if section == data.count + count {
                isUpdata = true
            }
        }
        if ((section + 1) < data.count && data[section + 1].type == 8) || isUpdata {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
            footerView.backgroundColor = .clear
            _ = UILabel().taxi.adhere(toSuperView: footerView) //
                .taxi.layout(snapKitMaker: { (make) in
                    make.left.equalToSuperview().offset(15)
                    make.centerY.equalToSuperview()
                })
                .taxi.config({ (label) in
                    label.font = UIFont.regular(size: 12)
                    label.textColor = UIColor(hex: "#666666")
                    label.text = isUpdata ? "上传" : data[section + 1].title ?? ""
                })
            return footerView
        } else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
            footerView.backgroundColor = .clear
            return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var isUpdata = false
        if canUpload == 1 {
            let count = pricessType == 5 ? 2 : 0
            if section == data.count + count {
                isUpdata = true
            }
        }
        if ((section + 1) < data.count && data[section + 1].type == 8) || isUpdata {
            return 40
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let section = indexPath.section
        guard section < data.count else {
            return
        }
        var model = data[section]
        if model.type == 8 {
            model = model.children[row]
        }
        switch model.type {
        case 3: // 3.日期
            seleTimeHandle(indexPath: indexPath)
        case 4: // 4.单选
            singleSeleHandle(indexPath: indexPath)
        case 5: // 5.多选
            multipleSeleHandle(indexPath: indexPath)
        case 6: // 6.客户
            seleCustomerHandle(indexPath: indexPath)
        case 7: // 7.项目
            seleProjectHandle(indexPath: indexPath)
        default: break
        }
    }
}

extension FillInApplyController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let library = ALAssetsLibrary()
        library.writeImage(toSavedPhotosAlbum: image?.cgImage, orientation: ALAssetOrientation(rawValue: image?.imageOrientation.rawValue ?? 0)!) { (assetURL, error) in
            if error == nil {
                let result = PHAsset.fetchAssets(withALAssetURLs: [assetURL!], options: nil)
                self.imageArray.append(image!)
                self.PHAssetArray.append(result.firstObject!)
                self.reloadImageCell()
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension FillInApplyController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let canAccessingResource = url.startAccessingSecurityScopedResource()
        if canAccessingResource {
            var error: NSError!
            let fileCoordinator = NSFileCoordinator()
            fileCoordinator.coordinate(readingItemAt: url, options: .withoutChanges, error: &error) { (newURL) in
                do { // 不缓存，只获取data和名称
                    var fileName = url.lastPathComponent
                    let fileData = try Data(contentsOf: newURL)
                    fileName = initFileName(fileName)
                    self.fileArray.append((fileData, fileName))
                    self.reloadImageCell()
                } catch {
                    MBProgressHUD.showError("添加失败")
                }
            }
        }
        url.stopAccessingSecurityScopedResource()
    }
}
