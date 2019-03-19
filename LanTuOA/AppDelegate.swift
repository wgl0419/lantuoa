//
//  AppDelegate.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/6.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift // 键盘处理

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setDifferenceForIOS11()
        setIQKeyboardManager()
        setMainController()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func applicationWillTerminate(_ application: UIApplication) { }
    
}

extension AppDelegate {
    /// 处理iOS 11的差异
    private func setDifferenceForIOS11() {
        if #available(iOS 11.0, *) {
            UITableView.appearance().contentInsetAdjustmentBehavior = .automatic
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        }
    }
    
    /// 设置键盘处理
    private func setIQKeyboardManager() {
        // 会tableview在"键盘弹起"并"上移"状态下  点击其他位置  出现键盘隐藏后进行二次点击（本来是点击空白的  然后变成点击tableview滚动回来时的位置cell）未解决
        //        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
    }
    
    /// 设置主视图
    private func setMainController() {
        window = UIWindow(frame: ScreenBounds)
        if UserInfo.share.token.count == 0 { // 未登录过
            let vc = LoginController()
            let nav = MainNavigationController(rootViewController: vc)
            window?.rootViewController = nav
        } else { // 登录过
            let vcs = [HomePageController(), VisitHomeController(), CustomerHomeController(), WrokHomeController(), MeHomeController()]
            let seleImageNames = ["menu_calc_highlight", "menu_list_highlight", "menu_notice_highlight", "menu_my_highlight", "menu_my_highlight"]
            let imageNames = ["menu_calc_normal", "menu_list_normal", "menu_notice_normal", "menu_my_normal", "menu_my_normal"]
            let titles = ["首页", "拜访", "客户", "工作", "我"]
            let bar = UITabBarController()
            for index in 0..<vcs.count {
                let vc = vcs[index]
                let nav = MainNavigationController(rootViewController: vc)
                let item = nav.tabBarItem
                item?.title = titles[index]
                item?.selectedImage = UIImage(named: seleImageNames[index])?.withRenderingMode(.alwaysOriginal)
                item?.image = UIImage(named: imageNames[index])?.withRenderingMode(.alwaysOriginal)
                item?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "#999999")], for: .normal)
                item?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "#2E4695")], for: .selected)
                bar.addChild(nav)
            }
            window?.rootViewController = bar
        }
        
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}
