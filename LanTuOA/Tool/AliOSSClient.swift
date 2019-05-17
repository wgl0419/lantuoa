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
    
//    private var client: OSSClient!
    
    /// 单例
    class var shared: AliOSSClient {
        return instance
    }
    
    override init() {
//        let endpoint = "oss-cn-shenzhen.aliyuncs.com"
//        let aa = UserInfo.share.securityToken
//        let credential = OSSStsTokenCredentialProvider(accessKeyId: "LTAIT8Igueogcd8m", secretKeyId: "wsNt4r373rW7AbBbCP7cdGcOz1EpO2", securityToken: "CAIS+gF1q6Ft5B2yfSjIr4iNKs/s3IlH8oS+Q1TYnWghWv5ihKvA2zz2IHhJeHBsB+oYv/kwmGlS7P0clqVoRoReREvCKM1565kPA+tirU6E6aKP9rUhpMCPOwr6UmzWvqL7Z+H+U6muGJOEYEzFkSle2KbzcS7YMXWuLZyOj+wMDL1VJH7aCwBLH9BLPABvhdYHPH/KT5aXPwXtn3DbATgD2GM+qxsmufjgmJTGskKE3AWikbBOnemrfMj4NfsLFYxkTtK40NZxcqf8yyNK43BIjvwu0fAdpWmd4IDAXAUIuU/dbfCz9tRpMBJia7IkFrReq/zxhWD1U35Df0icGoABFHQjF+yrEnhRak3BNFEM0vVTxv4jKt6o9nwo1G0YoKsOjS2LfJUxWFD8/iUSGgHNkyDV1i78AqaN298NGA2Sesa2Y+vC/6VU6DzdWAcmQx94/gh39bCsgUF3okEkWDvczGMOjQEXlYcXVUXzZM2zbsVuUwgfuRwDdZ3j6AixCTk=")
//        client = OSSClient(endpoint: endpoint, credentialProvider: credential)
    }
    
    /// 上传图片
    func uploadImages(images: [UIImage], callback: uploadCallblock) {
        let endpoint = "oss-cn-shenzhen.aliyuncs.com"
        let credential = OSSStsTokenCredentialProvider(accessKeyId: "LTAIT8Igueogcd8m", secretKeyId: "wsNt4r373rW7AbBbCP7cdGcOz1EpO2", securityToken: "CAIS+gF1q6Ft5B2yfSjIr4iNKs/s3IlH8oS+Q1TYnWghWv5ihKvA2zz2IHhJeHBsB+oYv/kwmGlS7P0clqVoRoReREvCKM1565kPA+tirU6E6aKP9rUhpMCPOwr6UmzWvqL7Z+H+U6muGJOEYEzFkSle2KbzcS7YMXWuLZyOj+wMDL1VJH7aCwBLH9BLPABvhdYHPH/KT5aXPwXtn3DbATgD2GM+qxsmufjgmJTGskKE3AWikbBOnemrfMj4NfsLFYxkTtK40NZxcqf8yyNK43BIjvwu0fAdpWmd4IDAXAUIuU/dbfCz9tRpMBJia7IkFrReq/zxhWD1U35Df0icGoABFHQjF+yrEnhRak3BNFEM0vVTxv4jKt6o9nwo1G0YoKsOjS2LfJUxWFD8/iUSGgHNkyDV1i78AqaN298NGA2Sesa2Y+vC/6VU6DzdWAcmQx94/gh39bCsgUF3okEkWDvczGMOjQEXlYcXVUXzZM2zbsVuUwgfuRwDdZ3j6AixCTk=")
        let client = OSSClient(endpoint: endpoint, credentialProvider: credential)
        
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
                
                let putTask = client.putObject(put)
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
        let endpoint = "oss-cn-shenzhen-internal.aliyuncs.com" // oss-cn-shenzhen.aliyuncs.com/
        let credential = OSSStsTokenCredentialProvider(accessKeyId: "LTAIT8Igueogcd8m", secretKeyId: "wsNt4r373rW7AbBbCP7cdGcOz1EpO2", securityToken: "CAIS+gF1q6Ft5B2yfSjIr4iNKs/s3IlH8oS+Q1TYnWghWv5ihKvA2zz2IHhJeHBsB+oYv/kwmGlS7P0clqVoRoReREvCKM1565kPA+tirU6E6aKP9rUhpMCPOwr6UmzWvqL7Z+H+U6muGJOEYEzFkSle2KbzcS7YMXWuLZyOj+wMDL1VJH7aCwBLH9BLPABvhdYHPH/KT5aXPwXtn3DbATgD2GM+qxsmufjgmJTGskKE3AWikbBOnemrfMj4NfsLFYxkTtK40NZxcqf8yyNK43BIjvwu0fAdpWmd4IDAXAUIuU/dbfCz9tRpMBJia7IkFrReq/zxhWD1U35Df0icGoABFHQjF+yrEnhRak3BNFEM0vVTxv4jKt6o9nwo1G0YoKsOjS2LfJUxWFD8/iUSGgHNkyDV1i78AqaN298NGA2Sesa2Y+vC/6VU6DzdWAcmQx94/gh39bCsgUF3okEkWDvczGMOjQEXlYcXVUXzZM2zbsVuUwgfuRwDdZ3j6AixCTk=")
        let client = OSSClient(endpoint: endpoint, credentialProvider: credential)
        
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
