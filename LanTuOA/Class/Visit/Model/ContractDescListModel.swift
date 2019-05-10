//
//  ContractDescListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同备注列表  数据模型

import UIKit
import HandyJSON

struct ContractDescListModel: HandyJSON {
    var status: Int = 0
    var data = [ContractDescListData]()
    var message: String?
    var errCode: Int = 0
}

struct ContractDescListData: HandyJSON {
    var desc: String?
    var createdUserName: String?
    var deleted: Int = 0
    var createdUser: Int = 0
    var id: Int = 0
    var updatedTime: Int = 0
    var updatedUserName: String?
    var contractId: Int = 0
    var updatedUser: Int = 0
    var createdTime: Int = 0
}
