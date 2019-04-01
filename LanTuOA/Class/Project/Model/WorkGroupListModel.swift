//
//  WorkGroupListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/1.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  工作组列表 数据模型

import UIKit
import HandyJSON

struct WorkGroupListModel: HandyJSON {
    var status: Int = 0
    var data = [WorkGroupListData]()
    var message: String?
    var page: Int = 0
    var errCode: Int = 0
    var max_page: Int = 0
}

struct WorkGroupListData: HandyJSON {
    var projectId: Int = 0
    var status: Int = 0
    var name: String?
    var createdUser: Int = 0
    var id: Int = 0
    var projectName: String?
    var createdTime: Int = 0
    var members: String?
}
