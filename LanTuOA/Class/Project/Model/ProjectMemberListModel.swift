//
//  ProjectMemberListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  项目成员列表 数据模型

import UIKit
import HandyJSON

struct ProjectMemberListModel: HandyJSON {
    var status: Int = 0
    var data = [ProjectMemberListData]()
    var message: String?
    var errCode: Int = 0
}

struct ProjectMemberListData: HandyJSON {
    var roleName: String?
    var projectId: Int = 0
    var phone: String?
    var userName: String?
    var departmentName: String?
    var userId: Int = 0
    var joinTime: Int = 0
}
