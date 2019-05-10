//
//  ContractPaybackListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同列表  数据结构

import UIKit
import HandyJSON

struct ContractPaybackListModel: HandyJSON {
    var status: Int = 0
    var data = [ContractPaybackListData]()
    var message: String?
    var errCode: Int = 0
}

struct ContractPaybackListData: HandyJSON {
    var payTime: Int = 0
    var desc: String?
    var id: Int = 0
    var money: Float = 0
    var contractId: Int = 0
    var status: Int = 0
}
