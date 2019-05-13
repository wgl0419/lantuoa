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
    var updatedTime: Int = 0
    var noLockProjectNum: Int = 0
    var lastVisitTime: Int = 0
    var visitId: Int = 0
    var projectNum: Int = 0
    var monthRebate: Float = 0
    var monthVisitUserNum: Int = 0
    var type: Int = 0
    var weekVisitUserNum: Int = 0
    var createdTime: Int = 0
    var lastVisitUserName: String?
    var lastVisitUser: Int = 0
    var industry: Int = 0
    var fullName: String?
    var id: Int = 0
    var monthMoney: Float = 0
    var projectNames: String?
    var seasonMoney: Float = 0
    var onlineProjectNum: Int = 0
    var name: String?
    var deleted: Int = 0
    var createdUser: Int = 0
    var seasonRebate: Float = 0
    var checkedUser: Int = 0
    var address: String?
    var seasonContrats: Int = 0
    var industryName: String?
    var checkedTime: Int = 0
    var updatedUser: Int = 0
    var lastVisitResult: String?
    var monthVisitNum: Int = 0
    var lockedProjectNum: Int = 0
    var status: Int = 0
    var parentId: Int = 0
    var monthContracts: Int = 0
    var weekVisitNum: Int = 0
    var developerName: String?
    var developTime: Int = 0
}
