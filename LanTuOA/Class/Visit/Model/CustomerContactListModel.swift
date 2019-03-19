//
//  CustomerContactListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  客户联系人列表  数据模型

import UIKit
import HandyJSON

struct CustomerContactListModel: HandyJSON {
    var status: Int = 0
    var data = [CustomerContactListData]()
    var message: String?
    var page: Int = 0
    var errCode: Int = 0
    var max_page: Int = 0
}

struct CustomerContactListData: HandyJSON {
    var phone: String?
    var name: String?
    var position: String?
    var id: Int = 0
    var createdTime: Int = 0
    var customerId: Int = 0
}
