//
//  CustomerMembersModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户跟进人 数据模型

import UIKit
import HandyJSON

struct CustomerMembersModel: HandyJSON {
    var status: Int = 0
    var data = [CustomerMembersData]()
    var message: String?
    var errCode: Int = 0
}

struct CustomerMembersData: HandyJSON {
    var platform: Int = 0
    var used: Bool = false
    var level: Int = 0
    var registrationId: String?
    var monthPerform: Int = 0
    var id: Int = 0
    var phone: String?
    var departmentName: String?
    var pwd: String?
    var deleted: Bool = false
    var email: String?
    var carid: String?
    var realname: String?
    var roleName: String?
    var status: Int = 0
    var originName: String?
    var remark: String?
    var projects: String?
    var visitTime: Int = 0
}
