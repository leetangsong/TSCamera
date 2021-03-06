//
//  DateExtensions.swift
//  TSKit_Example
//
//  Created by leetangsong on 2022/5/18.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
extension Date: TSKitCompatibleValue{}
extension Date: TSKitClassCompatibleValue{}


extension TSKitWrapper where Base == Date{
    /// 日期转字符串
    ///
    /// - Parameter format: 格式
    /// - Returns: String
    public func dateToString(with format: String) -> String {
        Date.ts.displayFormatter.dateFormat = format
        return Date.ts.displayFormatter.string(from: base)
    }
    
    ///一周的星期几
    public var weekday : Int {
        return  Date.ts.calendar.dateComponents([.weekday], from: base).weekday!
    }
    
    /// 获取当前日期的年
    public var year : Int {
        return Date.ts.calendar.dateComponents([.year], from: base).year!
    }
    /// 获取当前日期的月
    public var month : Int {
        
        return  Date.ts.calendar.dateComponents([.month], from: base).month!
    }
    /// 获取当前日期的日
    public var day : Int {
        
        return  Date.ts.calendar.dateComponents([.day], from: base).day!
    }
    /// 获取当前日期的小时
    public var hour : Int {
        
        return  Date.ts.calendar.dateComponents([.hour], from: base).hour!
    }
    /// 获取当前日期的分钟
    public var minute : Int {
        return  Date.ts.calendar.dateComponents([.minute], from: base).minute!
    }
    /// 获取当前日期的秒
    public var second : Int {
        return  Date.ts.calendar.dateComponents([.second], from: base).second!
    }
    /// 该月有多少天
    public var daysCountInMonth : Int {
        return Date.ts.daysInMonth(year: year, month: month)
    }
    /// 该年的第几周
    public var weekOfYear : Int{
        return Date.ts.calendar.dateComponents([.weekOfYear], from: base).weekOfYear!
    }
    /// 该月的第几周
    public var weekOfMonth : Int{
        return Date.ts.calendar.dateComponents([.weekOfMonth], from: base).weekOfMonth!
    }
    
    public var weeksOfYear : Int{
        return Date.ts.calendar.range(of: .weekOfYear, in: .year, for: base)!.count
    }
    /// 获取日期当前周 开始的日期
    
    public var startOfWeek : Date {
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = -base.ts.weekday+2
        if base.ts.weekday == 1 {
            componentsToSubtract.day = -6
        }
        let startOfWeek = Date.ts.calendar.date(byAdding: componentsToSubtract, to: base)
        return startOfWeek!
    }
    
    /// 获取日期当前周 结束的日期
    
    public var endOfWeek : Date {
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = -base.ts.weekday+2+6
        if base.ts.weekday == 1 {
            componentsToSubtract.day = 0
        }
        let endOfWeek = Date.ts.calendar.date(byAdding: componentsToSubtract, to: base)
        return endOfWeek!
    }
    
    
    
}


extension TSKitClassWrapper where Base == Date{
    fileprivate static let calendar = Calendar.init(identifier: .gregorian)
    fileprivate static let displayFormatter =  DateFormatter()
    /// 日期格式化
    ///
    /// - Parameters:
    ///   - from: 日期字符串
    ///   - format: 格式
    /// - Returns: Date
    public static func stringToDate (from: String , format: String) -> Date {
        Date.ts.displayFormatter.dateFormat = format;
        let date = Date.ts.displayFormatter.date(from: from)
        assert(date != nil,"格式不正确")
        return date!
    }
    
    /// 获取指定月的天数
    ///
    /// - Parameters:
    ///   - year: year
    ///   - month: month
    /// - Returns: return Int
    public static func daysInMonth (year: Int , month: Int) -> Int{
        return Date.ts.calendar.range(of: .day, in: .month, for: Date.ts.stringToDate(from: "\(year)-\(month)", format: "yyyy-MM"))!.count;
        
        
    }
    
    public static func daysDifferent (date1: Date , date2: Date, component: Set<Calendar.Component>) -> DateComponents {
        let temp1 = Date.ts.stringToDate(from: date1.ts.dateToString(with: "yyyy-MM-dd"), format: "yyyy-MM-dd")
        let temp2 = Date.ts.stringToDate(from: date2.ts.dateToString(with: "yyyy-MM-dd"), format: "yyyy-MM-dd")
        return Date.ts.calendar.dateComponents(component, from: temp1, to: temp2)
        
    }
    
    //CST时间字符串转日期
    public static func CSTTimeToDate (CST: String) -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale.init(identifier: "en_US")
        inputFormatter.dateFormat = "EEE MMM dd HH:mm:ss 'CST' yyyy"
        return inputFormatter.date(from: CST)
    }
    /// 根据周获取开始日期和结束日期
    ///
    /// - Parameters:
    ///   - week: 周数
    ///   - year: 年数
    /// - Returns: (开始时间,结束时间)
    public static func weekTimeBeginEnd(week: Int,year: Int) -> (startDate:Date,endDate:Date) {
        //week当中的一天
        let weekDate = Date.ts.stringToDate(from: "\(year)-01-01", format: "yyyy-MM-dd").addingTimeInterval(TimeInterval((week-1)*7*24*60*60))
        
        return (weekDate.ts.startOfWeek,weekDate.ts.endOfWeek)
    }
    
    /// 时间戳转换为时间格式字符串
    ///
    /// - Parameters:
    ///   - timeStamp: 时间戳
    ///   - formatter: 时间格式
    /// - Returns: (时间字符串)
    public static func dateFormatString(timeStamp: String,formatter: String) -> String{
        let  interval:TimeInterval = TimeInterval.init(timeStamp)!
        let date = Date.init(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter.count > 0 ? formatter : "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date as Date)
    }
    
    /// 时间戳转换为date类似
    ///
    /// - Parameters:
    ///   - timeStamp: 时间戳

    /// - Returns: (时间)
    public static func dateFromTimeStamp(timeStamp: String) -> Date{
        let  interval:TimeInterval = TimeInterval.init(timeStamp)!
        let date = Date.init(timeIntervalSince1970: interval)
        return date
    }
}


