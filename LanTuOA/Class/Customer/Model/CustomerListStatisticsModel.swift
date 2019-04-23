//
//  CustomerListStatisticsModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户统计信息列表  数据模型

import UIKit
import HandyJSON

struct CustomerListStatisticsModel: HandyJSON {
    var status: Int = 0
    var data = [CustomerListStatisticsData]()
    var message: String?
    var page: Int = 0
    var errCode: Int = 0
    var max_page: Int = 0
}

struct CustomerListStatisticsData: HandyJSON {
    var name: String?
    var onlineProjectNum: Int = 0
    var noLockProjectNum: Int = 0
    var deleted: Int = 0
    var visitId: Int = 0
    var createdUser: Int = 0
    var lastVisitTime: Int = 0
    var address: String?
    var monthVisitUserNum: Int = 0
    var type: Int = 0
    var weekVisitUserNum: Int = 0
    var createdTime: Int = 0
    var lastVisitUserName: String?
    var lastVisitResult: String?
    var monthVisitNum: Int = 0
    var lockedProjectNum: Int = 0
    var lastVisitUser: Int = 0
    var id: Int = 0
    var industry: Int = 0
    var industryName: String?
    var fullName: String?
    var weekVisitNum: Int = 0
    var canManage: Int = 0
}
