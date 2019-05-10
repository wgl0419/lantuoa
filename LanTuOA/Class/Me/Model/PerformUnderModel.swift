//
//  PerformUnderModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  绩效查询 -> 绩效列表    数据模型

import UIKit
import HandyJSON

struct PerformUnderModel: HandyJSON {
    var status: Int = 0
    var data = [PerformUnderData]()
    var message: String?
    var errCode: Int = 0
}

struct PerformUnderData: HandyJSON {
    var pwd: String?
    var deleted: Bool = false
    var email: String?
    var carid: String?
    var used: Bool = false
    var level: Int = 0
    var realname: String?
    var monthPerform: Float = 0
    var status: Int = 0
    var id: Int = 0
    var phone: String?
    var remark: String?
    var departmentName: String?
    var projects: String?
}
