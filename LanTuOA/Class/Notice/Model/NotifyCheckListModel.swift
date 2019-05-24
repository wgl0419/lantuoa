//
//  NotifyCheckListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/3.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  审核列表 数据模型

import UIKit
import HandyJSON

struct NotifyCheckListModel: HandyJSON {
    var status: Int = 0
    var data = [NotifyCheckListData]()
    var message: String?
    var errCode: Int = 0
}

struct NotifyCheckListSmallData: HandyJSON {
    var name: String?
    var value: String?
    var title: String?
    /// 1.key-value，2.表单标题，3.表单结束分隔符，4.图片，5.文件
    var type: Int = 0
    var sort: Int = 0
    var fileArr = [NotifyCheckListValue]()
}

struct NotifyCheckListData: HandyJSON {
    var projectId: Int = 0
    var data = [NotifyCheckListSmallData]()
    var checkLength: Int = 0
    var createdUser: Int = 0
    var processName: String?
    var checkedTime: Int = 0
    var totalMoney: Int = 0
    var createdTime: Int = 0
    var customerId: Int = 0
    var step: Int = 0
    var status: Int = 0
    var createdUserName: String?
    var id: Int = 0
    var processId: Int = 0
    var params: String?
    var rejectComment: String?
    var title: String?
    var paramsLength: Int = 0
    var processType: Int = 0
    var projectName: String?
    var customerName: String?
    var personStatus: Int = 0
}

struct NotifyCheckListValue: HandyJSON {
    var uploadUser: Int = 0
    var status: Int = 0
    var id: Int = 0
    var fileName: String?
    var uploadTime: Int = 0
    var commentId: Int = 0
    var fileId: Int = 0
    var fileType: Int = 0
    var fileSize: Int = 0
    var relateId: String?
    var objectName: String?
    var type: Int = 0
}

