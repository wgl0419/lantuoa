//
//  ProjectListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import HandyJSON

struct ProjectListModel: HandyJSON {
    var status: Int = 0
    var data = [ProjectListStatisticsData]()
    var message: String?
    var errCode: Int = 0
}

