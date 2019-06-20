//
//  ProcessParamsModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/12.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  流程内容  数据结构

import UIKit
import HandyJSON

struct ProcessParamsModel: HandyJSON {
    var status: Int = 0
    var data = [ProcessParamsData]()
    var message: String?
    var errCode: Int = 0
}

struct ProcessParamsChoices: HandyJSON {
    var id: Int = 0
    var name: String?
    var paramsId: Int = 0
}

struct ProcessParamsData: HandyJSON {
    var name: String?
    var isNecessary: Int = 0
    var id: Int = 0
    var processId: Int = 0
    var sort: Int = 0
    var choices = [ProcessParamsChoices]()
    var children = [ProcessParamsData]()
    var title: String?
    var hint: String?
    /// 字段类型：1.文本（高度可变），2.数字，3.日期，4.单选，5.多选，6.客户，7.项目，9.相册，10.附件，11.具体时间
    var type: Int = 0
}
