//
//  PerformDetailModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  查询绩效-详情-月份绩效   数据模型

import UIKit
import HandyJSON

struct PerformDetailModel: HandyJSON {
    var status: Int = 0
    var data = [PerformDetailData]()
    var message: String?
    var errCode: Int = 0
}

struct PerformDetailData: HandyJSON {
    var effectDays: Int = 0
    var title: String?
    var performDay: Int = 0
    var money: Float = 0
    var days: Int = 0
}
