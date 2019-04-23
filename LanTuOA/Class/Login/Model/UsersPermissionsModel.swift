//
//  UsersPermissionsModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/23.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  个人权限  数据模型

import UIKit
import HandyJSON

struct UsersPermissionsModel: HandyJSON {
    var status: Int = 0
    var data = [UsersPermissionsData]()
    var message: String?
    var errCode: Int = 0
}

struct UsersPermissionsData: HandyJSON {
    var parentId: Int = 0
    var name: String?
    var orderNum: Int = 0
    var id: Int = 0
    var used: Bool = false
    var remark: String?
    var level: Int = 0
    var url: String?
}
