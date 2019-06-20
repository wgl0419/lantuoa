//
//  APIService.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/12.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import Moya
import UIKit
import HandyJSON
import MBProgressHUD

class APIService {
    
    private static let instance = APIService()
    /// 单例
    class var shared: APIService {
        return instance
    }
    
    /// 请求节点配置闭包
    lazy var endpointClosure = { (target: APIManager) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        var endpoint = Endpoint(
            url: url,
            sampleResponseClosure:  { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        endpoint = endpoint.adding(newHTTPHeaderFields: ["token": UserInfo.share.token])
        
        return endpoint
    }
    
    /// 请求配置闭包
    lazy var requestClosure = { (endpoint: Endpoint, closure: MoyaProvider<APIManager>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 7.0
            closure(.success(request))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    private var APIProvider: MoyaProvider<APIManager>? = nil
    
    private init() {
        APIProvider = MoyaProvider<APIManager>(endpointClosure: endpointClosure, requestClosure: requestClosure)
        
    }
}

extension APIService {
    
    
    /// 获取数据
    ///
    /// - Parameters:
    ///   - target: 目标接口
    ///   - t: 类型
    ///   - successHandle: 成功回调闭包
    ///   - errorHandle: 错误回调闭包
    func getData<T : HandyJSON>(_ target: APIManager, t: T.Type, successHandle: ((_ result: T) -> Void)?, errorHandle: ((_ errorMsg: String?) ->Void)?) -> Cancellable? {
        let cellable = APIProvider?.request(target) { (result) in
            switch result {
            case let .success(response):
                if response.statusCode == 401 {
                    errorHandle!("未获得授权,请重新登录")
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                        let jsonDic = json as? [String: Any]
                        if let errCode = jsonDic!["errCode"] as? Int, errCode != 0 { // 错误信息
                            if errCode == 2000 { // token过期，异地登录
                                UserInfo.share.userRemve() // 清除数据
                                let vc = self.getCurrentController()
                                let loginVc = LoginController()
                                vc?.view.window?.rootViewController = loginVc
                                MBProgressHUD.showError("请重新登录")
                                return
                            }
                            guard errorHandle != nil  else {
                                return
                            }
                            errorHandle!(jsonDic!["message"] as? String)
                            return
                        }
                        let dataModel = JSONDeserializer<T>.deserializeFrom(dict: jsonDic)
                        guard successHandle != nil  else {
                            return
                        }
                        successHandle!(dataModel!)
                    } catch (_) {
                        guard errorHandle != nil  else {
                            return
                        }
                        errorHandle!("未知错误")
                    }
                }
            case let .failure(error):
                guard errorHandle != nil  else {
                    return
                }
                errorHandle!(error.response?.description)
                
            }
        }
        return cellable
    }
    
    /// 取消全部请求
    func cancelAllRequest() {
        APIProvider?.manager.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    /// 获取当前控制器
    func getCurrentController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        
        var tempView: UIView?
        for subview in window.subviews.reversed() {
            if subview.classForCoder.description() == "UILayoutContainerView" {
                tempView = subview
                break
            }
        }
        if tempView == nil {
            tempView = window.subviews.last
        }
        var nextResponder = tempView?.next
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }
        while next{
            tempView = tempView?.subviews.first
            if tempView == nil {
                return nil
            }
            nextResponder = tempView!.next
        }
        return nextResponder as? UIViewController
    }
}

