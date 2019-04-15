//
//  NotifyListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/2.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  通知列表  数据模型

import UIKit
import HandyJSON

struct NotifyListModel: HandyJSON {
    var status: Int = 0
    var data = [NotifyListData]()
    var message: String?
    var errCode: Int = 0
}

struct NotifyListData: HandyJSON {
    var content: String?
    var status: Int = 0
    var createdUser: Int = 0
    var id: Int = 0
    var important: Int = 0
    var title: String?
    var checkId: Int = 0
    var type: String?
    var readTime: Int = 0
    var createdTime: Int = 0
}
