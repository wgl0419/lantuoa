//
//  NotifyCheckUserListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审批人列表  数据模型

import UIKit
import HandyJSON

struct NotifyCheckUserListModel: HandyJSON {
    var status: Int = 0
    var data = [NotifyCheckUserListData]()
    var message: String?
    var errCode: Int = 0
}

struct NotifyCheckUserListData: HandyJSON {
    var checkUserName: String?
    var status: Int = 0
    var desc: String?
    var sort: Int = 0
    var checkUser: Int = 0
    var checkId: Int = 0
    var checkedTime: Int = 0
    var type: Int = 0
    var `self`: Int = 0
    var files = [NotifyCheckListValue]()
}
