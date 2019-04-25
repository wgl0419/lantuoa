//
//  StartupSumModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/25.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  首页统计  数据模型

import UIKit
import HandyJSON

struct StartupSumModel: HandyJSON {
    var status: Int = 0
    var data: StartupSumData?
    var message: String?
    var errCode: Int = 0
}

struct StartupSumData: HandyJSON {
    var monthVisitNum: Int = 0
    var monthMoney: Float = 0
    var monthPerform: Float = 0
    var monthContract: Int = 0
}
