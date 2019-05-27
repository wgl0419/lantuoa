//
//  WorkExtendListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/3.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  下级员工列表  数据模型

import UIKit
import HandyJSON

struct WorkExtendListModel: HandyJSON {
    var status: Int = 0
    var data = [WorkExtendListData]()
    var message: String?
    var errCode: Int = 0
}

struct WorkExtendListData: HandyJSON {
    var leaveTime: Int = 0
    var entryTime: Int = 0
    var carid: String?
    var deleted: Bool = false
    var pwd: String?
    var email: String?
    var used: Bool = false
    var loginTime: Int = 0
    var realname: String?
    var createdTime: Int = 0
    var status: Int = 0
    var id: Int = 0
    var phone: String?
    var remark: String?
    var projects: String?
    var departmentName: String?
    var allExtend: Int = 0
}
