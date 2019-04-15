//
//  WorkExtendListPersonModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/3.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  员工工作列表   数据模型

import UIKit
import HandyJSON

struct WorkExtendListPersonModel: HandyJSON {
    var status: Int = 0
    var data = [WorkExtendListPersonData]()
    var message: String?
    var errCode: Int = 0
}

struct WorkExtendListPersonLastExtend: HandyJSON {
    var projectId: Int = 0
    var oldUser: Int = 0
    var visitId: Int = 0
    var newUser: Int = 0
    var newUserName: String?
    var operateUser: Int = 0
    var createdTime: Int = 0
    var isFirst: Int = 0
}

struct WorkExtendListPersonData: HandyJSON {
    var updatedTime: Int = 0
    var lastVisitTime: Int = 0
    var visitId: Int = 0
    var monthVisitUserNum: Int = 0
    var type: Int = 0
    var weekVisitUserNum: Int = 0
    var customerId: Int = 0
    var createdTime: Int = 0
    var lastVisitUser: Int = 0
    var manageUser: Int = 0
    var lastVisitUserName: String?
    var fullName: String?
    var id: Int = 0
    var lastExtend: WorkExtendListPersonLastExtend?
    var name: String?
    var deleted: Int = 0
    var createdUser: Int = 0
    var checkedUser: Int = 0
    var manageUserName: String?
    var address: String?
    var responseUserNum: Int = 0
    var checkedTime: Int = 0
    var updatedUser: Int = 0
    var lastVisitResult: String?
    var status: Int = 0
    var monthVisitNum: Int = 0
    var parentId: Int = 0
    var isLock: Int = 0
    var customerName: String?
    var weekVisitNum: Int = 0
}
