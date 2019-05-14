//
//  VersionModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/14.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  版本更新 数据模型

import UIKit
import HandyJSON

struct VersionModel: HandyJSON {
    var status: Int = 0
    var data: VersionData?
    var message: String?
    var errCode: Int = 0
}

struct VersionData: HandyJSON {
    var status: String?
    var versionNo: String?
    var createdUser: Int = 0
    var id: Int = 0
    var platform: Int = 0
    var downloadUrl: String?
    var fileSize: Float = 0.0
    var updateDesc: String?
    var forceUpdate: Int = 0
}

