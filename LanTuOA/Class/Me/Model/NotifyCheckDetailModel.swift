//
//  NotifyCheckDetailModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/15.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批详情  数据模型

import UIKit
import HandyJSON

struct NotifyCheckDetailModel: HandyJSON {
    var status: Int = 0
    var data: NotifyCheckListData?
    var message: String?
    var errCode: Int = 0
}
