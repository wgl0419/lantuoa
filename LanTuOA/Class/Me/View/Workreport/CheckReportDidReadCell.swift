//
//  CheckReportDidReadCell.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CheckReportDidReadCell: UITableViewCell {

    var titleLabel: UILabel!
    var rightImage: UIImageView!
    var rightBtn: UIButton!
    var readBlck: ((Int) -> Void)?
    private var isSeced: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews(){
        
        titleLabel = UILabel().taxi.adhere(toSuperView: contentView) // 标题
        titleLabel.taxi.layout { (make) in
            make.top.left.equalTo(contentView).offset(15)
            make.right.equalTo(ScreenWidth/2)
            }
            .taxi.config { (label) in
                label.textColor = blackColor
                label.font = UIFont.medium(size: 16)
        }
        
        rightBtn = UIButton().taxi.adhere(toSuperView: contentView)
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-5)
                make.top.equalToSuperview().offset(5)
                make.height.equalTo(40)
                make.width.equalTo(50)
            })
            .taxi.config({ (button) in
                button.setImage(UIImage(named: "unsele"), for: .normal)
                button.setImage(UIImage(named: "sele"), for: .selected)
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

            })
        
        if isSeced == 0 {
            rightBtn.isSelected = false
        }else{
            rightBtn.isSelected = true
        }
        
    }
    
    //MARK:btn点击
    @objc func buttonAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
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

