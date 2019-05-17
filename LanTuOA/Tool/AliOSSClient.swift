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
        let endpoint = "http://oss-cn-shenzhen.aliyuncs.com/"
        let aa = UserInfo.share.securityToken
        let credential = OSSStsTokenCredentialProvider(accessKeyId: "LTAIT8Igueogcd8m", secretKeyId: "wsNt4r373rW7AbBbCP7cdGcOz1EpO2", securityToken: UserInfo.share.securityToken)
        client = OSSClient(endpoint: endpoint, credentialProvider: credential)
    }
    
    /// 上传图片
    func uploadImages(images: [UIImage], callback: uploadCallblock) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = images.count
        
        for image in images {
            let operation = BlockOperation {
                let put = OSSPutObjectRequest()
                put.bucketName = "danjuan-lantuoa"
                var imageName = "".randomStringWithLength(len: 8)
                let suffix = String(format: "-%zdx%zd.png", image.size.width, image.size.height)
                imageName = imageName + suffix
                put.objectKey = imageName
                
                let data = image.jpegData(compressionQuality: 0.5) ?? Data()
                put.uploadingData = data
                
                let putTask = self.client.putObject(put)
                putTask.waitUntilFinished()// 阻塞直到上传完成
                
                if putTask.error != nil { // 有一个没有上传成功 -> 停止线程 —> 返回false
                    queue.cancelAllOperations()
                    if callback != nil {
                        callback!(false)
                    }
                }
                if (image == images.last!) {
                    if callback != nil {
                        callback!(true)
                    }
                }
            }
            if queue.operations.count != 0 {
                operation.addDependency(queue.operations.last!)
            }
            queue.addOperation(operation)
        }
    }
    
    /// 下载
    func download(url: String, result: @escaping ((Data?) -> ())) {
        let request = OSSGetObjectRequest()
        request.bucketName = "danjuan-lantuoa.danjuanerp"
        request.objectKey = url
        
        let task = client.getObject(request)
        task.continue({(t) -> OSSTask<AnyObject>? in
            if t.error == nil {
                let getResult = t.result as! OSSGetObjectResult
                result(getResult.downloadedData)
            } else {
                print(t.error.debugDescription)
                result(nil)
            }
            return nil
        })
//        task.waitUntilFinished()
    }
    
}
