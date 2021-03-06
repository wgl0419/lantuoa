//
//  APIManager.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/12.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import Moya
import Foundation

enum APIManager {
    /// MARK: - 用户及权限
    case login(String, String) // 登录 （phone:账号   pwd:密码）
    case logout // 退出登录
    case loginUser // 获取个人信息
    case users(Int, Int, String, Int) // 用户列表 (page:页码 limit:一页几条数据 realname:真实名称  used:是否启用)
    case usersPwd(String, String) // 修改密码 （oldPwd:原密码  新密码:新密码）
    case usersLeave(Int) // 离职员工
    case usersPermissions // 获取权限
    case version // 获取版本信息 (1.安卓2.iOS3.web)
    case startupSum // 首页统计
    case code(String) // 获取验证码
    case passwordReset(String, String, String) // 找回密码
    case newHomePageMonthList //新的首页统计（月份）
    
    // MARK: - 公告
    case checkAnnouncement
    ///历史公共列表
    case AnnouncementList(Int, Int,Int)
    ///公告详情
    case AnnouncementDetails(Int)
    
    // MARK: - 客户
    case customerSave(String, String, String, Int, Int) // 新建客户（管理界面） (name:客户简称 full_name:客户全称  address:客户地址  type:客户类型：1.公司客户，2.待开发客户，3.开发中客户  industry:行业类型id，从行业列表中获取)
    case customerUpdate(String, String, String, Int, Int, Int) // 编辑客户 (name:客户简称 full_name:客户全称  address:客户地址  type:客户类型：1.公司客户，2.待开发客户，3.开发中客户  industry:行业类型id，从行业列表中获取     id:客户id)
    case customerContactList(Int, Int, Int) // 客户联系人列表 (customerId:客户id  page:页码  limit:一页有几条数据)
    case customerContactDetail(Int) // 客户联系人修改历史 （客户id:拼接到连接上）
    case customerList(String, Int?, Int?, Int, Int) // 客户基本信息列表 (name:客户名称  type:1.公司客户2.待开发客户3.开发中客户 industry:行业id  page:页码  limit:一页几条数据)
    case customerContactSave(Int, String, String, String) // 新增客户联系人 （customerId:客户id   name:客户姓名  phone:手机号  position:职位）
    case customerContactUpdate(String, String, Int) // 修改客户联系人信息 （phone:手机号  position:职位  contactId:联系人Id）
    case customerListStatistics(String, Int?, Int?, Int, Int) // 客户统计信息列表 （name:客户名称  type:客户类型，1.公司客户，2.待开发客户，3.开发中客户  industry：行业id（保留）  page:页码  limit:一页几条数据）
    case customerSaveRequire(String, String, String, Int) // 申请新增客户（拜访页面） （name:客户名称  full_name:客户全称  address:公司地址  industry:行业id）
    case customerIndustryList // 行业列表
    case customerDetail(Int) // 客户详情
    case customerMembers(Int) // 客户跟进人员
    case customerUpdateDevelop(Int, Int, Int) // 设置开发客户
    
    
    // MARK: - 项目
    case projectSave(String, Int, String) // 新增项目（管理界面） （name:项目名称  customerId:客户id  address:地址）
    case projectUpdate(String?, Int, Int?, Int?, String?) // 编辑项目 （name:项目名称  id:id  manageUser:管理人id  isLock:是否锁定，1锁定，0否  address:地址）
    case projectOffline(Int, Int) // 上/下线项目 (id:项目id   offline:1设为下线，2设为上限)
    case projectMemberList(Int) // 项目成员列表 （projectId:项目id）
    case projectMemberAdd(Int, [Int]) // 新增项目成员  （projectId:项目id  users:用户id数组）
    case projectMemberDelete(Int, Int) // 删除项目成员  （projectId:项目id  userId:用户id）
    case projectListStatistics(String, Int, Int, Int, Int?) // 项目统计列表  (name:项目/客户名称  customerId:客户id  page:页码  limit:一页几条数据  manageUser:管理人Id)
    case projectList(String, String, Int, Int) // 项目信息列表  (name:项目/客户名称  customerId:客户id  page:页码  limit:一页几条数据)
    case projectDetail(Int) // 项目详情 (项目id)
    case projectSaveRequire(String, Int, String) // 申请新增项目（拜访页面） （name:项目名称  customerId:客户id  address:地址）
    
    
    // MARK: - 拜访
    case visitSave(Int, Int, Int, String, String, Int, Array<Int> ,Float ,Float,String) // 新增拜访 (customerId:客户id  projectId:项目id  type:拜访方式，1.面谈，2.电话沟通，3.网络聊天  content:拜访内容  result:拜访结果  visitTime:拜访时间，时间戳，秒级   contact:联系人id数组,纬度，经度，详细地址)
    case visitList(String, Int?, Int?, Int, Int, Int, Int?, Int?, Int?) // 拜访查询 (name:关键词，客户名称/项目名称  startTime:开始时间，秒级  endTime:结束时间，秒级  queryType:1.全部，2.只看自己，3.工作组，4.接手  page:页码  limit:一页几条数据  customerId:客户id   projectId:项目id     createdUser: 用户id)
    case visitDetail(Int) // 拜访详情
    case visitCommentCreate(Int, [Int], [Int], String) // 评论拜访
    case visitCommentList(Int) // 获取拜访评论
    
    // MARK: - 工作组
    case workGroupCreate(String, [Int], Int) // 新建工作组 (name:工作组名称  members:成员id  projectId:项目id)
    case workGroupList(Int, Int, Int?) // 工作组列表 （page:页码  limit:一页数据  projectId:项目id）
    case workGroupQuit(Int) // 退出工作组
    case workGroupInvite(Int, [Int]) // 邀请他人加入工作组   (groupId:工作组id  members：成员id数组)
    
    
    // MARK: - 通知
    case notifyList(Int, Int)// 通知列表 (page:页码  limit:一页数据)
    case notifyCheckReject(Int, [Int], [Int], String) // 拒绝审批-非创建客户/项目 (checkId:审批id    desc:备注）
    case notifyCheckCusRejectExist(Int, Int, Int) // 拒绝创建客户/项目-客户已存在 (checkId:审批id   customerId:客户id   projectId:项目id）
    case notifyCheckCusRejectMistake(Int, String, String) // 拒绝创建客户/项目-名称有误 (checkId:审批id   customerName:客户名称   projectName: 项目名称）
    case notifyCheckAgree(Int, [Int], [Int], String) // 同意审批 （desc:备注）
    case notifyCheckList(Int?, Int, Int) // 审核列表 (page:页码  limit:一页数据)
    case notifyCheckDetail(Int) // 审批详情
    case notifyCheckUserList(Int) // 审批人列表
    case notifyNumber // 未读消息数
    case notifyReadAll // 全部已读
    case notifyCheckCommentCreate(Int, [Int], [Int], String) // 审批评论
    case notifyCheckCommentDelete(Int) // 删除评论
    case notifyCheckCommentList(Int) // 审批评论列表
    case notifyCheckHaveRead(Int) //设置点击单条已读数据
    
    // MARK: - 工作交接
    case workExtendList(String, Int?,Int,Int) // 下级员工列表
    
    // MARK: - 部门
    case departments(Int?) // 部门列表  (parent:父部门id)
    case workExtendListPerson(Int) // 员工工作列表 (userId:员工id)
    case workExtendExtend(Int, Int, Int) // 交接工作 (projectId:项目id   oldUser:被交接人id   newUser:接手人id)
    case departmentsUsers(Int, String?, Int?) // 获取部门人员列表 （ 部门id  keyword:搜索内容   type:部门员工类型（默认1）：1 普通员工；2 副主管；3 主管；4 上级领导。选填。）
    case departmentsCreate(String, Int) // 新增部门 (name:部门名称  parentId:上级部门id,如果是顶级部门，则传0或不传)
    case departmentsAddUsers(Int, [Int]) // 新增部门人员 （id：部门id   userIds：新增人员）
    case departmentsChange(Int, [Int]) // 修改部门 （userid:用户id   newDeptIds:新部门ID数组）
    
    
    // mARK: - 工作申请
    case processHistory(Int?, Int, Int) // 历史申请列表 (status:1.申请中，2.通过，3.被拒绝   page:页码  limit:一页数据)
    case processList // 流程列表
    case processParams(Int) // 获取流程内容
    case processUsers(Int) // 获取流程默认审批/抄送人
    case processCommit(Int, [String:Any], [[String:String]], [[String:String]], [[String:String]], [[String:String]], [[String:String]]) // 提交流程
    
    // MARK: - 合同
    case contractList(String, Int?, Int?, Int?, Int, Int, Int?, Int?, Int?, Int?, Int?, Int?) // 合同列表/查询合同 (name:客户名称/项目名称/合同编码   customerId:客户id  projectId:项目id   userId:用户id，查询他人合同时使用  page:页码   limit:一页数据,paid:1表示已付款完成，2未完成付款，不传显示全部,overdue:传1表示逾期未付款，不传显示全部,active:1表示发布中，其他表示不限制)
    case contractPaybackList(Int) // 回款列表  (合同id)
    case performList(Int, Int?, Int?, Int?)  // 业绩列表  (queryType: 1.按人-合同查询 2.按人查询总业绩      userId:用户id(与self排斥)    self:查看自己的业绩(与userId排斥)       contractId:合同id（queryType = 1时传）)
    case contractUpdate(Int, Float?, Float?, Int?, Int?, Int?) // 修改合同内容  (合同id  totalMoney：合同总额   rebate:支持总额   startTime:开始时间戳  endTime:结束时间戳)
    case contractDetail(Int) // 合同详情 (合同id)
    case contractPaybackUpdate(Int, String, Float, Int) // 修改回款 (回款id  desc:备注  money:金额  payTime:回款时间)
    case contractPaybackAdd(Int, String, Float, Int) // 添加回款 (contractId:合同id  desc:备注  money:金额  payTime:回款时间)
    case performUnder(String) // 业绩查询 (name:查询名称)
    case newPerformUnder(Int?) // 最新查询（month：月份）
    case IndividualNewPerformUnder(Int,Int?)
    case performDetail(Int?, Int?, String) // 业绩查询-详情-月份业绩 （userId:用户id  self:是否是自己  month:月份,格式yyyy-MM）
    case contractTypeList // 合同类型列表
    case contractDescList(Int) // 合同备注信息列表
    case contractDescCreate(Int, String) // 新建合同备注 （contractIdL: 合同id   desc: 备注信息）
    case operationLogLists(Int, Int, Int)
//    case operationLogLists()
    
    //MARK：-工作汇报
    case WorkReportList
    case WorkReporCheckList(Int, Int, Int, Int,[String],Int,Int) // 第几页，页数，未读，模板id，提交人id，开始时间，结束时间，
    case WorkReporCheckListNumberUnread
    case WorkReporCheckListHaveRead(Int)
    case WorkReporCheckListDetail(Int)//日志详情
    case WorkReporCheckListDetailRecipient(Int)
    case WorkReporLogTemplate

    case fileOssToken // 获取安全令牌securityToken
    case fileUploadGetKey(Int, String, Int) // 上传文件报备
    
    case x // MARK: 补位 -> 暂时代替一些没有使用的类型
}

extension APIManager: TargetType {
    var baseURL: URL {
        return URL(string: "http://" + serverAddressURL)!
    }
    
    var path: String {
        switch self {
        case .login: return "/api/login"
        case .logout: return "/api/logout"
        case .loginUser: return "/api/loginUser"
        case .users: return "/api/users"
        case .usersPwd: return "/api/users/pwd"
        case .usersLeave(let id): return "/api/users/leave/\(id)"
        case .usersPermissions: return "/api/users/permissions"
        case .version: return "/api/version"
        case .startupSum: return "/api/startup/sum"
        case .code: return "/api/code"
        case .passwordReset: return "/api/password/reset"
        case .newHomePageMonthList: return "/api/startup/perform"
            
        case .checkAnnouncement: return "/api/broadcast/list/receive"
        case .AnnouncementList: return "/api/broadcast/list/all"
        case .AnnouncementDetails(let id): return "/api/broadcast/detail/\(id)"
            
        case .customerSave: return "/api/customer/save"
        case .customerUpdate: return "/api/customer/update"
        case .customerContactList: return "/api/customer/contact/list"
        case .customerContactDetail(let id): return "/api/customer/contact/detail/\(id)"
        case .customerList: return "/api/customer/list"
        case .customerContactSave: return "/api/customer/contact/save"
        case .customerContactUpdate: return "/api/customer/contact/update"
        case .customerListStatistics: return "/api/customer/list/statistics"
        case .customerSaveRequire: return "/api/customer/save/require"
        case .customerIndustryList: return "/api/customer/industry/list"
        case .customerDetail(let id): return "/api/customer/detail/\(id)"
        case .customerMembers(let id): return "/api/customer/members/\(id)"
        case .customerUpdateDevelop(let id, _, _): return "/api/customer/update/develop/\(id)"
            
        case .projectSave: return "/api/project/save"
        case .projectUpdate: return "/api/project/update"
        case .projectOffline: return "/api/project/offline"
        case .projectMemberList: return "/api/project/member/list"
        case .projectMemberAdd: return "/api/project/member/add"
        case .projectMemberDelete: return "/api/project/member/delete"
        case .projectListStatistics: return "/api/project/list/statistics"
        case .projectList: return "/api/project/list"
        case .projectDetail(let id): return "/api/project/detail/\(id)"
        case .projectSaveRequire: return "/api/project/save/require"

            
        case .visitSave: return "/api/visit/save"
        case .visitList: return "/api/visit/list"
        case .visitDetail(let id): return "/api/visit/detail/\(id)"
        case .visitCommentCreate(let id, _, _, _): return "/api/visit/comment/create/\(id)"
        case .visitCommentList(let id): return "/api/visit/comment/list/\(id)"
            
            
        case .workGroupCreate: return "/api/workGroup/create"
        case .workGroupList: return "/api/workGroup/list"
        case .workGroupQuit(let id): return "/api/workGroup/quit/\(id)"
        case .workGroupInvite: return "/api/workGroup/invite"
            
            
        case .notifyList: return "/api/notify/list"
        case .notifyCheckReject: return "/api/notify/check/reject"
        case .notifyCheckCusRejectExist: return "/api/notify/check/cus/reject/exist"
        case .notifyCheckCusRejectMistake: return "/api/notify/check/cus/reject/mistake"
        case .notifyCheckAgree(let id, _, _, _): return "/api/notify/check/agree/\(id)"
        case .notifyCheckList: return "/api/notify/check/list"
        case .notifyCheckDetail(let id): return "/api/notify/check/detail/\(id)"
        case .notifyCheckUserList(let id): return "/api/notify/check/user/list/\(id)"
        case .notifyNumber: return "/api/notify/number"
        case .notifyReadAll: return "/api/notify/readAll"
        case .notifyCheckCommentCreate(let id, _, _, _): return "/api/notify/check/comment/create/\(id)"
        case .notifyCheckCommentDelete(let id): return "/api/notify/check/comment/delete/\(id)"
        case .notifyCheckCommentList(let id): return "/api/notify/check/comment/list/\(id)"
        case .notifyCheckHaveRead(let id): return "/api/notify/read/\(id)"
            
        case .workExtendList: return "/api/workExtend/list"
            
            
        case .departments: return "/api/departments"
        case .workExtendListPerson: return "/api/workExtend/list/person"
        case .workExtendExtend: return "/api/workExtend/extend"
        case .departmentsUsers(let deptId, _, _): return "/api/departments/\(deptId)/users"
        case .departmentsCreate: return "/api/departments"
        case .departmentsAddUsers(let id, _): return "/api/departments/\(id)/addUsers"
        case .departmentsChange(let id, _): return "/api/departments/change/\(id)"
            
        case .processHistory: return "/api/process/history"
        case .processList: return "/api/process/list"
        case .processParams(let id): return "/api/process/params/\(id)"
        case .processUsers(let id): return "/api/process/users/\(id)"
        case .processCommit: return "/api/process/commit"
        
            
        case .contractList: return "/api/contract/list"
        case .contractPaybackList(let id): return "/api/contract/payback/list/\(id)"
        case .performList: return "/api/perform/list"
        case .contractUpdate(let id, _, _, _, _, _): return "/api/contract/update/\(id)"
        case .contractDetail(let id): return "/api/contract/detail/\(id)"
        case .contractPaybackUpdate(let id, _, _, _): return "/api/contract/payback/update/\(id)"
        case .contractPaybackAdd: return "/api/contract/payback/add"
        case .performUnder: return "/api/perform/under"
        case .newPerformUnder:return "/api/perform/depts"
        case .IndividualNewPerformUnder(let id, _): return "/api/perform/users/\(id)"
        case .performDetail: return "/api/perform/detail"
        case .contractTypeList: return "/api/contract/type/list"
        case .contractDescList(let id): return "/api/contract/desc/list/\(id)"
        case .contractDescCreate: return "api/contract/desc/create"
        case .operationLogLists: return "/api/contract/operation/list"
            
        case .WorkReportList: return "/api/note/list"
        case .WorkReporCheckList: return "/api/note/history"
        case .WorkReporCheckListNumberUnread: return "/api/note/number/notRead"
        case .WorkReporCheckListHaveRead(let id): return "/api/note/read/\(id)"
        case .WorkReporCheckListDetail(let id): return "/api/note/detail/\(id)"
        case .WorkReporCheckListDetailRecipient(let id): return "/api/notify/check/user/list/\(id)"
        case .WorkReporLogTemplate: return "/api/note/list/all"
            
        case .fileOssToken: return "/api/file/ossToken"
        case .fileUploadGetKey: return "/api/file/upload/getKey"
            
        default: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case  .customerSave, .customerUpdate, .customerContactSave, .customerContactUpdate, .customerSaveRequire, .contractDescCreate:
            return .post
        case  .projectSave, .projectUpdate, .projectOffline, .projectMemberAdd, .projectSaveRequire:
            return .post
        case .visitSave:
            return .post
        case .workGroupCreate, .workGroupInvite, .visitCommentCreate:
            return .post
        case .workGroupQuit:
            return .delete
        case .notifyCheckReject, .notifyCheckCusRejectExist, .notifyCheckCusRejectMistake, .notifyCheckAgree, .notifyReadAll, .notifyCheckCommentCreate:
            return .post
        case .workExtendExtend, .departmentsCreate, .departmentsAddUsers, .contractPaybackAdd, .processCommit:
            return .post
        case .usersPwd, .departmentsChange, .contractUpdate, .contractPaybackUpdate, .passwordReset, .customerUpdateDevelop,.WorkReporCheckListHaveRead, .notifyCheckHaveRead:
            return .put
        case .projectMemberDelete, .notifyCheckCommentDelete:
            return .delete
        case .usersLeave:
            return .delete
        default: return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var params: [String : Any]
        switch self {
        case let .login(phone, pwd): // 登录
            params = ["phone":phone, "pwd": pwd, "os": 2, "registrationId": UserInfo.share.registrationID]
            
        case let .users(page, limit, realname, used): // 用户列表
            params = ["page": page, "limit": limit, "realname": realname, "used": used, "status": 1]
        case let .usersPwd(oldPwd, newPwd): // 修改密码
            params = ["oldPwd": oldPwd, "newPwd": newPwd]
        case .version:
            params = ["os": 2]
        case .code(let phone): // 获取验证码
            params = ["phone": phone]
        case let .passwordReset(phone, code, newPwd): // 忘记密码
            params = ["phone": phone, "code": code, "newPwd": newPwd]
            
            //MARK:历史公告列表
        case let .AnnouncementList(type,page,limit):
            params = ["type": type, "page": page, "limit": limit]
            
        case let .customerSave(name, full_name, address, type, industry): // 新建客户
            params = ["name": name, "full_name": full_name, "address": address, "type": type, "industry": industry]
        case let .customerUpdate(name, full_name, address, type, industry, id): // 编辑客户
            params = ["name": name, "full_name": full_name, "address": address, "type": type, "industry": industry, "id": id]
        case let .customerContactList(customerId, page, limit): // 客户联系人修改历史
            params = ["customerId": customerId, "page": page, "limit": limit]
        case let .customerList(name, type, industry, page, limit): // 客户基本信息列表
            params = ["name": name, "page": page, "limit": limit]
            if type != nil { params["type"] = type }
            if industry != nil { params["industry"] = industry }
        case let .customerContactSave(customerId, name, phone, position): // 新增客户联系人
            params = ["customerId": customerId, "name": name, "phone": phone, "position": position]
        case let .customerContactUpdate(phone, position, contactId): // 修改客户联系人信息
            params = ["phone": phone, "position": position, "contactId": contactId]
        case let .customerListStatistics(name, type, industry, page, limit): // 客户统计信息列表
            params = ["name": name, "page": page, "limit": limit]
            if type != nil { params["type"] = type }
            if industry != nil { params["industry"] = industry }
            
//             "page": page, "limit": limit
        case let .projectSave(name, customerId, address): // 新增项目
            params = ["name": name, "customerId": customerId, "address": address]
        case let .projectUpdate(name, id, manageUser, isLock, address): // 修改项目
            params = ["id": id]
            if name != nil { params["name"] = name! }
            if manageUser != nil { params["manageUser"] = manageUser }
            if isLock != nil { params["isLock"] = isLock }
            if address != nil { params["address"] = address }
        case let .projectOffline(id, offline): // 下线项目
            params = ["id": id, "offline": offline]
        case .projectMemberList(let projectId): // 项目成员列表
            params = ["projectId": projectId]
        case let .projectMemberAdd(projectId, users): // 新增项目成员
            params = ["projectId": projectId, "users": users]
        case let .projectMemberDelete(projectId, userId): // 删除项目成员
            params = ["projectId": projectId, "userId": userId]
        case let .projectListStatistics(name, customerId, page, limit, manageUser): // 项目统计列表
            params = ["name": name, "customerId": customerId, "page": page, "limit": limit]
            if manageUser != nil { params["manageUser"] = manageUser! }
        case let .projectList(name, customerId, page, limit): // 项目统计列表
            params = ["name": name, "page": page, "limit": limit]
            if customerId != nil { params["customerId"] = customerId }
        case let .customerSaveRequire(name, full_name, address, industry): // 申请新增客户（拜访页面）
            params = ["name": name, "full_name": full_name, "address": address, "industry": industry]
        case let .projectSaveRequire(name, customerId, address): // 申请新增项目（拜访页面）
            params = ["name": name, "customerId": customerId, "address": address]
        case let .customerUpdateDevelop(_, userId, endTime): // 设置开发客户
            params = ["userId": userId, "endTime": endTime]
            
        case let .visitSave(customerId, projectId, type, content, result, visitTime, contact, latitude, longitude, address): // 新增拜访
            params = ["customerId": customerId, "projectId": projectId, "type": type, "content": content, "result": result, "visitTime": visitTime, "contact": contact]
            
            if latitude != 0.0 { params["latitude"] = latitude }
            if longitude != 0.0 { params["longitude"] = longitude }
            if address != nil { params["address"] = address }
            
        case let .visitList(name, startTime, endTime, queryType, page, limit, customerId, projectId, createdUser): // 拜访查询
            params = ["name": name, "queryType": queryType, "page": page, "limit": limit]
            if startTime != nil { params["startTime"] = startTime! }
            if endTime != nil { params["endTime"] = endTime! }
            if customerId != nil { params["customerId"] = customerId! }
            if projectId != nil { params["projectId"] = projectId! }
            if createdUser != nil { params["createdUser"] = createdUser! }
        case let .visitCommentCreate(_, imgs, files, text): // 评论拜访
            params = ["text": text]
            if imgs.count > 0 { params["imgs"] = imgs }
            if files.count > 0 { params["files"] = files }
            
            
        case let .workGroupCreate(name, members, projectId): // 新建工作组
            params = ["name": name, "members": members, "projectId": projectId]
        case let .workGroupList(page, limit, projectId): // 工作组列表
            params = ["page": page, "limit": limit]
            if projectId != nil { params["projectId"] = projectId }
        case let .workGroupInvite(groupId, members): // 邀请他人加入工作组
            params = ["groupId": groupId, "members": members]
            
            
        case let .notifyList(page, limit): // 通知列表
            params = ["page": page, "limit": limit]
        case let .notifyCheckReject(checkId, imgs, files, desc): // 拒绝审批-非创建客户/项目
            params = ["checkId": checkId, "desc": desc]
            if imgs.count > 0 { params["imgs"] = imgs }
            if files.count > 0 { params["files"] = files }
        case let .notifyCheckCusRejectExist(checkId, customerId, projectId): // 拒绝创建客户/项目-客户已存在
            params = ["checkId": checkId, "customerId": customerId, "projectId": projectId]
        case let .notifyCheckCusRejectMistake(checkId, customerName, projectName): // 拒绝创建客户/项目-名称有误
            params = ["checkId": checkId, "customerName": customerName, "projectName": projectName]
        case let .notifyCheckList(status ,page, limit): // 审核列表
            params = ["page": page, "limit": limit]
            if status != nil { params["status"] = status! }
        case let .notifyCheckAgree(_, imgs, files,desc): // 同意审批
            params = ["desc": desc]
            if imgs.count > 0 { params["imgs"] = imgs }
            if files.count > 0 { params["files"] = files }
        case let .notifyCheckCommentCreate(_, imgs, files, text): // 审批评论
            params = ["text": text]
            if imgs.count > 0 { params["imgs"] = imgs }
            if files.count > 0 { params["files"] = files }
    
            
        case .departments(let parent): // 部门列表
            params = [:]
            if parent != nil { params["parent"] = parent! }
        case let .workExtendList(name, status, page ,limit): // 下级员工列表
            params = ["name": name,"page": page, "limit": limit]
            if status != nil { params["status"] = status! }
        case .workExtendListPerson(let userId): // 员工工作列表
            params = ["userId": userId]
        case let .workExtendExtend(projectId, oldUser, newUser): // 交接工作
            params = ["projectId": projectId, "oldUser": oldUser, "newUser": newUser]
        case let .departmentsUsers(_, keyword, type): // 获取部门人员列表
            params = [:]
            if keyword != nil { params["keyword"] = keyword! }
            if keyword != nil { params["type"] = type! }
        case let .departmentsCreate(name, parentId): // 新增部门
            params = ["name": name, "parentId": parentId]
        case .departmentsAddUsers(_, let userIds): // 新增部门人员
            params = ["userIds": userIds]
        case let .departmentsChange(_ , newDeptIds): // 修改部门
            params = ["newDeptIds": newDeptIds]
            
            
        case let .processHistory(status, page, limit): // 历史申请列表
            params = ["page": page, "limit": limit]
            if status != nil { params["status"] = status! }
        case let .processCommit(processId, data, member, ccUsers, payback, files, imgs):
            params = ["processId": processId, "data": data]
            if member.count > 0 { params["member"] = member }
            if ccUsers.count > 0 { params["ccUsers"] = ccUsers }
            if payback.count > 0 { params["payback"] = payback }
//            if files.count > 0 { params["files"] = files }
//            if imgs.count > 0 { params["imgs"] = imgs }
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .contractList(name, customerId, projectId, userId, page, limit, startTime, endTime, processId , paid,overdue ,active): // 合同列表/查询合同
            params = ["name": name, "page": page, "limit": limit]
            if customerId != nil { params["customerId"] = customerId! }
            if projectId != nil { params["projectId"] = projectId! }
            if userId != nil { params["userId"] = userId! }
            if startTime != nil { params["startTime"] = startTime! }
            if endTime != nil { params["endTime"] = endTime! }
            if processId != nil { params["processId"] = processId! }
            if paid != nil { params["paid"] = paid! }
            if overdue != nil  { params["overdue"] = overdue! }
            if active != nil { params["active"] = active! }
            
            
        case let .performList(queryType, userId, `self`, contractId): // 业绩列表
            params = ["queryType": queryType]
            if userId != nil { params["userId"] = userId! }
            if `self` != nil { params["self"] = `self`! }
            if contractId != nil { params["contractId"] = contractId! }
        case let .contractUpdate(_, totalMoney, rebate, startTime, endTime, signTime): // 修改合同内容
            params = [:]
            if totalMoney != nil { params["totalMoney"] = totalMoney! }
            if rebate != nil { params["rebate"] = rebate! }
            if startTime != nil { params["startTime"] = startTime! }
            if endTime != nil { params["endTime"] = endTime! }
            if signTime != nil { params["signTime"] = signTime! }
        case let .contractPaybackUpdate(_, desc, money, payTime): // 修改回款
            params = ["desc": desc, "money": money, "payTime": payTime]
        case let .contractPaybackAdd(contractId, desc, money, payTime): // 新增回款
            params = ["contractId": contractId, "desc": desc, "money": money, "payTime": payTime]
        case .performUnder(let name): // 业绩查询
            params = ["name": name]
        case let .newPerformUnder(month): //最新的按月查询业绩
            params = ["month": month!]
        case let .IndividualNewPerformUnder(_,month):
            params = ["month": month!]
            
        case let .performDetail(userId, `self`, month): // 业绩查询-详情-月份业绩
            params = ["month": month]
            if userId != nil { params["userId"] = userId! }
            if `self` != nil { params["self"] = `self`! }
        case let .contractDescCreate(contractId, desc): // 新建合同备注
            params = ["contractId": contractId, "desc": desc]
        case let .operationLogLists(contractId,page,limit): //操作日志
            params = ["page": page, "limit": limit]
            if contractId != 0 {params["contractId"] = contractId }
            
        case let .WorkReporCheckList(page,limit,notRead,processId,commitUser,startTime,endTime): //查看汇报列表
            
            params = ["page":page,"limit":limit,"notRead":notRead]
            
            if startTime != 0 { params["startTime"] = startTime }
            if endTime != 0 { params["endTime"] = endTime }
            if processId > 0 { params["processId"] = processId }
            if commitUser.count > 0 { params["commitUser"] = commitUser }
            
        case let .fileUploadGetKey(fileType, fileName, fileSize): // 上传文件报备
            params = ["fileType": fileType, "fileName": fileName, "fileSize": fileSize]
            
        default: params = [:]
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        switch self {
        case .processCommit:
            return ["Content-Type": "application/json"]
        default:
            return [:]
        }
    }
    

}
