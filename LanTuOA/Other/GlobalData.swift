//
//  GlobalData.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//  全局数据

import UIKit

// MARK: - 各种高度
/// 状态栏高度
let StateH: CGFloat = isIphoneX ? 44 : 20
/// 导航栏高度
let NavigationH: CGFloat = isIphoneX ? 88 : 64
/// tabbar高度
let TabbarH: CGFloat = isIphoneX ? 83 : 49
/// iPhone X 底部高度
let SafeH: CGFloat = isIphoneX ? 34 : 0
/// 当前屏幕宽度
let ScreenWidth: CGFloat = UIScreen.main.bounds.width
/// 当前屏幕高度
let ScreenHeight: CGFloat = UIScreen.main.bounds.height
/// 当前屏幕bounds
let ScreenBounds: CGRect = UIScreen.main.bounds
/// 间隔（用于处理iphone5屏幕小  显示不全问题）
let spacing: CGFloat = isIphone5 ? 3 : 0

// MARK: - 判断手机
/// 获取宽高最大值
let screenMaxLength = max(ScreenWidth, ScreenHeight)
/// 是否是手机
let isPhone = UI_USER_INTERFACE_IDIOM() == .phone
/// 是否是iPhone X
let isIphoneX = isPhone && screenMaxLength > 736.0
/// 是否是iPhone 4
let isIphone4 = ScreenWidth == 640 && ScreenHeight == 960
/// 是否是iPhone 5 or 5s
let isIphone5 = ScreenWidth == 320 && ScreenHeight == 568
/// 是否是iPhone 6 or 7 or 8
let isIphone = ScreenWidth == 375 && ScreenHeight == 667
/// 是否是iPhone 6 Plus or 7 Plus or 8 Plus
let isIphonePlus = ScreenWidth == 414 && ScreenHeight == 736

// MARK: - 各种颜色
/// 黑色
let blackColor = UIColor(hex: "#222222")

// MARK: - 服务器地址

/// 服务器地址(正式)
//let serverAddressURL = ""

/// 测试服务器(蒙冠洲电脑)
//let serverAddressURL = "192.168.1.135:9102"
//let serverAddressURL = "192.168.1.247:9101"
/// 测试服务器(李健电脑)
//let serverAddressURL = "192.168.1.111:9101"
/// 测试服务器
let serverAddressURL = "api.lantudev.danjuantaxi.com"
