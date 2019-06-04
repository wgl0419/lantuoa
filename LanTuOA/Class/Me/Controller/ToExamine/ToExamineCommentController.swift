//
//  ToExamineCommentController.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批详情  评论  控制器

import UIKit
import YYText
import MBProgressHUD
import AssetsLibrary
import ZLPhotoBrowser

class ToExamineCommentController: UIViewController {
    
    /// 备注
    enum DescType {
        /// 同意
        case agree
        /// 拒绝
        case refuse
        /// 审批评论
        case approval
        /// 拜访评论
        case visit
    }
    
    /// 审批id
    var checkListId = 0
    /// 评论回调
    var commentBlock: (() -> ())?
    /// 备注类型
    var descType: DescType = .agree

    /// 输入框
    private var textView: YYTextView!
    /// 图片
    private var collectionView: UICollectionView!
    
    /// 数据
    private var data = [Any]()
    /// 图片信息数据
    private var PHAssetArray: Array<PHAsset> = []
    /// 上传文件id
    private var uploadFileIds = [Int]()
    /// 上传图片id
    private var uploadImageIds = [Int]()
    /// 原图选项
    private var isOriginal = false
    /// 已选@数据
    private var seleIds = [UsersData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        view.backgroundColor = .white
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮视图
            .taxi.layout { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : 0)
        }
            .taxi.config { (view) in
                view.backgroundColor = .white
        }
        
        _ = UIButton().taxi.adhere(toSuperView: btnView) // 提交按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.bottom.equalToSuperview().offset(-15)
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.backgroundColor = UIColor(hex: "#2E4695")
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                btn.addTarget(self, action: #selector(submissionClick), for: .touchUpInside)
                btn.setTitle(descType == .agree ? "确认同意" : descType == .refuse ? "确认拒绝" : "提交", for: .normal)
            })
        
        _ = UIView().taxi.adhere(toSuperView: btnView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(1)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-80)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        let relationBtn = UIButton().taxi.adhere(toSuperView: btnView) // 关联 -> @
            .taxi.layout { (make) in
                make.bottom.equalToSuperview().offset(-80)
                make.left.equalToSuperview().offset(10)
                make.width.height.equalTo(50)
        }
            .taxi.config { (btn) in
                btn.setImage(UIImage(named: "relation"), for: .normal)
                btn.addTarget(self, action: #selector(relationClick), for: .touchUpInside)
        }
        
        let imageBtn = UIButton().taxi.adhere(toSuperView: btnView) // 图片
            .taxi.layout { (make) in
                make.left.equalTo(relationBtn.snp.right).offset(5)
                make.bottom.width.height.equalTo(relationBtn)
        }
            .taxi.config { (btn) in
                btn.setImage(UIImage(named: "image"), for: .normal)
                btn.addTarget(self, action: #selector(imageClick), for: .touchUpInside)
        }
        
        _ = UIButton().taxi.adhere(toSuperView: btnView) // 附件
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(imageBtn.snp.right).offset(5)
                make.bottom.width.height.equalTo(relationBtn)
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "enclosure"), for: .normal)
                btn.addTarget(self, action: #selector(enclosureClick), for: .touchUpInside)
            })
        
        _ = UIView().taxi.adhere(toSuperView: btnView) // 灰色块
            .taxi.layout(snapKitMaker: { (make) in
                make.bottom.equalTo(relationBtn.snp.top)
                make.left.right.top.equalToSuperview()
                make.height.equalTo(10)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 97, height: 97)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // 图片
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(97)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalTo(btnView.snp.top).offset(-10)
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.register(ToExamineCommentCollectionCell.self, forCellWithReuseIdentifier: "ToExamineCommentCollectionCell")
            })
        
        let top = UITextView().textContainerInset.top
        let lineFragmentPadding = UITextView().textContainer.lineFragmentPadding
        
        textView = YYTextView().taxi.adhere(toSuperView: view) // 输入框
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15 + lineFragmentPadding)
                make.left.equalToSuperview().offset(15 - lineFragmentPadding)
                make.bottom.equalTo(collectionView.snp.top).offset(-10)
                make.top.equalToSuperview().offset(15 - top)
            })
            .taxi.config({ (textView) in
                textView.delegate = self
                textView.inputAccessoryView = initInputView()
                textView.textParser = LPPZSendContentTextParser()
                textView.font = UIFont.systemFont(ofSize: 16)
                textView.placeholderText = "请输入评论"
            })
    }
    
    /// 生成inputView
    private func initInputView() -> UIView {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 44))
        inputView.backgroundColor = .white
        
        _ = UIView().taxi.adhere(toSuperView: inputView) // 分割线
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E0E0E0", alpha: 0.55)
            })
        
        let relationBtn = UIButton().taxi.adhere(toSuperView: inputView) // 关联 -> @
            .taxi.layout { (make) in
                make.left.equalToSuperview().offset(10)
                make.width.height.equalTo(44)
                make.bottom.equalToSuperview()
            }
            .taxi.config { (btn) in
                btn.setImage(UIImage(named: "relation"), for: .normal)
                btn.addTarget(self, action: #selector(relationClick), for: .touchUpInside)
        }
        
        let imageBtn = UIButton().taxi.adhere(toSuperView: inputView) // 图片
            .taxi.layout { (make) in
                make.left.equalTo(relationBtn.snp.right).offset(5)
                make.bottom.width.height.equalTo(relationBtn)
            }
            .taxi.config { (btn) in
                btn.setImage(UIImage(named: "image"), for: .normal)
                btn.addTarget(self, action: #selector(imageClick), for: .touchUpInside)
        }
        
        _ = UIButton().taxi.adhere(toSuperView: inputView) // 附件
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalTo(imageBtn.snp.right).offset(5)
                make.bottom.width.height.equalTo(relationBtn)
            })
            .taxi.config({ (btn) in
                btn.setImage(UIImage(named: "enclosure"), for: .normal)
                btn.addTarget(self, action: #selector(enclosureClick), for: .touchUpInside)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: inputView)
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle("完成", for: .normal)
                btn.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
                btn.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
            })
        
        return inputView
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
    
    /// 相册修改图片
    private func changeImage(indexPath: Int = -1) {
        let photoSheet = ZLPhotoActionSheet()
        photoSheet.sender = self
        photoSheet.configuration.allowEditImage = false
        photoSheet.selectImageBlock = { [weak self] images, assets, isOriginal in
            if indexPath < 0 { // 添加图片
                for index in 0..<images!.count {
                    self?.data.append((images![index], assets[index]))
                }
            } else { // 浏览
                if images!.count == 0 {
                     self?.data.remove(at: indexPath)
                }
            }
            self?.isOriginal = isOriginal
            self?.collectionView.reloadData()
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
            let model = data[indexPath] as! (UIImage, PHAsset)
            photoSheet.previewSelectedPhotos([model.0], assets: [model.1], index: 0, isOriginal: isOriginal)
        }
    }
    
    /// 添加人员处理
    private func addPersion(users: [UsersData]) {
        for model in users {
            let str = "@\(model.realname ?? ""){{\(model.id)}}"
            textView.replace(textView.selectedTextRange!, withText: str)
        }
    }
    
    /// 确认数据
    private func confirmData(image: [Int], file: [Int], str: String) {
        if descType == .agree {
            notifyCheckAgree(image: image, file: file, str: str)
        } else if descType == .refuse {
            notifyCheckReject(image: image, file: file, str: str)
        } else if descType == .approval {
            notifyCheckCommentCreate(image: image, file: file, str: str)
        } else {
            visitCommentCreate(image: image, file: file, str: str)
        }
    }
    
    /// 生成文件名称
    private func initFileName(_ name: String) -> String {
        let fileName = name.components(separatedBy: ".").first ?? ""
        let type = name.components(separatedBy: ".").last ?? ""
        let similarName = data.filter { (model) -> Bool in
            if model is (Data, String) {
                let fileModel = model as! (Data, String)
                return fileModel.1.contains(fileName)
            } else {
                return false
            }
        }
        if similarName.count > 0 {
            let lastSimilar = similarName.last as! (Data, String)
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
            self?.data.append((fileData, fileName))
            self?.collectionView.reloadData()
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
    /// 审批评论
    private func notifyCheckCommentCreate(image: [Int], file: [Int], str: String) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckCommentCreate(checkListId, image, file, str), t: LoginModel.self, successHandle: { (result) in
            if self.commentBlock != nil {
                self.commentBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "评论失败")
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
    
    /// 拒绝审批-非创建客户/项目
    private func notifyCheckReject(image: [Int], file: [Int], str: String) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckReject(checkListId, image, file, str), t: LoginModel.self, successHandle: { (result) in
            if self.commentBlock != nil {
                self.commentBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "拒绝失败")
        })
    }
    
    /// 同意审批
    private func notifyCheckAgree(image: [Int], file: [Int], str: String) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.notifyCheckAgree(checkListId, image, file, str), t: LoginModel.self, successHandle: { (result) in
            if self.commentBlock != nil {
                self.commentBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }
    
    /// 评论拜访
    private func visitCommentCreate(image: [Int], file: [Int], str: String) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.visitCommentCreate(checkListId, image, file, str), t: LoginModel.self, successHandle: { (result) in
            if self.commentBlock != nil {
                self.commentBlock!()
            }
            MBProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "同意失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击提交
    @objc private func submissionClick() {
        var contentStr = ""
        if let attributedText = textView.attributedText {
            attributedText.enumerateAttribute(NSAttributedString.Key(rawValue: YYTextAttachmentAttributeName), in: NSMakeRange(0, textView.attributedText?.string.count ?? 0), options: NSAttributedString.EnumerationOptions.init(rawValue: 0), using: { (value, range, stop) in
                if value is YYTextAttachment {
                    let attachMent: YYTextAttachment  = value as! YYTextAttachment
                    if attachMent.userInfo != nil {
                        let idStr: String = attachMent.userInfo!["userID"] as! String
                        var nameStr: String = attachMent.userInfo!["userName"] as! String
                        nameStr.removeLast()
                        contentStr.append("\(nameStr){{\(idStr)}} ")
                    }
                } else {
                    let nsStr = attributedText.string as NSString
                    let str = nsStr.substring(with: range)
                    contentStr.append(str)
                }
            })
        }
        uploadFileIds = [Int]()
        uploadImageIds = [Int]()
        if data.count == 0 {
            confirmData(image: uploadImageIds, file: uploadFileIds, str: contentStr)
        } else {
            uploadGetKey(contentStr: contentStr)
        }
    }
    /// 上传文件
    private func uploadGetKey(contentStr: String) {
        for index in 0..<data.count {
            var size = 0
            var type: Int!
            var name: String!
            var uploadData: Data!
            let model = data[index]
            if model is (UIImage, PHAsset) {
                type = 1
                name = "".randomStringWithLength(len: 8) + ".png"
                let imageData = model as! (UIImage, PHAsset)
                uploadData = imageData.0.jpegData(compressionQuality: 0.5) ?? Data()
            } else {
                type = 2
                let fileData = model as! (Data, String)
                name = fileData.1
                uploadData = fileData.0
                size = fileData.0.count
            }
            fileUploadGetKey(type: type, name: name, size: size) { (status, body, path) in
                if status {
                    self.uploadData(uploadData, name: path ?? "", body: body!, type: type, isLast: index == self.data.count - 1, contentStr: contentStr)
                }
            }
        }
    }
    
    /// 上传数据
    private func uploadData(_ data: Data, name: String, body: Int, type: Int, isLast: Bool, contentStr: String) {
        AliOSSClient.shared.uploadData(data, name: name, body: body) { (status) in
            if status {
                if type == 1 {
                    self.uploadImageIds.append(body)
                } else {
                    self.uploadFileIds.append(body)
                }
                if isLast {
                    DispatchQueue.main.async(execute: {
                        if self.uploadFileIds.count + self.uploadImageIds.count == self.data.count {
                            self.confirmData(image: self.uploadImageIds, file: self.uploadFileIds, str: contentStr)
                        } else {
                            MBProgressHUD.showError("上传失败")
                        }
                    })
                }
            }
        }
    }
    
    /// 点击关联他人 @
    @objc private func relationClick() {
        let vc = SelePersonnelController()
        vc.isMultiple = true
        vc.displayData = ("请选择", "确定", .back)
        vc.backBlock = { [weak self] (users) in
            self?.addPersion(users: users)
        }
        navigationController?.pushViewController(vc, animated: true)
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
    
    /// 点击添加附件
    @objc private func enclosureClick() {
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
    
    /// 点击隐藏键盘
    @objc private func doneClick() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}

extension ToExamineCommentController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToExamineCommentCollectionCell", for: indexPath) as! ToExamineCommentCollectionCell
        let model = data[indexPath.row]
        if model is (Data, String) {
            cell.fileData = model as? (Data, String)
        } else {
            let imageModel = model as? (UIImage, PHAsset)
            cell.imageData = imageModel?.0
        }
        cell.deleteBlock = { [weak self] in
            self?.data.remove(at: indexPath.row)
            collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = data[indexPath.row]
        if model is (Data, String) {
            MBProgressHUD.showError("不支持预览")
        } else {
            changeImage(indexPath: indexPath.row)
        }
    }
}


extension ToExamineCommentController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let library = ALAssetsLibrary()
        library.writeImage(toSavedPhotosAlbum: image?.cgImage, orientation: ALAssetOrientation(rawValue: image?.imageOrientation.rawValue ?? 0)!) { (assetURL, error) in
            if error == nil {
                let result = PHAsset.fetchAssets(withALAssetURLs: [assetURL!], options: nil)
                self.data.append((image!, result.firstObject!))
                self.collectionView.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension ToExamineCommentController: YYTextViewDelegate {
    
}

extension ToExamineCommentController: UIDocumentPickerDelegate {
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
                    self.data.append((fileData, fileName))
                    self.collectionView.reloadData()
                } catch {
                    MBProgressHUD.showError("添加失败")
                }
            }
        }
        url.stopAccessingSecurityScopedResource()
    }
}
