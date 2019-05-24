//
//  NotifyCheckCommentListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/23.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import HandyJSON

struct NotifyCheckCommentListModel: HandyJSON {
    var status: Int = 0
    var data = [NotifyCheckCommentListData]()
    var message: String?
    var errCode: Int = 0
}

struct NotifyCheckCommentListData: HandyJSON {
    var deleted: Int = 0
    var createdUser: Int = 0
    var commentsFiles = [NotifyCheckListValue]()
    var id: Int = 0
    var `self`: Int = 0
    var text: String?
    var situation: Int = 0
    var userName: String?
    var relateId: Int = 0
    var type: Int = 0
    var createdTime: Int = 0
}
