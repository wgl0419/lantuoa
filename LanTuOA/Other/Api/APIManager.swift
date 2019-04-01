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
    case logout() // 退出登录
    case loginUser() // 获取个人信息
    case users(Int, Int, String, Int) // 用户列表 (page:页码 limit:一页几条数据 realname:真实名称  used:是否启用)

    case usersPwd(String, String) // 修改密码 （oldPwd:原密码  新密码:新密码）
    
    
    // MARK: - 客户
    case customerSave(String, String, String, Int, Int) // 新建客户（管理界面） (name:客户简称 full_name:客户全称  address:客户地址  type:客户类型：1.公司客户，2.待开发客户，3.开发中客户  industry:行业类型id，从行业列表中获取)
    case customerUpdate(String, String, String, Int, Int) // 编辑客户 (name:客户简称 full_name:客户全称  address:客户地址  type:客户类型：1.公司客户，2.待开发客户，3.开发中客户  industry:行业类型id，从行业列表中获取)
    case customerContactList(Int, Int, Int) // 客户联系人列表 (customerId:客户id  page:页码  limit:一页有几条数据)
    case customerContactDetail(Int) // 客户联系人修改历史 （客户id:拼接到连接上）
    case customerList(String, Int, String, Int, Int) // 客户基本信息列表 (name:客户名称  type:1.公司客户2.待开发客户3.开发中客户 industry:行业id  page:页码  limit:一页几条数据)
    case customerContactSave(Int, String, String, String) // 新增客户联系人 （customerId:客户id   name:客户姓名  phone:手机号  position:职位）
    case customerContactUpdate(Int, String, String, String) // 修改客户联系人信息 （customerId:客户id   name:客户姓名  phone:手机号  position:职位）
    case customerListStatistics(String, Int?, Int?, Int, Int) // 客户统计信息列表 （name:客户名称  type:客户类型，1.公司客户，2.待开发客户，3.开发中客户  industry：行业id（保留）  page:页码  limit:一页几条数据）
    case customerSaveRequire(String, String, String, Int) // 申请新增客户（拜访页面） （name:客户名称  full_name:客户全称  address:公司地址  industry:行业id）
    case customerIndustryList() // 行业列表
    case customerDetail(String) // 客户详情
    
    
    // MARK: - 项目
    case projectSave(String, Int, String) // 新增项目（管理界面） （name:项目名称  customerId:客户id  address:地址）
    case projectUpdate(String?, Int, Int?, Int?, String?) // 编辑项目 （name:项目名称  id:id  manageUser:管理人id  isLock:是否锁定，1锁定，0否  address:地址）
    case projectOffline(Int, Int) // 上/下线项目 (id:项目id   offline:1设为下线，2设为上限)
    case projectMemberList(Int) // 项目成员列表 （projectId:项目id）
    case projectMemberAdd(Int, String) // 新增项目成员  （projectId:项目id  users:用户id，英文半角逗号分隔）
    case projectMemberDelete(Int, String) // 删除项目成员  （projectId:项目id  users:用户id，英文半角逗号分隔）
    case projectListStatistics(String, Int, Int, Int, Int?) // 项目统计列表  (name:项目/客户名称  customerId:客户id  page:页码  limit:一页几条数据  manageUser:管理人Id)
    case projectList(String, Int?, Int, Int) // 项目信息列表  (name:项目/客户名称  customerId:客户id  page:页码  limit:一页几条数据)
    
    
    // MARK: - 拜访
    case visitSave(Int, Int, Int, String, String, Int, Array<Int>) // 新增拜访 (customerId:客户id  projectId:项目id  type:拜访方式，1.面谈，2.电话沟通，3.网络聊天  content:拜访内容  result:拜访结果  visitTime:拜访时间，时间戳，秒级   contact:拜访人id数组)
    case visitList(String, Int?, Int?, Int, Int, Int, Int?, Int?) // 拜访查询 (name:关键词，客户名称/项目名称  startTime:开始时间，秒级  endTime:结束时间，秒级  queryType:1.全部，2.只看自己，3.工作组，4.接手  page:页码  limit:一页几条数据  customerId:客户id     projectId:项目id)
    
    // MARK: - 工作组
    case workGroupCreate(String, [String], Int) // 新建工作组 (name:工作组名称  members:成员id  projectId:项目id)
    case workGroupList(Int, Int, Int) // 工作组列表 （page:页码  limit:一页数据  projectId:项目id）
    
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
            
        case .projectSave: return "/api/project/save"
        case .projectUpdate: return "/api/project/update"
        case .projectOffline: return "/api/project/offline"
        case .projectMemberList: return "/api/project/member/list"
        case .projectMemberAdd: return "/api/project/member/add"
        case .projectMemberDelete: return "/api/project/member/delete"
        case .projectListStatistics: return "/api/project/list/statistics"
        case .projectList: return "/api/project/list"

            
        case .visitSave: return "/api/visit/save"
        case .visitList: return "/api/visit/list"
            
            
        case .workGroupCreate: return "/api/workGroup/create"
        case .workGroupList: return "/api/workGroup/list"
            
            
        default: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case  .customerSave, .customerUpdate, .customerContactSave, .customerContactUpdate, .customerSaveRequire:
            return .post
        case  .projectSave, .projectUpdate, .projectOffline, .projectMemberAdd, .projectMemberDelete:
            return .post
        case .visitSave:
            return .post
        case .workGroupCreate:
            return .post
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
            params = ["phone":phone, "pwd": pwd]
        case let .users(page, limit, realname, used): // 用户列表
            params = ["page": page, "limit": limit, "realname": realname, "used": used]
        case let .usersPwd(oldPwd, newPwd): // 修改密码
            params = ["oldPwd": oldPwd, "newPwd": newPwd]
            
            
        case let .customerSave(name, full_name, address, type, industry): // 新建客户
            params = ["name": name, "full_name": full_name, "address": address, "type": type, "industry": industry]
        case let .customerUpdate(name, full_name, address, type, industry): // 编辑客户
            params = ["name": name, "full_name": full_name, "address": address, "type": type, "industry": industry]
        case let .customerContactList(customerId, page, limit): // 客户联系人修改历史
            params = ["customerId": customerId, "page": page, "limit": limit]
        case let .customerList(name, type, industry, page, limit): // 客户基本信息列表
            params = ["name": name, "type": type, "industry": industry, "page": page, "limit": limit]
        case let .customerContactSave(customerId, name, phone, position): // 新增客户联系人
            params = ["customerId": customerId, "name": name, "phone": phone, "position": position]
        case let .customerContactUpdate(customerId, name, phone, position): // 修改客户联系人信息
            params = ["customerId": customerId, "name": name, "phone": phone, "position": position]
        case let .customerListStatistics(name, type, industry, page, limit): // 客户统计信息列表
            params = ["name": name, "page": page, "limit": limit]
            if type != nil { params["type"] = type }
            if industry != nil { params["industry"] = industry }
            
            
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
        case let .projectMemberDelete(projectId, users): // 删除项目成员
            params = ["projectId": projectId, "users": users]
        case let .projectListStatistics(name, customerId, page, limit, manageUser): // 项目统计列表
            params = ["name": name, "customerId": customerId, "page": page, "limit": limit]
            if manageUser != nil { params["manageUser"] = manageUser! }
        case let .projectList(name, customerId, page, limit): // 项目统计列表
            params = ["name": name, "page": page, "limit": limit]
            if customerId != nil { params["customerId"] = customerId! }
        case let .customerSaveRequire(name, full_name, address, industry): // 申请新增客户（拜访页面）
            params = ["name": name, "full_name": full_name, "address": address, "industry": industry]
            
            
        case let .visitSave(customerId, projectId, type, content, result, visitTime, contact): // 新增拜访
            params = ["customerId": customerId, "projectId": projectId, "type": type, "content": content, "result": result, "visitTime": visitTime, "contact": contact]
        case let .visitList(name, startTime, endTime, queryType, page, limit, cutomerId, projectId): // 拜访查询
            params = ["name": name, "queryType": queryType, "page": page, "limit": limit]
            if startTime != nil { params["startTime"] = startTime! }
            if endTime != nil { params["endTime"] = endTime! }
            if cutomerId != nil { params["cutomerId"] = endTime! }
            if projectId != nil { params["projectId"] = projectId! }
            
            
        case let .workGroupCreate(name, members, projectId): // 新建工作组
            params = ["name": name, "members": members, "projectId": projectId]
        case let .workGroupList(page, limit, projectId):
            params = ["page": page, "limit": limit, "projectId": projectId]
            
        default: params = [:] // 退出登录,获取个人信息,客户联系人修改历史,行业列表
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        switch self {
        case .x:
            return ["Content-Type": "application/json"]
        default:
            return [:]
        }
    }
    

}
