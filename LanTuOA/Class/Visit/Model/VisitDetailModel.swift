//
//  VisitDetailModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/9.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访详情  数据模型

import UIKit
import HandyJSON

struct VisitDetailModel: HandyJSON {
    var status: Int = 0
    var data: VisitListData?
    var message: String?
    var errCode: Int = 0
}
