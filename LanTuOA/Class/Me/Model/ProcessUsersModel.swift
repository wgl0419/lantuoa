//
//  ProcessUsersModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/19.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  流程默认审批/抄送人   数据模型

import UIKit
import HandyJSON

struct ProcessUsersModel: HandyJSON {
    var status: Int = 0
    var data: ProcessUsersData?
    var message: String?
    var errCode: Int = 0
}

struct ProcessUsersData: HandyJSON {
    var ccUsers = [ProcessUsersCheckUsers]()
    var checkUsers = [ProcessUsersCheckUsers]()
}

struct ProcessUsersCheckUsers: HandyJSON {
    var roleName: String?
    var processId: Int = 0
    var sort: Int = 0
    var checkType: Int = 0
    var checkUserType: Int = 0
    var realname: String?
    var checkUserId: Int = 0
}
