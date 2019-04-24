//
//  LoginUserModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  获取个人信息  数据模型

import UIKit
import HandyJSON

struct LoginUserModel: HandyJSON {
    var status: Int = 0
    var data: LoginUserData?
    var message: String?
    var errCode: Int = 0
}

struct LoginUserData: HandyJSON {
    var leaveTime: Int = 0
    var entryTime: Int = 0
    var pwd: String?
    var deleted: Bool = false
    var email: String?
    var platform: Int = 0
    var used: Bool = false
    var privilegeList = [UsersPermissionsData]()
    var carid: String?
    var loginTime: Int = 0
    var level: Int = 0
    var roleList = [LoginUserRoleList]()
    var realname: String?
    var createdTime: Int = 0
    var monthPerform: Int = 0
    var status: Int = 0
    var registrationId: String?
    var id: Int = 0
    var phone: String?
    var remark: String?
    var departmentName: String?
    var projects: String?
}

struct LoginUserRoleList: HandyJSON {
    var name: String?
    var id: Int = 0
    var parentid: Int = 0
    var used: Bool = false
    var remark: String?
    var level: Int = 0
    var type: String?
}
