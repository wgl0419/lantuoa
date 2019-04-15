//
//  CustomerDetailModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户详情  数据模型

import UIKit
import HandyJSON

struct CustomerDetailModel: HandyJSON {
    var status: Int = 0
    var data: CustomerListStatisticsData?
    var message: String?
    var errCode: Int = 0
}
