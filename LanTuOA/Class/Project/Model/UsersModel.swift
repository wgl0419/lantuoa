//
//  UsersModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/1.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  用户列表 数据模型

import UIKit
import HandyJSON

struct UsersModel: HandyJSON {
    var status: Int = 0
    var data = [UsersData]()
    var message: String?
    var page: Int = 0
    var errCode: Int = 0
    var max_page: Int = 0
}

struct UsersRoleList: HandyJSON {
    var name: String?
    var remark: String?
    var type: String?
    var id: Int = 0
    var used: Bool = false
    var parentid: Int = 0
}

struct UsersData: HandyJSON {
    var leaveTime: Int = 0
    var entryTime: Int = 0
    var carid: String?
    var deleted: Bool = false
    var pwd: String?
    var email: String?
    var used: Bool = false
    var loginTime: Int = 0
    var roleList = [UsersRoleList]()
    var realname: String?
    var createdTime: Int = 0
    var status: Int = 0
    var id: Int = 0
    var phone: String?
    var remark: String?
    var projects: String?
}
