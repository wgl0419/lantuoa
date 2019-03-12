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
    
    private override init() {
//        super.init()
    }
    
    // MARK: - 数据归档
    /// 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: "token")
        aCoder.encode(userName, forKey: "userName")
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        userName = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
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
}

