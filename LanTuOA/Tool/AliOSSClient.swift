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
    func uploadImage(image: UIImage, name: String, body: Int, callback: uploadCallblock) {
        
        let put = OSSPutObjectRequest()
        put.bucketName = "danjuan-lantuoa"
        put.objectKey = name
        
        let data = image.jpegData(compressionQuality: 0.5) ?? Data()
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
    }
    
    /// 上传文件
    func uploadFile(name: String, path: String, body: Int, callback: uploadCallblock) {
        let put = OSSPutObjectRequest()
        put.bucketName = "danjuan-lantuoa"
        put.objectKey = path
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let enclosurePath = cachePath! + ("/enclosure/") + name
        put.uploadingFileURL = URL(string: enclosurePath)!
        put.callbackParam = ["callbackUrl": "http://api.lantudev.danjuantaxi.com/api/callback/fileUpload", "callbackBody": "\(body)", "callbackBodyType": "application/json"]
        let putTask = self.client.putObject(put)
        
        putTask.continue({ (task) -> Any? in
            if task.error != nil {
                print(task.error.debugDescription)
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
    }
    
    /// 下载
    func download(url: String, result: @escaping ((Data?) -> ())) {
        
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
                print(getResult.downloadedData.count)
                result(getResult.downloadedData)
            } else {
                print(t.error.debugDescription)
                result(nil)
            }
            return nil
        })
        task.waitUntilFinished()
    }
    
}
