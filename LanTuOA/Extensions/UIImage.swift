//
//  UIImage.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 根据颜色绘制一张图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 该颜色的图片
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 获取限制图片大小的图片数据
    ///
    /// - Parameters:
    ///   - sourceImage: 原始图片
    ///   - maxImageSize: 图片的Size缩小比例
    ///   - maxSize: 接口最大接受大小
    /// - Returns: 限制内的图片数据
    class func reSizeImageData(sourceImage : UIImage, maxImageSize : CGFloat , maxSize : CGFloat) -> NSData {
        // 图片的Size
        var newSize = CGSize(width: sourceImage.size.width, height: sourceImage.size.height)
        print(newSize)
        
        // 宽高 除 最大尺寸
        let tempHeight = newSize.height / maxImageSize
        let tempWidth = newSize.width / maxImageSize
        // 竖着拍的时候
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
            // 横着拍
        }else if (tempHeight > 1.0 && tempWidth < tempHeight){
            newSize = CGSize(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        }
        
        // 确定好尺寸 （draw 到画布）
        UIGraphicsBeginImageContext(newSize)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 画完开始计算图片的大小
        var imageData = newimage!.jpegData(compressionQuality: 1.0)! as NSData
        var sizeOriginKB = CGFloat(imageData.length) / 1024.0
        // 压缩系数
        var resizeRate = 0.9
        // 接口最大接受大小
        while sizeOriginKB > maxSize && resizeRate > 0.1 {
            imageData = newimage!.jpegData(compressionQuality: CGFloat(resizeRate))! as NSData
            sizeOriginKB = CGFloat(imageData.length) / 1024.0
            resizeRate -= 0.1
        }
        return imageData
    }
}
