//
//  AliOSSClient.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/16.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class AliOSSClient: NSObject {
    private static let instance = AliOSSClient()
    /// 上传回调
    public typealias uploadCallblock = ((Bool) -> Void)?
    
    private var client: OSSClient!
    
    /// 单例
    class var shared: AliOSSClient {
        return instance
    }
    
    override init() {
        super.init()
        let endpoint = "http://oss-cn-shenzhen.aliyuncs.com/"
        let credential = OSSAuthCredentialProvider(authServerUrl: "http://api.lantudev.danjuantaxi.com/api/stsRegistoer")
        client = OSSClient(endpoint: endpoint, credentialProvider: credential)
    }
    
    /// 上传图片
    func uploadData(_ data: Data, name: String, body: Int, callback: uploadCallblock) {
        let put = OSSPutObjectRequest()
        put.bucketName = "danjuan-lantuoa"
        put.objectKey = name
        
        put.uploadingData = data
        put.callbackParam = ["callbackUrl": "http://api.lantudev.danjuantaxi.com/api/callback/fileUpload", "callbackBody": "\(body)", "callbackBodyType": "application/json"]
        put.contentType = "application/json"
        let putTask = self.client.putObject(put)
        
        putTask.continue({ (task) -> Any? in
            if task.error != nil {
                if callback != nil {
                    callback!(false)
                }
            } else {
                if callback != nil {
                    callback!(true)
                }
            }
            return nil
        })
        putTask.waitUntilFinished()
    }
    
    /// 下载
    func download(url: String, path: String, isCache: Bool, result: @escaping ((Data?) -> ())) {
        let enclosurePath = getCachesPath(path)
        let data = try? Data(contentsOf: URL(fileURLWithPath: enclosurePath))
        if data != nil {
            result(data)
            return
        }
        
        let request = OSSGetObjectRequest()
        request.bucketName = "danjuan-lantuoa"
        request.objectKey = url
        
        request.downloadProgress = { (bytesWritten: Int64,totalBytesWritten : Int64, totalBytesExpectedToWrite: Int64) -> Void in
            print("bytesWritten:\(bytesWritten),totalBytesWritten:\(totalBytesWritten),totalBytesExpectedToWrite:\(totalBytesExpectedToWrite)");
        };
        
        let task = client.getObject(request)
        
        task.continue({(t) -> OSSTask<AnyObject>? in
            if t.error == nil {
                let getResult = t.result as! OSSGetObjectResult
                if isCache { // 缓存
                    FileManager.default.createFile(atPath: self.getCachesPath(path), contents: getResult.downloadedData, attributes: nil)
                }
                result(getResult.downloadedData)
            } else {
                // 下载失败
                result(nil)
            }
            return nil
        })
    }
    
    /// 缓存路径
    func getCachesPath(_ path: String = "/caches/") -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileName = path.components(separatedBy: "/").last ?? ""
        var enclosurePath = cachePath! + path
        if fileName.count > 0 {
            let range = enclosurePath.range(of: fileName)!
            enclosurePath.removeSubrange(range)
        }
        
        if !FileManager.default.fileExists(atPath: enclosurePath) {
            do {
                try FileManager.default.createDirectory(atPath: enclosurePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
        }
        return cachePath! + path
    }
    
}
