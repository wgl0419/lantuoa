//
//  AnnouncementModel.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/18.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import HandyJSON

struct AnnouncementModel: HandyJSON {
    var status: Int = 0
    var data = [AnnouncementListData]()
    var message: String?
    var errCode: Int = 0
}

struct AnnouncementListData: HandyJSON {
    var content: String?
    var createdTime: Int = 0
    var createdUser: Int = 0
    var createdUserName: String?
    var id: Int = 0
    var title: String?
    var files = [filesData]()
    
}

struct filesData: HandyJSON {
    var fileName: String?
    var fileSize: Int = 0
    var id: Int = 0
    var objectName: String?
    var relateId: String?
    var status: Int = 0
    var type: Int = 0
    var uploadTime: Int = 0
    var uploadUser : Int = 0
}

struct AnnouncementNoticeModel: HandyJSON {
    var status: Int = 0
    var data: AnnouncementListData?
    var message: String?
    var errCode: Int = 0
}
