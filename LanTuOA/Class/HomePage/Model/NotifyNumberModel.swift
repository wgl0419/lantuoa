//
//  NotifyNumberModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/26.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  未读信息数量   数据模型

import UIKit
import HandyJSON

struct NotifyNumberModel: HandyJSON {
    var status: Int = 0
    var data: NotifyNumberData?
    var message: String?
    var errCode: Int = 0
}

struct NotifyNumberData: HandyJSON {
    var notReadNum: Int = 0
    var checkNum: Int = 0
}
