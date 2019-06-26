//
//  CheckReportListView.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CheckReportListView: UIView {
    
    var chooseBtn: UIButton!
    private var readLabel: UILabel!
    private var isSeced: Int = 0
    var readBlck: ((Int) -> Void)?
    var data :unreadValueModel?{
        didSet {
            if let data = data{
                readLabel.text = "只看未读(\(data.status))"

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initSubViews(){
        frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 30)
        chooseBtn = UIButton().taxi.adhere(toSuperView: self)
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(7)
                make.width.height.equalTo(15)
            })
            .taxi.config({ (button) in

                button.setImage(UIImage(named: "order_icon_check"), for: .selected)
                button.setImage(UIImage(named: "unsele"), for: .normal)
                button.addTarget(self, action: #selector(chooseAction), for: .touchUpInside)
                button.layer.cornerRadius = 7.5
                button.layer.masksToBounds = true
                
            })
        readLabel = UILabel().taxi.adhere(toSuperView: self)
            .taxi.layout(snapKitMaker: { (make) in
                make.leading.equalTo(chooseBtn.snp.trailing).offset(5)
                make.top.bottom.trailing.equalToSuperview()
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#666666")
                label.font = UIFont.medium(size: 12)
            })
        
        if isSeced == 0 {
            chooseBtn.isSelected = false
        }else{
            chooseBtn.isSelected = true
        }
    }
    
    @objc func chooseAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            if readBlck != nil {
                readBlck!(1)
                isSeced = 1
            }
        }else{
            if readBlck != nil {
                readBlck!(0)
                isSeced = 0
            }
        }
    }
    
}
