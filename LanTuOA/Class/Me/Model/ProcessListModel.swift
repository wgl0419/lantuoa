//
//  ProcessListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/11.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  流程列表  数据模型

import UIKit
import HandyJSON

struct ProcessListModel: HandyJSON {
    var status: Int = 0
    var data = [ProcessListData]()
    var message: String?
    var errCode: Int = 0
}

struct ProcessListList: HandyJSON {
    var name: String?
    var createdUser: Int = 0
    var editable: Int = 0
    var id: Int = 0
    var checkLength: Int = 0
    var paramsLength: Int = 0
    var type: Int = 0
    var createdTime: Int = 0
}

struct ProcessListData: HandyJSON {
    var type: Int = 0
    var desc: String?
    var list = [ProcessListList]()
}
