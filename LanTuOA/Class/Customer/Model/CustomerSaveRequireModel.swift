//
//  CustomerSaveRequireModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  申请客户  数据模型

import UIKit
import HandyJSON

struct CustomerSaveRequireModel: HandyJSON {
    var status: Int = 0
    var data: CustomerListStatisticsData?
    var message: String?
    var errCode: Int = 0
}

