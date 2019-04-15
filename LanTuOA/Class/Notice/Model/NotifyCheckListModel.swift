//
//  NotifyCheckListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/3.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审核列表 数据模型

import UIKit
import HandyJSON

struct NotifyCheckListModel: HandyJSON {
    var status: Int = 0
    var data = [NotifyCheckListData]()
    var message: String?
    var errCode: Int = 0
}

struct NotifyCheckListSmallData: HandyJSON {
    var name: String?
    var value: String?
    var title: String?
    var type: Int = 0
    var sort: Int = 0
}

struct NotifyCheckListData: HandyJSON {
    var projectId: Int = 0
    var data = [NotifyCheckListSmallData]()
    var checkLength: Int = 0
    var createdUser: Int = 0
    var processName: String?
    var checkedTime: Int = 0
    var totalMoney: Int = 0
    var createdTime: Int = 0
    var customerId: Int = 0
    var step: Int = 0
    var status: Int = 0
    var createdUserName: String?
    var id: Int = 0
    var processId: Int = 0
    var params: String?
    var rejectComment: String?
    var title: String?
    var paramsLength: Int = 0
    var processType: Int = 0
}
