//
//  ContractDetailsHeaderView.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  顶部视图

import UIKit
import MBProgressHUD

class ContractDetailsHeaderView: UIView {

    /// 修改成功回调
    var editBlock: (() -> ())?
    /// 数据
    var data: ContractListData? {
        didSet {
            if let data = data {
                nameLabel.text = data.name
                numberLabel.text = "（合同编号：\(data.code ?? "")）"
                
                contributionLabel.text = data.rebate.getAllMoneyStr()
                totalLabel.text = data.totalMoney.getAllMoneyStr()
                moneyBackLabel.text = data.paybackMoney.getAllMoneyStr()
                productionLabel.text = data.makeMoney.getAllMoneyStr()
                
                // 时间
                let startTimeStr = Date(timeIntervalSince1970: TimeInterval(data.startTime)).customTimeStr(customStr: "yyyy-MM-dd")
                let endTimeStr = Date(timeIntervalSince1970: TimeInterval(data.endTime)).customTimeStr(customStr: "yyyy-MM-dd")
                timeLabel.text = startTimeStr + " 至 " + endTimeStr
                
                // 参与人
                var participateStr = ""
                for model in data.contractUsers {
                    participateStr.append("、\(model.realname ?? "")(\(model.propPerform)%)")
                }
                if participateStr.count > 0 { participateStr.remove(at: participateStr.startIndex) }
                participateLabel.text = participateStr.count == 0 ? " " : participateStr
                
                if data.signTime == 0 {
                    let signingTimeStr = Date(timeIntervalSince1970: TimeInterval(data.signTime)).customTimeStr(customStr: "yyyy-MM-dd")
                    signingTimeLabel.text = signingTimeStr
                } else {
                    signingTimeLabel.text = "未设置"
                }
            }
        }
    }
    
    /// 标题数组
    private let titleArray = ["实际发布时间：", "组稿费总额：", "合同总额：", "回款总额：", "制作费：", "参与人员：", "签约时间："]
    /// 内容控件数组
    private var contentLabelArray = [UILabel]()
    /// 合同名称
    private var nameLabel: UILabel!
    /// 编号
    private var numberLabel: UILabel!
    /// 时间
    private var timeLabel = UILabel()
    /// 稿费
    private var contributionLabel = UILabel()
    /// 总额
    private var totalLabel = UILabel()
    /// 回款
    private var moneyBackLabel = UILabel()
    /// 制作费
    private var productionLabel = UILabel()
    /// 参与人员
    private var participateLabel = UILabel()
    /// 签约时间
    private var signingTimeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 自定义私有方法
    private func initSubViews() {
        backgroundColor = .white
        
        nameLabel = UILabel().taxi.adhere(toSuperView: self) // 合同名称
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-70)
            })
            .taxi.config({ (label) in
                label.numberOfLines = 0
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 24)
            })
        
        _ = UIView().taxi.adhere(toSuperView: self) // 蓝色块
            .taxi.layout(snapKitMaker: { (make) in
                make.top.equalToSuperview().offset(25)
                make.left.equalToSuperview()
                make.height.equalTo(18)
                make.width.equalTo(2)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#2E4695")
            })
        
        numberLabel = UILabel().taxi.adhere(toSuperView: self) // 编号
            .taxi.layout(snapKitMaker: { (make) in
                make.left.equalToSuperview().offset(5)
                make.top.equalTo(nameLabel.snp.bottom)
            })
            .taxi.config({ (label) in
                label.textColor = UIColor(hex: "#2E4695")
                label.font = UIFont.boldSystemFont(ofSize: 16)
            })
        
        _ = UIButton().taxi.adhere(toSuperView: self) // 修改按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalTo(nameLabel)
                make.height.equalTo(20)
                make.width.equalTo(60)
            })
            .taxi.config({ (btn) in
                btn.setTitle(" 修改", for: .normal)
                btn.titleLabel?.font = UIFont.medium(size: 14)
                btn.setImage(UIImage(named: "edit"), for: .normal)
                btn.setTitleColor(UIColor(hex: "#6B83D1"), for: .normal)
                btn.addTarget(self, action: #selector(modifyClick), for: .touchUpInside)
            })
        
        
        contentLabelArray = [timeLabel, contributionLabel, totalLabel, moneyBackLabel, productionLabel, participateLabel, signingTimeLabel]
        for index in 0..<titleArray.count {
            let lastLabel: UILabel! = index == 0 ? numberLabel : contentLabelArray[index - 1]
            setTitle(titleStr: titleArray[index], contentLabel: contentLabelArray[index], lastLabel: lastLabel, isLast: index == titleArray.count - 1)
        }
        
        _ = UIView().taxi.adhere(toSuperView: self) // 灰色条
            .taxi.layout(snapKitMaker: { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(10)
            })
            .taxi.config({ (view) in
                view.backgroundColor = UIColor(hex: "#F3F3F3")
            })
    }
    
    /// 设置文本
    ///
    /// - Parameters:
    ///   - titleStr: 标题
    ///   - contentLabel: 内容控件
    ///   - lastLabel: 跟随的文本
    ///   - isLast: 是否是最后一行
    private func setTitle(titleStr: String, contentLabel: UILabel, lastLabel: UILabel, isLast: Bool) {
        let titleLabel = UILabel().taxi.adhere(toSuperView: self) // 标题
            .taxi.layout { (make) in
                make.top.equalTo(lastLabel.snp.bottom).offset(contentLabel == numberLabel ? 20 : 5)
                make.left.equalToSuperview().offset(15)
            }
            .taxi.config { (label) in
                label.text = titleStr
                label.font = UIFont.medium(size: 12)
                label.textColor = UIColor(hex: "#999999")
                label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        contentLabel.taxi.adhere(toSuperView: self) // 内容
            .taxi.layout { (make) in
                make.top.equalTo(titleLabel)
                make.left.equalTo(titleLabel.snp.right)
                make.right.equalToSuperview().offset(-23)
                if isLast {
                    make.bottom.equalToSuperview().offset(-25)
                }
            }
            .taxi.config { (label) in
                label.numberOfLines = 0
                label.textColor = blackColor
                label.font = UIFont.medium(size: 12)
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
    
    // MARK: - Api
    /// 修改合同内容
    private func contractUpdate(totalMoney: Float?, rebate: Float?, startTime: Int?, endTime: Int?, signTime: Int?) {
        MBProgressHUD.showWait("")
        _ = APIService.shared.getData(.contractUpdate(data?.id ?? 0, totalMoney, rebate, startTime, endTime, signTime), t: LoginModel.self, successHandle: { (result) in
            if self.editBlock != nil {
                self.editBlock!()
            }
            MBProgressHUD.dismiss()
        }, errorHandle: { (error) in
            MBProgressHUD.showError(error ?? "修改合同内容失败")
        })
    }
    
    // MARK: - 按钮点击
    /// 点击修改
    @objc private func modifyClick() {
        let view = SeleVisitModelView(title: "选择修改内容", content: ["实际发布时间", "组稿费总额", "合同总额", "签约时间"])
        view.didBlock = { [weak self] (seleIndex) in
            switch seleIndex {
            case 0:
                let showView = MoreTimeSeleEjectView()
                showView.seleBlock = { (start, end) in
                    self?.contractUpdate(totalMoney: nil, rebate: nil, startTime: start, endTime: end, signTime: nil)
                }
                showView.show()
            case 1:
                let showView = ContractMoneyEjectView()
                showView.data = ("修改组稿费", "组稿费（元）：")
                showView.seleBlock = { (money) in
                    self?.contractUpdate(totalMoney: nil, rebate: money, startTime: nil, endTime: nil, signTime: nil)
                }
                showView.show()
            case 2:
                let showView = ContractMoneyEjectView()
                showView.data = ("修改合同总额", "合同总额（元）：")
                showView.seleBlock = { (money) in
                    self?.contractUpdate(totalMoney: money, rebate: nil, startTime: nil, endTime: nil, signTime: nil)
                }
                showView.show()
            case 3:
                let ejectView = SeleTimeEjectView(timeStamp: nil, titleStr: "选择签约时间")
                ejectView.determineBlock = { [weak self] (timeStamp) in
                    self?.contractUpdate(totalMoney: nil, rebate: nil, startTime: nil, endTime: nil, signTime: timeStamp)
                }
                ejectView.show()
            default:
                break
            }
        }
        view.show()
    }
}
