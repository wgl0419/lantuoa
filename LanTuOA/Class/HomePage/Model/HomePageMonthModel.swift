//
//  HomePageMonthModel.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/28.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

import HandyJSON

struct HomePageMonthModel: HandyJSON {
    var status: Int = 0
    var data: HomePageMonthData?
    var message: String?
    var errCode: Int = 0
}

struct HomePageMonthData: HandyJSON{
    var totalValue: String?
    var data = [HomePageNameData]()
    var month : String?
    var id :Int = 0
    var title : String?
    
}

struct HomePageNameData: HandyJSON{
    var name: String?
    var value: Int = 0
}
