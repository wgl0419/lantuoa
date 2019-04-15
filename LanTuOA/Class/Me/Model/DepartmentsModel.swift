//
//  DepartmentsModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  部门列表  数据结构

import UIKit
import HandyJSON

struct DepartmentsModel: HandyJSON {
    var status: Int = 0
    var data = [DepartmentsData]()
    var message: String?
    var errCode: Int = 0
}

struct DepartmentsData: HandyJSON {
    var parentId: Int = 0
    var name: String?
    var id: Int = 0
    var remark: String?
    var memberNum: Int = 0
    var createdTime: Int = 0
}
