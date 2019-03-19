//
//  ProjectListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import HandyJSON

struct ProjectListModel: HandyJSON {
    var status: Int = 0
    var data = [ProjectListData]()
    var message: String?
    var errCode: Int = 0
}

struct ProjectListData: HandyJSON {
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
    var id: Int = 0
    var name: String?
    var checkedUser: Int = 0
    var deleted: Int = 0
    var createdUser: Int = 0
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

