//
//  DepartmentsUsersModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/10.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  部门成员  数据模型

import UIKit
import HandyJSON

struct DepartmentsUsersModel: HandyJSON {
    var status: Int = 0
    var data = [DepartmentsUsersData]()
    var message: String?
    var errCode: Int = 0
}

struct DepartmentsUsersData: HandyJSON {
    var entryTime: Int = 0
    var carid: String?
    var deleted: Bool = false
    var pwd: String?
    var email: String?
    var used: Bool = false
    var departmentUserTypeName: String?
    var realname: String?
    var createdTime: Int = 0
    var status: Int = 0
    var id: Int = 0
    var phone: String?
    var remark: String?
    var departmentUserTypeId: Int = 0
}
