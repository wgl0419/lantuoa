//
//  NewPerformUnderModel.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import HandyJSON

struct NewPerformUnderModel: HandyJSON {

    var status: Int = 0
    var data = [NewPerformUnderData]()
    var message: String?
    var errCode: Int = 0
}

struct NewPerformUnderData : HandyJSON{
    var totalValue : Int = 0
    var name : String?
    var id : Int = 0
    var title :String?
    var data = [NewPerformUnderListData]()
}

struct NewPerformUnderListData : HandyJSON{
    var name : String?
    var value : String?
}

struct NewPerformUnderOneselfModel: HandyJSON {
    
    var status: Int = 0
    var data = [NewPerformUnderOneselfData]()
    var message: String?
    var errCode: Int = 0
}

struct NewPerformUnderOneselfData : HandyJSON{
    var totalValue : String!
    var name : String?
    var id : Int = 0
    var title :String?
    var data = [NewPerformUnderListData]()
}
