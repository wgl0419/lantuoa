//
//  ProjectLlistStatisticsModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目统计列表 数据模型

import UIKit
import HandyJSON

struct ProjectLlistStatisticsModel: HandyJSON {
    var status: Int = 0
    var data = [ProjectLlistStatisticsData]()
    var message: String?
    var errCode: Int = 0
}

struct ProjectLlistStatisticsData: HandyJSON {
    var name: String?
    var deleted: Int = 0
    var lastVisitTime: Int = 0
    var visitId: Int = 0
    var createdUser: Int = 0
    var monthVisitUserNum: Int = 0
    var responseUserNum: Int = 0
    var weekVisitUserNum: Int = 0
    var createdTime: Int = 0
    var customerId: Int = 0
    var lastVisitUser: Int = 0
    var manageUser: Int = 0
    var lastVisitUserName: String?
    var lastVisitResult: String?
    var id: Int = 0
    var monthVisitNum: Int = 0
    var isLock: Int = 0
    var customerName: String?
    var weekVisitNum: Int = 0
}
