//
//  NewPerformDetailModel.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import HandyJSON

struct NewPerformDetailModel: HandyJSON {
    var status: Int = 0
    var data = [NewPerformDetailData]()
    var message: String?
    var errCode: Int = 0
}

struct NewPerformDetailData: HandyJSON {
    var effectDays: Int = 0
    var title: String?
//    var performDay: Int = 0
    var money: Float = 0
//    var days: Int = 0
}
