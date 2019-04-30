//
//  AppDelegate.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/6.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift // 键盘处理

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// 网络状态枚举
    ///
    /// - notReachable: 无网络
    /// - unknown: 未知
    /// - wwan: 4G
    /// - wifi: WIFI
    enum NetWorkState {
        case notReachable
        case unknown
        case wwan
        case wifi
    }
    
    var window: UIWindow?
    static var netWorkState : NetWorkState = .unknown
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configJPush(launchOptions: launchOptions)
        setDifferenceForIOS11()
        setIQKeyboardManager()
        setMainController()
        setNetWork()
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
    
    /// 极光推送处理
    private func configJPush(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if (Double(UIDevice.current.systemVersion) ?? 0) >= 10.0 {
            let entity = JPUSHRegisterEntity()
            entity.types = 0|1|2
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        } else {
            JPUSHService.register(forRemoteNotificationTypes:0|1|2, categories: nil)
        }
        JPUSHService.setup(withOption: launchOptions, appKey: "65903c371debbb3aac77d566", channel: "App Store", apsForProduction: true)
        JPUSHService.setLogOFF() // 关闭日志打印
        JPUSHService.registrationIDCompletionHandler { (resCode: Int32, registrationID: String?) in
            if resCode == 0  { // 获取到 registrationID
                UserInfo.share.setRegistrationID(registrationID!)
            }
        }
    }
    
    /// 设置主视图
    private func setMainController() {
        window = UIWindow(frame: ScreenBounds)
        if UserInfo.share.token.count == 0 { // 未登录过
            let vc = LoginController()
            let nav = MainNavigationController(rootViewController: vc)
            window?.rootViewController = nav
        } else { // 登录过
            let vcs = [HomePageController(), VisitHomeController(), CustomerHomeController(), NoticeHomeController(), MeHomeController()]
            let seleImageNames = ["menu_homePage_highlight", "menu_visit_highlight", "menu_customer_highlight", "menu_notice_highlight", "menu_me_highlight"]
            let imageNames = ["menu_homePage_normal", "menu_visit_normal", "menu_customer_normal", "menu_notice_normal", "menu_me_normal"]
            let titles = ["首页", "拜访", "客户", "通知", "我"]
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
    
    /// 设置网络连接监听通知
    private func setNetWork() {
        let net = NetworkReachabilityManager()
            net?.listener = { (status) in
            switch status {
            case .notReachable:
                AppDelegate.netWorkState = .notReachable
            case .unknown:
                AppDelegate.netWorkState = .unknown
            case .reachable(.ethernetOrWiFi):
                AppDelegate.netWorkState = .wifi
            case .reachable(.wwan):
                AppDelegate.netWorkState = .wwan
            }
        }
        net?.startListening()
    }
}

extension AppDelegate { // 推送处理
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { // 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { // 实现注册 APNs 失败接口（可选）

    }
}

extension AppDelegate: JPUSHRegisterDelegate {
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {

    }

    @available(iOS 10.0, *) // 程序关闭后, 通过点击推送弹出的通知
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        if response.notification.request.trigger is UNPushNotificationTrigger {
            let userInfo = response.notification.request.content.userInfo
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler() // 系统要求执行这个方法
    }

    @available(iOS 10.0, *) // 当程序在前台时, 收到推送弹出的通知
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        let task = userInfo["task"] as? String
        if task == "1" {
            return
        }
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            print("iOS10 前台收到远程通知:\(userInfo)")
            JPUSHService.handleRemoteNotification(userInfo)
        }else {
            // 判断为本地通知
            print("iOS10 前台收到本地通知:\(userInfo)")
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue | UNAuthorizationOptions.sound.rawValue | UNAuthorizationOptions.badge.rawValue))// 需要执行这个方法，选择是否提醒用户，有badge、sound、alert三种类型可以选择设置
        }
    }
}
