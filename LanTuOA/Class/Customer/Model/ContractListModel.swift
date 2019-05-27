//
//  ContractListModel.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  合同列表  数据模型

import UIKit
import HandyJSON

struct ContractListModel: HandyJSON {
    var status: Int = 0
    var data = [ContractListData]()
    var message: String?
    var errCode: Int = 0
}

struct ContractListSmallData: HandyJSON {
    var name: String?
    var isNecessary: Int = 0
    var value: String?
    var id: Int = 0
    var processId: Int = 0
    var sort: Int = 0
    var title: String?
    var hint: String?
    var type: Int = 0
}

struct ContractListContractUsers: HandyJSON {
    var realname: String?
    var userId: Int = 0
    var propMoney: Int = 0
    var propPerform: Int = 0
    var contractId: Int = 0
}

struct ContractListData: HandyJSON {
    var data = [ContractListSmallData]()
    var contractUsers = [ContractListContractUsers]()
    var type: String?
    var totalMoney: Float = 0
    var customerId: Int = 0
    var createdTime: Int = 0
    var startTimePre: Int = 0
    var membersName: String?
    var id: Int = 0
    var code: String?
    var processId: Int = 0
    var endTimePre: Int = 0
    var contactId: Int = 0
    var rebate: Float = 0
    var projectId: Int = 0
    var name: String?
    var policyId: Int = 0
    var checkedTime: Int = 0
    var status: Int = 0
    var signTime: Int = 0
    var otherParams: String?
    var paybackMoney: Float = 0
    var endTime: Int = 0
    var makeMoney: Float = 0
    var startTime: Int = 0
    var invoiceInfo: String?
}
