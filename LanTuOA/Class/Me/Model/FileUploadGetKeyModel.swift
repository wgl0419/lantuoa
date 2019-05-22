//
//  FileUploadGetKeyModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import HandyJSON

struct FileUploadGetKeyModel: HandyJSON {
    var status: Int = 0
    var data: FileUploadGetKeyData?
    var message: String?
    var errCode: Int = 0
}

struct FileUploadGetKeyData: HandyJSON {
    var status: Int = 0
    var uploadUser: Int = 0
    var id: Int = 0
    var fileName: String?
    var uploadTime: Int = 0
    var relateId: String?
    var objectName: String?
    var type: Int = 0
}
