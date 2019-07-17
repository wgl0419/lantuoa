//
//  OperationLogModel.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import HandyJSON

struct OperationLogModel: HandyJSON {
    var status: Int = 0
    var data = [OperationLogListData]()
    var message: String?
    var errCode: Int = 0
}

struct OperationLogListData: HandyJSON {
    var id: Int = 0
    var operateTime: Int = 0
    var operateUser: Int = 0
    var operationCode: Int = 0
    var operationInfo: String?
    var operationName: String?
    var realname: String?
    var url: String?
}
