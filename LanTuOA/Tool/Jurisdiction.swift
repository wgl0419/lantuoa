//
//  Jurisdiction.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/23.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class Jurisdiction: NSObject, NSCoding {
    /// 用户保存Key
    let JurisdictionInfoDefaults = "JurisdictionInfoDefaults"
    
    private static var instance = Jurisdiction()
    class var share: Jurisdiction {
        if !instance.isObtain {
            instance = instance.userLoad() ?? Jurisdiction()
        }
        return instance
    }
    /// 是否获取过
    private(set) var isObtain = false
    /// 查看客户
    private(set) var isCheckCustomer = false
    /// 修改客户
    private(set) var isEditCustomer = false
    /// 新增客户
    private(set) var isAddCustomer = false
    /// 新增项目
    private(set) var isAddProject = false
    /// 修改项目
    private(set) var isEditProject = false
    /// 新增部门
    private(set) var isAddDepartment = false
    /// 编辑部门
    private(set) var isEditDepartment = false
    /// 更换员工部门
    private(set) var isModifyPerson = false
    /// 离职员工
    private(set) var isLeavePerson = false
    /// 新增部门员工
    private(set) var isAddDepartmentMember = false
    /// 查看他人绩效
    private(set) var isViewPerform = false
    /// 工作交接功能
    private(set) var isViewWorkextend = false
    /// 查看拜访有无询筛选项
    private(set) var isViewVisitUnder = false
    /// 新增合同备注信息
    private(set) var isManageContractDesc = false
    /// 查看合同备注信息
    private(set) var isViewContractDesc = false
    
    private override init() {
        //        super.init()
    }
    
    // MARK: - 数据归档
    /// 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isObtain, forKey: "isObtain")
        aCoder.encode(isCheckCustomer, forKey: "isCheckCustomer")
        aCoder.encode(isEditCustomer, forKey: "isEditCustomer")
        aCoder.encode(isAddCustomer, forKey: "isAddCustomer")
        aCoder.encode(isAddProject, forKey: "isAddProject")
        aCoder.encode(isEditProject, forKey: "isEditProject")
        aCoder.encode(isAddDepartment, forKey: "isAddDepartment")
        aCoder.encode(isEditDepartment, forKey: "isEditDepartment")
        aCoder.encode(isModifyPerson, forKey: "isModifyPerson")
        aCoder.encode(isLeavePerson, forKey: "isLeavePerson")
        aCoder.encode(isAddDepartmentMember, forKey: "isAddDepartmentMember")
        aCoder.encode(isViewPerform, forKey: "isViewPerform")
        aCoder.encode(isViewWorkextend, forKey: "isViewWorkextend")
        aCoder.encode(isViewVisitUnder, forKey: "isViewVisitUnder")
        aCoder.encode(isManageContractDesc, forKey: "isManageContractDesc")
        aCoder.encode(isViewContractDesc, forKey: "isViewContractDesc")
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        isObtain = aDecoder.decodeBool(forKey: "isObtain")
        isCheckCustomer = aDecoder.decodeBool(forKey: "isCheckCustomer")
        isEditCustomer = aDecoder.decodeBool(forKey: "isEditCustomer")
        isAddCustomer = aDecoder.decodeBool(forKey: "isAddCustomer")
        isAddProject = aDecoder.decodeBool(forKey: "isAddProject")
        isEditProject = aDecoder.decodeBool(forKey: "isEditProject")
        isAddDepartment = aDecoder.decodeBool(forKey: "isAddDepartment")
        isEditDepartment = aDecoder.decodeBool(forKey: "isEditDepartment")
        isModifyPerson = aDecoder.decodeBool(forKey: "isModifyPerson")
        isLeavePerson = aDecoder.decodeBool(forKey: "isLeavePerson")
        isAddDepartmentMember = aDecoder.decodeBool(forKey: "isAddDepartmentMember")
        isViewPerform = aDecoder.decodeBool(forKey: "isViewPerform")
        isViewWorkextend = aDecoder.decodeBool(forKey: "isViewWorkextend")
        isViewVisitUnder = aDecoder.decodeBool(forKey: "isViewVisitUnder")
        isManageContractDesc = aDecoder.decodeBool(forKey: "isManageContractDesc")
        isViewContractDesc = aDecoder.decodeBool(forKey: "isViewContractDesc")
    }
    
    // MARK: - 数据修改
    /// 生成归档
    ///
    /// - Returns: 返回自身
    func userLoad() -> Jurisdiction? {
        let user: Jurisdiction?
        let userDef = UserDefaults.standard
        if let data = userDef.object(forKey: JurisdictionInfoDefaults) {
            user =  NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? Jurisdiction
            return user
        }
        return nil
    }
    
    /// 保存数据
    func userSave() {
        let userDef = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        userDef.set(data, forKey: JurisdictionInfoDefaults)
    }
    
    /// 清空数据
    func userRemve() {
        isObtain = false
        isCheckCustomer = false
        isEditCustomer = false
        isAddCustomer = false
        isAddProject = false
        isEditProject = false
        isAddDepartment = false
        isEditDepartment = false
        isModifyPerson = false
        isLeavePerson = false
        isAddDepartmentMember = false
        isViewPerform = false
        isViewWorkextend = false
        isViewVisitUnder = false
        isManageContractDesc = false
        isViewContractDesc = false
        userSave()
    }
    
    /// 设置数据
    func setJurisdiction(data: [UsersPermissionsData]) {
        userRemve()
        isObtain = true
        for model in data {
            switch model.url ?? "" {
            case "customer.manager": isCheckCustomer = true
            case "customer.manager:edit": isEditCustomer = true
            case "customer.manager:add": isAddCustomer = true
            case "project.manager:add": isAddProject = true
            case "project.manager:edit": isEditProject = true
            case "department.manager:add": isAddDepartment = true
            case "department.manager:edit": isEditDepartment = true
            case "person.manager:modify": isModifyPerson = true
            case "person.manager:leave": isLeavePerson = true
            case "department.manager.member:add": isAddDepartmentMember = true
            case "perform.view": isViewPerform = true
            case "workextend.view": isViewWorkextend = true
            case "visit.under:view": isViewVisitUnder = true
            case "contract.desc:manage": isManageContractDesc = true
            case "contract.desc:view": isViewContractDesc = true
            default: break
            }
        }
        userSave()
    }
}


