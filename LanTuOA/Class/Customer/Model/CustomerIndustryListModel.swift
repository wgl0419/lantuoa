//
//  CustomerIndustryListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/25.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  行业列表 数据模型

import UIKit
import HandyJSON

struct CustomerIndustryListModel: HandyJSON {
    var status: Int = 0
    var data = [CustomerIndustryListData]()
    var message: String?
    var errCode: Int = 0
}

struct CustomerIndustryListData: HandyJSON {
    var id: Int = 0
    var name: String?
}
