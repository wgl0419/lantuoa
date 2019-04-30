//
//  ProcessHistoryModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  历史申请列表  数据结构

import UIKit
import HandyJSON

struct ProcessHistoryModel: HandyJSON {
    var status: Int = 0
    var data = [ProcessHistoryData]()
    var message: String?
    var errCode: Int = 0
}

struct ProcessHistoryData: HandyJSON {
    var check_users: String?
    var status: Int = 0
    var content: String?
    var created_time: Int = 0
    var id: Int = 0
    var name: String?
    var processName: String?
}
