//
//  NewAchievementsHeadView.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class NewAchievementsHeadView: UIView {
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day ,.hour,.minute],   from: Date())
    var dateBtn: UIButton!
    var totalLabel: UILabel!
    var dateLabel:UILabel!
    /// 搜索框
    private var searchBar: UISearchBar!
    private var inputCout = 0
    var backDate: ((Int,String,String) -> Void)?
    var searchBlck: ((String,Int) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    var data :NewPerformUnderModel? {
        didSet {
            if let data = data {
                let arrData = data.data
                var tota : Int = 0
                for index in 0..<arrData.count {
                    let model = arrData[index]
                    tota  = tota + model.totalValue
                }
                totalLabel.text = "合计：\(tota)元"
            }
        }
    }
    var placeholder: String? {
        didSet {
           searchBar.placeholder = placeholder
        }
    }
    
    var timeDate: String? {
        didSet {
            dateLabel.text = timeDate
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews(){
        frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 120)
        backgroundColor = kMainBackColor
        dateBtn = UIButton().taxi.adhere(toSuperView: self)
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.width.equalTo(ScreenWidth/2-15)
                make.height.equalTo(35)
            })
        dateBtn.addTarget(self, action: #selector(dateAction), for: .touchUpInside)
        dateLabel = UILabel().taxi.adhere(toSuperView: dateBtn)
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.equalToSuperview()
                make.top.equalTo(dateBtn.snp.top).offset(10)
                make.bottom.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.font = UIFont.regular(size: 16)
                label.textColor = UIColor(hex: "#515458")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
//        let dateString = String(format: "%02ld", self.currentDateCom.year! )
//        let moth = String(format:"%02ld",self.currentDateCom.month!)
//        dateLabel.text = "\(dateString)年-\(moth)月"
//        let img = UIImageView().taxi.adhere(toSuperView: dateBtn)
//            .taxi.layout { (make) in
//                make.leading.equalTo(dateLabel.snp.right)
//                make.top.equalTo(dateLabel.snp.top)
//                make.width.equalTo(8)
//                make.height.equalTo(4)
//        }
//            .taxi.config { (image) in
//                image.image = UIImage(named: "")
//        }
        totalLabel = UILabel().taxi.adhere(toSuperView: self)
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.top.equalTo(dateBtn.snp.bottom).offset(5)
                make.height.equalTo(14)
            })
            .taxi.config({ (label) in
                label.font = UIFont.medium(size: 14)
                label.textColor = UIColor(hex: "#B1B4BB")
                label.text = "合计：0.00元"
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            })
        
        let barView = UIView().taxi.adhere(toSuperView: self) // bar背景view
            .taxi.layout { (make) in
                make.top.equalTo(totalLabel.snp.bottom).offset(5)
                make.leading.equalTo(self)
                make.trailing.equalTo(self)
                make.height.equalTo(50)
                
            }
            .taxi.config { (view) in
                view.backgroundColor = kMainBackColor
//                view.backgroundColor = .white
        }
        
        searchBar = UISearchBar().taxi.adhere(toSuperView: barView)
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(5)
                make.left.equalTo(barView).offset(10)
                make.right.equalTo(barView).offset(-5)
                make.bottom.equalToSuperview().offset(-5)
            })
            .taxi.config({ (searchBar) in
                searchBar.sizeToFit()
                searchBar.delegate = self
                searchBar.backgroundColor = .clear
                searchBar.searchBarStyle = .minimal
                searchBar.returnKeyType = .done
            })

    }
    
    @objc func dateAction(){
        let dataPicker = DateView()
        dataPicker.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        //         回调显示方法
        dataPicker.backDate = { [weak self] date, moth in
            self!.dateLabel.text = "\(date)年-\(moth)月"
//            let datexx = String(format: "%02ld%02ld", date, moth)
            if self!.backDate != nil{
                self!.backDate!(Int(date + moth)!,date,moth)
            }
        }
        UIApplication.shared.delegate?.window??.addSubview(dataPicker)
    }
    
    /// 区分出搜索的内容
    ///
    /// - Parameter number: 记录的输入次数
    @objc private func distinguishSearch(number: NSNumber) {
        if Int(truncating: number) == inputCout { // 次数相同 说明停止输入
            if searchBar.text == "" {
                if self.searchBlck != nil{
                    self.searchBlck!("",1)
                }
            }else{
                if self.searchBlck != nil{
                    self.searchBlck!(searchBar.text!,0)
                }
            }
        }
    }
    
}

extension NewAchievementsHeadView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputCout += 1
        let count = NSNumber(value: inputCout)
        self.perform(#selector(distinguishSearch(number:)), with: count, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
