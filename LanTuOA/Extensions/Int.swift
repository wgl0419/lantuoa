//
//  Int.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/8.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

extension Int {
    
    /// 金额添加 ,
    func getMoneyStr() -> String {
        var temp = "\(self)"
        let count = temp.count
        let sepNum = count / 3
        guard sepNum >= 1 else {
            return temp
        }
        for i in 1...sepNum {
            let index = count - 3 * i
            guard index != 0 else {
                break
            }
            temp.insert(",", at: temp.index(temp.startIndex, offsetBy: index))
        }
        return temp
    }
}

extension Float {
    
    /// 金额添加 ,
    func getMoneyStr() -> String {
        let integer = Int(floorf(self))
        let abbreviationStr = String(format: "（%.2f万）", self / 10000)
        let integerStr = integer.getMoneyStr()
        let surplus = self - Float(integer)
        if surplus == 0 {
            return integerStr + "元 " + abbreviationStr
        } else {
            var surplusStr = String(format: "%.2f", surplus)
            surplusStr.remove(at: surplusStr.startIndex) // 去掉0
            let moneyStr = integerStr + surplusStr + "元 " + abbreviationStr
            return moneyStr
        }
    }
}
