//
//  ContractTypeListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同类型  数据模型

import UIKit
import HandyJSON

struct ContractTypeListModel: HandyJSON {
    var status: Int = 0
    var data = [ContractTypeListData]()
    var message: String?
    var errCode: Int = 0
}

struct ContractTypeListData: HandyJSON {
    var id: Int = 0
    var name: String?
}
