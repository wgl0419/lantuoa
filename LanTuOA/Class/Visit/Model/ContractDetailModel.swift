//
//  ContractDetailModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同详情  数据模型

import UIKit
import HandyJSON

struct ContractDetailModel: HandyJSON {
    var status: Int = 0
    var data: ContractListData?
    var message: String?
    var errCode: Int = 0
}
