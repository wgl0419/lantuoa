//
//  WorkReportListModel.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

import HandyJSON

struct WorkReportListModel: HandyJSON {
    var status: Int = 0
    var data = [WorkReportListData]()
    var message: String?
    var errCode: Int = 0
}

struct WorkReportListData: HandyJSON {
    var canUpload: Int = 0
    var checkLength: Int = 0
    var createdTime: Int = 0
    var createdUser: Int = 0
    var deleted: Int = 0
    var editable: Int = 0
    var id: Int = 0
    var isNote: Int = 0
    var name: String?
    var paramsLength: Int = 0
    var type: Int = 0
    
}

