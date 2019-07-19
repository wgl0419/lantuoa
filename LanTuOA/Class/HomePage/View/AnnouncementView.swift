//
//  AnnouncementView.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import MBProgressHUD
class AnnouncementView: UIView {
    
    var data : AnnouncementListData? {
        didSet {
            if let data = data {
                titleLabel.text = data.title
                contentLabel.text = data.content
                userNameLabel.text = data.createdUserName
                if data.createdTime != 0 {
                    timeLabel.text = Date(timeIntervalSince1970: TimeInterval(data.createdTime)).yearTimeStr()
                }else{
                    timeLabel.text = "未设置"
                }
                collectionView.reloadData()
            }
        
        }
    }
    
//    var announcement_id :Int? {
//        didSet {
//            if let announcement_id = announcement_id {
//                _ = APIService.shared.getData(.AnnouncementDetails(announcement_id), t: AnnouncementModel.self, successHandle: { (result) in
//                    self.data = result.data[0]
//                }, errorHandle: nil)
//            }
//        }
//    }
    
//    ///公告数据
//    private var announcementData = [AnnouncementListData]()
    
    let backView = UIView()

    /// collectionview
    private var collectionView: UICollectionView!
    
    /// 确定按钮
    private var confirmBtn: UIButton!
    private var themeImage : UIImageView! ///上面图标
    private var titleLabel : UILabel! ///标题
    private var contentLabel : UILabel! ///主题
    private var userNameLabel : UILabel! ///名称
    private var timeLabel : UILabel! ///时间
    private var line : UIView!
    private var btnLine : UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(red: CGFloat(0 / 255.0), green: CGFloat(0 / 255.0), blue: CGFloat(0 / 255.0), alpha: 0.3 / 1.0)
        layer.masksToBounds = true
        backView.backgroundColor = UIColor.white
        addSubview(backView)
        backView.frame = CGRect(x: 40, y: (ScreenHeight-465)/2, width: ScreenWidth - 80, height:  465)
        backView.layer.cornerRadius = 5
        

        themeImage = UIImageView().taxi.adhere(toSuperView: self)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset((ScreenHeight-465)/2-66)
                make.leading.equalToSuperview().offset((ScreenWidth-132)/2)
                make.width.height.equalTo(132)
            })
            .taxi.config({ (image) in
                image.image = UIImage(named: "组 350")
            })

        
        titleLabel = UILabel().taxi.adhere(toSuperView: backView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(75)
                make.leading.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-15)
                make.height.equalTo(25)
            })
            .taxi.config({ (label) in
                label.textColor = kMainColor
                label.font = UIFont.medium(size: 18)
                label.text = "首页公告"
            })
        
        contentLabel = UILabel().taxi.adhere(toSuperView: backView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-15)
                make.height.equalTo(60).priority(800)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#666666")
                label.font = UIFont.regular(size: 14)
                label.numberOfLines = 0
                label.text = "需要弹窗公告的数组"
            })
        
        userNameLabel = UILabel().taxi.adhere(toSuperView: backView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-15)
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#222222")
                label.font = UIFont.regular(size: 14)
                label.textAlignment = .right
                label.text = "发布人：鲁智深"
            })
        
        timeLabel = UILabel().taxi.adhere(toSuperView: backView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(userNameLabel.snp.bottom).offset(5)
                make.leading.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-15)
                make.height.equalTo(20)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#999999")
                label.font = UIFont.regular(size: 12)
                label.textAlignment = .right
                label.text = "2019-07-19 10:30"
            })
        
        line = UIView().taxi.adhere(toSuperView: backView)
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(timeLabel.snp.bottom).offset(20)
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 110)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            .taxi.adhere(toSuperView: backView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalTo(line.snp.bottom).offset(20)
                make.bottom.equalToSuperview().offset(-65)
                make.right.equalToSuperview().offset(-15)
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (collectionView) in
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.register(AnnouncementCell.self, forCellWithReuseIdentifier: "AnnouncementCell")
            })
        btnLine = UIView().taxi.adhere(toSuperView: backView)
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(-45)
                make.height.equalTo(1)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#E5E5E5")
            })
        
        confirmBtn = UIButton().taxi.adhere(toSuperView: backView) // 确认按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(44)
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            })
            .taxi.config({ (btn) in
                btn.setTitle("知道了", for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 16)
                btn.addTarget(self, action: #selector(onClickSure), for: .touchUpInside)
            })
        
    }
    
    //MARK: 确定按钮
    @objc func onClickSure() {
        self.removeFromSuperview()
    }
    ///点击任意位置view消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.removeFromSuperview()
    }

}

extension AnnouncementView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (data?.files.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCell
        cell.data = data?.files[indexPath.item]
        cell.downloadButton.tag = indexPath.item
        cell.deleteBlock = { [weak self]  number in
            let photoBrowser = PhotoBrowser()
            var array = [(String, String)]()
            let objectName = self!.data!.files[number].objectName ?? ""
                let fileName = self!.data!.files[number].fileName ?? ""
                let path = "\(self!.data!.files[number].id)/" + fileName
                array.append((objectName, path))
            photoBrowser.images = array
            photoBrowser.currentIndex = indexPath.row
            photoBrowser.show()
            
//            let objectName = self!.data!.files[number].objectName ?? ""
//            let fileName = self!.data!.files[number].fileName ?? ""
//            let type = fileName.components(separatedBy: ".").last ?? ""
//            if type == "docx" || type == "png" || type == "jpg" || type == "jpeg" {
//                MBProgressHUD.showWait("")
//                let path =  fileName
//                AliOSSClient.shared.download(url: objectName, path: path, isCache: true) { (data) in
//                    DispatchQueue.main.async(execute: {
//                        if data != nil {
//                            if #available(iOS 9.0, *) {
//                                MBProgressHUD.dismiss()
//                                let vc = WebController()
//                                vc.enclosure = path
////                                self!.nextResponsder(currentView: self!).navigationController?.pushViewController(vc, animated: true)
//                                UIApplication.shared.keyWindow?.rootViewController?.navigationController?.pushViewController(vc, animated: true)
//                            } else {
//                                MBProgressHUD.showError("系统版本过低，无法预览")
//                            }
//                        } else {
//                            MBProgressHUD.showError("打开失败，请重试")
//                        }
//                    })
//                }
//            } else {
//                MBProgressHUD.showError("不支持浏览该类型文件")
//            }
 
            
        }
        return cell
    }
    
    func nextResponsder(currentView:UIView)->UIViewController{
        var vc:UIResponder = currentView
        while vc.isKind(of: UIViewController.self) != true {
            vc = vc.next!
        }
        return vc as! UIViewController

    }
    
}
