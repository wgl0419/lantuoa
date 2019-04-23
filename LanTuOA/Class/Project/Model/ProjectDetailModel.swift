//
//  ProjectDetailModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/23.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目详情 数据模型

import UIKit
import HandyJSON

struct ProjectDetailModel: HandyJSON {
    var status: Int = 0
    var data: ProjectListStatisticsData?
    var message: String?
    var errCode: Int = 0
}
