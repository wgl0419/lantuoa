//
//  APIManager.swift
//  LanTuOA
//
//  Created by HYH on 2019/3/12.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import Moya
import Foundation

enum APIManager {
    
}

extension APIManager: TargetType {
    var baseURL: URL {
        return URL(string: "http://" + serverAddressURL)!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var params: [String : Any]
        params = [:]
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
//        switch self {
//        case .quotationSave:
//            return ["Content-Type": "application/json"]
//        default:
            return [:]
//        }
    }
    

}
