//
//  CloudDocument.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/31.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class CloudDocument: NSObject {

    /// icloud根目录
    func getiCloudDocumentURL() -> URL? {
        if let url = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
            return url.appendingPathComponent("Documents") as URL
        }
        return nil
    }
    
    
}
