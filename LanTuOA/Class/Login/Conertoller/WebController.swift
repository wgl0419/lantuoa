//
//  WebController.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  网页 控制器

import UIKit
import WebKit

class WebController: UIViewController {
    
    /// 文件名称
    var fileNameStr = ""
    /// 网页地址
    var urlStr = "https://www.baidu.com/"
    
    /// 网页控件
    private var webView: WKWebView!
    /// 进度条
    private var progress: UIProgressView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let nav = navigationController as! MainNavigationController
        nav.setNavConfigure(type: .dark, color: UIColor(hex: "#2E4695"), isShadow: false)
        nav.backBtn.isHidden = false
        nav.backBlock = {
            if self.webView.canGoBack {
                self.webView.goBack()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let nav = navigationController as! MainNavigationController
        nav.backBlock = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    // MARK: - 自定义私有方法
    private func initSubViews() {
        view.backgroundColor = UIColor(hex: "#F4F4F4")
        
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 20
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.userContentController = WKUserContentController()
        
        webView = WKWebView(frame: CGRect.zero, configuration: config) // 网页控件
            .taxi.adhere(toSuperView: view)
            .taxi.layout(snapKitMaker: { (make) in
                make.edges.equalTo(view)
            })
            .taxi.config({ (webView) in
                webView.navigationDelegate = self
                webView.uiDelegate = self
                webView.allowsBackForwardNavigationGestures = true
                if fileNameStr.count != 0 {
                    if fileNameStr == "deal" {
                        title = "《用户使用协议》"
                    } else {
                        title = "《隐私协议》"
                    }
                    let path = Bundle.main.path(forResource: fileNameStr, ofType: "docx")
                    let url = URL(fileURLWithPath: path ?? "")
                    webView.load(URLRequest(url: url))
                } else {
                    webView.load(URLRequest(url: URL(string: urlStr)!))
                }
                webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            })
        
        //进度条
        progress = UIProgressView.init(frame: CGRect(x:0, y:1, width: ScreenWidth, height:1))
        progress.transform = CGAffineTransform.init(scaleX: 1, y: 0.5)
        progress.progressViewStyle = .bar
        self.view.addSubview(progress)
        progress.progressTintColor = UIColor.blue
        progress.trackTintColor = UIColor.white
        progress.progress = 0
    }
    
    // MARK: 进度条
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progress.progress = Float(webView.estimatedProgress)
        }
        //加载完成隐藏进度条
        if progress.progress == 1{
            let afterTime: DispatchTime = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: afterTime) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.progress.isHidden = true
                }, completion: { (result) in
                    self.progress.progress = 0
                })
            }
        }
    }

}

extension WebController: WKNavigationDelegate {
    /**
     *  根据webView、navigationAction相关信息决定这次跳转是否可以继续进行,这些信息包含HTTP发送请求，如头部包含User-Agent,Accept,refer
     *  在发送请求之前，决定是否跳转的代理
     *  @param webView
     *  @param navigationAction
     *  @param decisionHandler
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url?.absoluteString
        if url == "不想要跳转的url"{
            decisionHandler(.cancel)
        }
        decisionHandler(.allow)
    }
    
    /**
     *  页面加载完成。 等同于UIWebViewDelegate: - webViewDidFinishLoad:
     *  一般在这个方法中，我们会获取加载的一些内容，比如title，另外WKWebView内部的方法canGoBack，canGoForward，都很容易让使用者控制当前页面的前进和回退交互
     *  @param webView
     *  @param navigation
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if fileNameStr.count == 0 {
            self.title = webView.title
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}

extension WebController: WKUIDelegate {
    /*  webView要求一个新webView进行加载 ，如果此方法不实现，就取消加载web  */
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let url = navigationAction.request.url?.absoluteString
        if url == "" {
            let newWebV = WKWebView.init(frame: self.view.bounds, configuration: configuration)
            return newWebV
        }
        return nil
    }
    
    //如果我们的页面中有调用了js的alert、confirm、prompt方法，
    //我们应该实现下面这几个代理方法，然后在原来这里调用native的弹出窗，
    //因为使用WKWebView后，HTML中的alert、confirm、prompt方法调用是不会再弹出窗口了，
    //只是转化成ios的native回调代理方法
    //JS 要弹出警告框, message是js传入的内容
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle:.alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
        }
        alertController.addAction(okAction)
        // 弹出
        self.present(alertController, animated: true, completion: nil)
        completionHandler()
    }
}
