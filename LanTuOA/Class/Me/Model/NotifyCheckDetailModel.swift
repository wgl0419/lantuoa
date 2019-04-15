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
    var data: NotifyCheckDetailData?
    var message: String?
    var errCode: Int = 0
}

struct NotifyCheckDetailData: HandyJSON {
    var projectId: Int = 0
    var data = [NotifyCheckDetailSmallData]()
    var createdUser: Int = 0
    var checkLength: Int = 0
    var step: Int = 0
    var checkedTime: Int = 0
    var processName: String?
    var customerId: Int = 0
    var createdTime: Int = 0
    var status: Int = 0
    var groupId: Int = 0
    var createdUserName: String?
    var id: Int = 0
    var processId: Int = 0
    var params: String?
    var rejectComment: String?
    var contractId: Int = 0
    var paramsLength: Int = 0
    var title: String?
    var processType: Int = 0
}

struct NotifyCheckDetailSmallData: HandyJSON {
    var name: String?
    var value: String?
    var title: String?
    var type: Int = 0
    var sort: Int = 0
}
