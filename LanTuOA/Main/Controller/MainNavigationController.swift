//
//  MainNavigationController.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    enum navType {
        case light
        case dark
        case hidden
    }
    
    /// 是否能左滑返回
    var isInteractivePopGestureRecognizer = true {
        didSet {
            self.interactivePopGestureRecognizer?.isEnabled = isInteractivePopGestureRecognizer
        }
    }
    
    /// 截取返回点击
    var backBlock: (() -> ())?
    
    /// 懒加载 返回按钮
    lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        btn.setImage(UIImage(named: "nav_back_white"), for: .normal)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        if children.count > 1 {
            children.first?.hidesBottomBarWhenPushed = false
            children.last?.navigationItem.hidesBackButton = true
            self.interactivePopGestureRecognizer?.isEnabled = true
            children.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            navigationBar.isTranslucent = false
            UIApplication.shared.statusBarStyle = .lightContent
            self.interactivePopGestureRecognizer?.delegate = self
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        }
    }
    
    // MARK - 自定义公用方法
    /// 设置标题类型
    func setNavConfigure(type: navType, color: UIColor, isShadow: Bool = true) {
        switch type {
        case .light:
            backBtn.setImage(UIImage(named: "nav_icon_back"), for: .normal)
            UIApplication.shared.statusBarStyle = .lightContent
            UIApplication.shared.setStatusBarHidden(false, with: .none)
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
        case .dark:
            backBtn.setImage(UIImage(named: "nav_back_white"), for: .normal)
            UIApplication.shared.statusBarStyle = .default
            UIApplication.shared.setStatusBarHidden(false, with: .none)
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        case .hidden:
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
        }
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = color
        if isShadow {
            navigationBar.shadowImage = UIImage.imageWithColor(color)
        } else {
            navigationBar.shadowImage = nil
        }
    }
    
    // MARK - 按钮点击
    /// 返回
    @objc private func back() {
        if backBlock != nil {
            backBlock!()
        } else {
            children.last?.navigationController?.popViewController(animated: true)
        }
    }
}

extension MainNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            return false
        } else {
            return true
        }
    }
}
