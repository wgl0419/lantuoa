//
//  LoginModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/14.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  登录数据 模型

import UIKit
import HandyJSON

struct LoginModel: HandyJSON {
    var status: String?
    var data: LoginData?
    var message: String?
    var errCode: Int = 0
}

struct LoginData: HandyJSON {
    var token: String?
}
