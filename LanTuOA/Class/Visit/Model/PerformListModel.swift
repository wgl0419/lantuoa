//
//  PerformListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/17.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  业绩列表  数据结构

import UIKit
import HandyJSON

struct PerformListModel: HandyJSON {
    var status: Int = 0
    var data = [PerformListData]()
    var message: String?
    var errCode: Int = 0
}

struct PerformListChildren: HandyJSON {
    var money: Float = 0.0
    var title: String?
}

struct PerformListData: HandyJSON {
    var money: Float = 0.0
    var title: String?
    var children = [PerformListChildren]()
}
