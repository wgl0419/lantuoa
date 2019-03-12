//
//  MBProgressHUD.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/26.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//  简易的HUD封装

import UIKit
import MBProgressHUD

extension MBProgressHUD {
    //显示等待消息
    class func showWait(_ title: String, canEnabled: Bool = true) {
        dismiss()
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = canEnabled
    }
    
    //显示普通消息
    class func showInfo(_ title: String) {
        dismiss()
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView //模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "info")) //自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
    }
    
    //显示成功消息
    class func showSuccess(_ title: String) {
        dismiss()
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView //模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "tick")) //自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        //HUD窗口显示1秒后自动隐藏
        hud.hide(animated: true, afterDelay: 1)
    }
    
    //显示失败消息
    class func showError(_ title: String) {
        dismiss()
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView //模式设置为自定义视图
        hud.customView = UIImageView(image: UIImage(named: "cross")) //自定义视图显示图片
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        //HUD窗口显示1秒后自动隐藏
        hud.hide(animated: true, afterDelay: 1)
    }
    
    /// 隐藏信息
    class func dismiss() {
        let view = viewToShow()
        MBProgressHUD.hide(for: view, animated: true)
        
    }
    
    //获取用于显示提示框的view
    class func viewToShow() -> UIView {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windowArray = UIApplication.shared.windows
            for tempWin in windowArray {
                if tempWin.windowLevel == UIWindow.Level.normal {
                    window = tempWin;
                    break
                }
            }
        }
        return window!
    }
}

