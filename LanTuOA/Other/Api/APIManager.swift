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
    
    
    // MARK: - 客户
    case customerSave(String, String, String, Int, Int) // 新建客户 (name:客户简称 full_name:客户全称  address:客户地址  type:客户类型：1.公司客户，2.待开发客户，3.开发中客户  industry:行业类型id，从行业列表中获取)
    case customerUpdate(String, String, String, Int, Int) // 编辑客户 (name:客户简称 full_name:客户全称  address:客户地址  type:客户类型：1.公司客户，2.待开发客户，3.开发中客户  industry:行业类型id，从行业列表中获取)
    case customerContactList(Int, Int, Int) // 客户联系人列表 (customerId:客户id  page:页码  limit:一页有几条数据)
    case customerContactDetail(Int) // 客户联系人修改历史 （客户id:拼接到连接上）
    case customerList(String, Int, String, Int, Int) // 客户基本信息列表 (name:客户名称  type:1.公司客户2.待开发客户3.开发中客户 industry:行业id  page:页码  limit:一页几条数据)
    case customerContactSave(Int, String, String, String) // 新增客户联系人 （customerId:客户id   name:客户姓名  phone:手机号  position:职位）
    case customerContactUpdate(Int, String, String, String) // 修改客户联系人信息 （customerId:客户id   name:客户姓名  phone:手机号  position:职位）
    case customerListStatistics(String, Int, Int?, Int, Int) // 客户统计信息列表 （name:客户名称  type:客户类型，1.公司客户，2.待开发客户，3.开发中客户  industry：行业id（保留）  page:页码  limit:一页几条数据）
    
    
    // MARK: - 项目
    case projectSave(String, Int, Int, Int) // 新增项目 （name:项目名称  customerId:客户id  manageUser:管理人id  isLock:是否锁定，1锁定，0否）
    case projectUpdate(String, Int, Int, Int) // 编辑项目 （name:项目名称  customerId:客户id  manageUser:管理人id  isLock:是否锁定，1锁定，0否）
    case projectOffline(Int, Int) // 上/下线项目 (id:项目id   offline:1设为下线，2设为上限)
    case projectMenberList(Int) // 项目成员列表 （projectId:项目id）
    case projectMemberAdd(Int, String) // 新增项目成员  （projectId:项目id  users:用户id，英文半角逗号分隔）
    case projectMemberDelete(Int, String) // 删除项目成员  （projectId:项目id  users:用户id，英文半角逗号分隔）
    case projectListStatistics(String, Int, Int, Int, Int?) // 项目统计列表  (name:项目/客户名称  customerId:客户id  page:页码  limit:一页几条数据  manageUser:管理人Id)
    case projectList(String, Int?, Int, Int) // 项目信息列表  (name:项目/客户名称  customerId:客户id  page:页码  limit:一页几条数据)
    
    
    // MARK: - 拜访
    case visitSave(Int, Int, Int, String, String, Int) // 新增拜访 (customerId:客户id  projectId:项目id  type:拜访方式，1.面谈，2.电话沟通，3.网络聊天  content:拜访内容  result:拜访结果  visitTime:拜访时间，时间戳，秒级)
    case visitList(String, Int, Int, Int, Int, Int) // 拜访查询 (name:关键词，客户名称/项目名称  startTime:开始时间，秒级  endTime:结束时间，秒级  queryType:1.全部，2.只看自己，3.工作组，4.接手  page:页码  limit:一页几条数据)
    
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
            
        case .customerSave: return "/api/customer/save"
        case .customerUpdate: return "/api/customer/update"
        case .customerContactList: return "/api/customer/contact/list"
        case .customerContactDetail(let id): return "/api/customer/contact/detail/\(id)"
        case .customerList: return "/api/customer/list"
        case .customerContactSave: return "/api/customer/contact/save"
        case .customerContactUpdate: return "/api/customer/contact/update"
        case .customerListStatistics: return "/api/customer/list/statistics"
            
        case .projectSave: return "/api/project/save"
        case .projectUpdate: return "/api/project/update"
        case .projectOffline: return "/api/project/offline"
        case .projectMenberList: return "/api/project/menber/list"
        case .projectMemberAdd: return "/api/project/member/add"
        case .projectMemberDelete: return "/api/project/member/delete"
        case .projectListStatistics: return "/api/project/list/statistics"
        case .projectList: return "/api/project/list"

            
        case .visitSave: return "/api/visit/save"
        case .visitList: return "/api/visit/list"
            
        default: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .customerSave, .customerUpdate, .customerContactSave, .customerContactUpdate, .projectSave, .projectUpdate, .projectOffline, .projectMenberList, .projectMemberAdd, .projectMemberDelete, .visitSave:
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
            params = ["name": name, "type": type, "page": page, "limit": limit]
            if industry != nil {
                params["industry"] = industry
            }
            
            
        case let .projectSave(name, customerId, manageUser, isLock): // 新增项目
            params = ["name": name, "customerId": customerId, "manageUser": manageUser, "isLock": isLock]
        case let .projectUpdate(name, customerId, manageUser, isLock): // 修改项目
            params = ["name": name, "customerId": customerId, "manageUser": manageUser, "isLock": isLock]
        case let .projectOffline(id, offline): // 下线项目
            params = ["id": id, "offline": offline]
        case .projectMenberList(let projectId): // 项目成员列表
            params = ["projectId": projectId]
        case let .projectMemberAdd(projectId, users): // 新增项目成员
            params = ["projectId": projectId, "users": users]
        case let .projectMemberDelete(projectId, users): // 删除项目成员
            params = ["projectId": projectId, "users": users]
        case let .projectListStatistics(name, customerId, page, limit, manageUser): // 项目统计列表
            params = ["name": name, "customerId": customerId, "page": page, "limit": limit]
            if manageUser != nil {
                params["manageUser"] = manageUser!
            }
        case let .projectList(name, customerId, page, limit): // 项目统计列表
            params = ["name": name, "page": page, "limit": limit]
            if customerId != nil {
                params["customerId"] = customerId!
            }
            
        case let .visitSave(customerId, projectId, type, content, result, visitTime): // 新增拜访
            params = ["customerId": customerId, "projectId": projectId, "type": type, "content": content, "result": result, "visitTime": visitTime]
        case let .visitList(name, startTime, endTime, queryType, page, limit): // 拜访查询
            params = ["name": name, "startTime": startTime, "endTime": endTime, "queryType": queryType, "page": page, "limit": limit]
            
        default: params = [:] // 退出登录,获取个人信息,客户联系人修改历史
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
