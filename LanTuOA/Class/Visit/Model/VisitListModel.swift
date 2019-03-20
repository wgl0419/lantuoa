//
//  VisitListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访列表  数据模型

import UIKit
import HandyJSON

struct VisitListModel: HandyJSON {
    var status: Int = 0
    var data = [VisitListData]()
    var message: String?
    var errCode: Int = 0
}

struct VisitListData: HandyJSON {
    var projectId: Int = 0
    var deleted: Int = 0
    var createdUser: Int = 0
    var type: Int = 0
    var result: String?
    var createdTime: Int = 0
    var customerId: Int = 0
    var latitude: Int = 0
    var status: Int = 0
    var content: String?
    var id: Int = 0
    var projectName: String?
    var createUserName: String?
    var customerName: String?
    var longitude: Int = 0
    var visitTime: Int = 0
}

