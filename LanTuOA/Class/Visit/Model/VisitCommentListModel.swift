//
//  VisitCommentListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/24.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  拜访评论   数据模型

import UIKit
import HandyJSON

struct VisitCommentListModel: HandyJSON {
    var status: Int = 0
    var data = [NotifyCheckCommentListData]()
    var message: String?
    var errCode: Int = 0
}
