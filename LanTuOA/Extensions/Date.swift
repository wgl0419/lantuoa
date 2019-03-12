//
//  Date.swift
//  DanjuanPassenger
//
//  Created by HYH on 2018/7/24.
//  Copyright © 2018年 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

extension Date {
    
    /// 距当前有几秒
    var second: Int {
        let dateComponent = Calendar.current.dateComponents([.second], from: self, to: Date())
        return dateComponent.second!
    }
    
    /// 距当前有几分钟
    var minute: Int {
        let dateComponent = Calendar.current.dateComponents([.minute], from: self, to: Date())
        return dateComponent.minute!
    }
    
    /// 距当前有几小时
    var hour: Int {
        let dateComponent = Calendar.current.dateComponents([.hour], from: self, to: Date())
        return dateComponent.hour!
    }
    
    /// 距当前有几小时
    var day: Int {
        let dateComponent = Calendar.current.dateComponents([.day], from: self, to: Date())
        return dateComponent.day!
    }
    
    /// 是否是今天
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// 是否是昨天
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// 是否是明天
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// 是否是今年
    var isYear: Bool {
        let nowComponent = Calendar.current.dateComponents([.year], from: Date())
        let component = Calendar.current.dateComponents([.year], from: self)
        return (nowComponent.year == component.year)
    }
    
    /// 一天时间（时 + 分）
    func dayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: self)
    }
    
    /// 月份（月日 + 时分）
    func monthTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM-dd HH:mm"
        return format.string(from: self)
    }
    
    /// 年份时间（年月日 + 时分）
    func yearTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        return format.string(from: self)
    }
    
    /// 自定义格式时间
    func customTimeStr(customStr: String) -> String {
        let format = DateFormatter()
        format.dateFormat = customStr
        return format.string(from: self)
    }
    
    /// 时间戳转换过去的时间（用于显示评论时间之类）
    func getEverTimeString() -> String {
        if isToday {
            if minute < 5 {
                return "刚刚"
            } else if hour < 1 {
                return "\(minute)分钟之前"
            } else {
                return "\(hour)小时之前"
            }
        } else if isYesterday {
            return "昨天 \(self.dayTimeStr())"
        } else if isYear {
            return monthTimeStr()
        } else {
            return yearTimeStr()
        }
    }
    
    /// 时间戳转换未来的时间（用于预约时间）
    func getFutureTimeString() -> String {
        if isTomorrow {
            return "明天 \(self.dayTimeStr())"
        } else if Calendar.current.isDateInTomorrow(dateBySubtractingDays(1)) {
            return "后天 \(self.dayTimeStr())"
        } else {
            return self.monthTimeStr()
        }
    }
    
    /// 时间戳转换星座
    func getConstellation() -> String {
        let component = Calendar.current.dateComponents([.day, .month], from: self)
        let allConstellationStr = "摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座" as NSString
        let formatStr = "102123444543" as NSString
        
        let rangeInt: Int = (component.day! < Int(formatStr.substring(with: NSRange(location: component.month! - 1, length: 1)))!  - (-19)) ? 1 : 0
        let locationInt: Int = component.month! * 3 - rangeInt * 3
        let constellationStr = String(format: "%@", allConstellationStr.substring(with: NSRange(location: locationInt, length: 3)))
        
        return constellationStr
    }
    
    /// 几分钟钱的Date
    func dateBySubtractingMinutes(_ minutes: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.minute = (minutes * -1)
        return (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /// 几分钟后的Date
    func dateByAddingMinutes(_ minutes: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.minute = minutes
        return (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /// 几天前的Date
    func dateBySubtractingDays(_ days: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.day = (days * -1)
        return (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /// 几天后的Date
    func dateByAddingDays(_ days: Int) -> Date {
        var dateComp = DateComponents()
        dateComp.day = days
        return (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
}
