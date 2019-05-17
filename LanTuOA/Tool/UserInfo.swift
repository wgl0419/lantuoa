//
//  UserInfo.swift
//  DanJuanERP
//
//  Created by HYH on 2019/1/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class UserInfo: NSObject, NSCoding {
    /// 用户保存Key
    let UserInfoDefaults = "UserInfoDefaults"
    
    private static var instance = UserInfo()
    class var share: UserInfo {
        if instance.token.isEmpty {
            instance = instance.userLoad() ?? UserInfo()
        }
        return instance
    }
    
    /// token
    private(set) var token = ""
    /// 用户名
    private(set) var userName = ""
    /// 手机号 -> 登录账号
    private(set) var phone = ""
    /// 职位
    private(set) var position = ""
    /// registrationID
    private(set) var registrationID = ""
    /// securityToken（oss）
    private(set) var securityToken = ""
    /// securityToken 获取时间戳
//    private(set) var 
    
    private override init() {
//        super.init()
    }
    
    // MARK: - 数据归档
    /// 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: "token")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(position, forKey: "position")
        aCoder.encode(registrationID, forKey: "registrationID")
        aCoder.encode(securityToken, forKey: "securityToken")
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        userName = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
        phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        position = aDecoder.decodeObject(forKey: "position") as? String ?? ""
        registrationID = aDecoder.decodeObject(forKey: "registrationID") as? String ?? ""
        securityToken = aDecoder.decodeObject(forKey: "securityToken") as? String ?? ""
    }
    
    // MARK: - 数据修改
    /// 生成归档
    ///
    /// - Returns: 返回自身
    func userLoad() -> UserInfo? {
        let user: UserInfo?
        let userDef = UserDefaults.standard
        if let data = userDef.object(forKey: UserInfoDefaults) {
            user =  NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? UserInfo
            return user
        }
        return nil
    }
    
    /// 保存数据
    func userSave() {
        let userDef = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        userDef.set(data, forKey: UserInfoDefaults)
    }
    
    /// 清空数据
    func userRemve() {
        token = ""
        userName = ""
        phone = ""
        position = ""
        registrationID = ""
        securityToken = ""
        userSave()
    }
    
    /// 修改token
    func setToken(_ token: String) {
        self.token = token
        userSave()
    }
    
    /// 修改用户名称
    func setUserName(_ userName: String) {
        self.userName = userName
        userSave()
    }
    
    /// 记录手机号
    func setPhone(_ phone: String) {
        self.phone = phone
        userSave()
    }
    
    /// 记录职位
    func setPosition(_ position: String) {
        self.position = position
        userSave()
    }
    
    /// 记录registrationID
    func setRegistrationID(_ registrationID: String) {
        self.registrationID = registrationID
        userSave()
    }
    
    /// 修改securityToken
    func setSecurityToken(_ securityToken: String) {
        self.securityToken = securityToken
        userSave()
    }
}

