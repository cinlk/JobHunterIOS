//
//  timeHelp.swift
//  internals
//
//  Created by ke.liang on 2018/5/28.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import SwiftDate


func meetingTalkTime(time: Date) -> String{
    
    
    let ctime = DateInRegion.init(time, region: GlobalConfig.regionRome)
    let dateFormat = DateFormatter()
    dateFormat.timeZone = GlobalConfig.regionRome.timeZone
    var timeStr = ""
    dateFormat.amSymbol = "上午"
    dateFormat.pmSymbol = "下午"
    dateFormat.weekdaySymbols = ["周天","周一","周二","周三","周四","周五","周六"]
    
    // 已过期
    if ctime.compare(.isInThePast){
        timeStr = "已过期"
    }
    // 今天(上午，下午)
    else if ctime.compare(.isToday){
        dateFormat.dateFormat = "HH:mm"
        timeStr = "今天 "
        timeStr += dateFormat.string(from: ctime.date)
        if ctime.hour < 12{
            timeStr += " 上午"
        }
        else if ctime.hour > 12 && ctime.hour < 18{
            timeStr += " 下午"
        }else{
            timeStr += " 晚上"
        }
        
    }
    
    //明天
    else if ctime.compare(.isTomorrow){
        timeStr = "明天 "
        dateFormat.dateFormat = "HH:mm"
        timeStr += dateFormat.string(from: ctime.date)
        
    }
    // 这周
    else if ctime.compare(.isThisWeek){
    
        dateFormat.dateFormat = "EEEE HH:mm"
        timeStr += dateFormat.string(from: ctime.date)
    }
    
    else if ctime.compare(.isThisYear){
        dateFormat.dateFormat = "MM-dd HH:mm"
        timeStr += dateFormat.string(from: ctime.date)
        
    }else  {
        dateFormat.dateFormat = "yy-MM-dd HH:mm"
        timeStr += dateFormat.string(from: ctime.date)
    }
    

    return timeStr
    
}




func personOnlineTime(date:Date) -> String{
    
    let dateFormat = DateFormatter()
    
    let currentTime = Date()
    
    let subtime = -date.timeIntervalSince(currentTime)
    let week = TimeInterval(60*68*24*7)
    let oneday = TimeInterval(60*60*24)
    let onehour = TimeInterval(60*60)
    if subtime >= week{
        dateFormat.dateFormat  = "yy-MM-dd"
        return dateFormat.string(from: date)
    }else if subtime < week && subtime >= oneday{
        let day  = Int(floor(subtime / oneday))
        return "\(day)天以前"
    }else if subtime < oneday && subtime > onehour{
        let hour =  Int(floor(subtime/onehour))
        return "\(hour)小时以前"
    }else{
        var minu = Int(floor(subtime/TimeInterval(60)))
        if minu == 0 {
            minu = 1
        }
        return "\(minu)分钟以前"
    }
}


func chatListTime(date:Date?) ->String?{
    
    guard let date = date  else {
        return nil
    }
    
    let now = DateInRegion()
    
    
    let dateInRome =  DateInRegion.init(date, region: GlobalConfig.regionRome)
    
    
    
    let year = now.year - dateInRome.year
    let day = now.day - dateInRome.day
    
    if year != 0 {
        return String.init(format: "%d年%d月%d日", dateInRome.year, dateInRome.month,dateInRome.day)
        
    }else if year == 0 {
        if day >= 2 {
            return String.init(format: "%d月%d日", dateInRome.month, dateInRome.day)
        }else if dateInRome.isYesterday{
            return "昨天"
        }else {
            return String.init(format: "%d:%02d", dateInRome.hour, dateInRome.minute)
        }
        
    }
    return ""
}


func showMonthAndDay(date: Date?) ->String?{
    guard let date = date  else {
        return nil
    }
    
    let dateRoom = DateInRegion.init(date, region: GlobalConfig.regionRome)
    
    if dateRoom.compare(.isThisYear){
        return String.init(format: "%d月%d日", dateRoom.month, dateRoom.day)

    }else{
        return String.init(format: "%d年%d月%d日", dateRoom.year, dateRoom.month,dateRoom.day)

    }
    
}

func showYearAndDayAndHour(date: Date?) ->String?{
    guard let date = date  else {
        return nil
    }
    
    let dateRoom = DateInRegion.init(date, region: GlobalConfig.regionRome)
    return String.init(format: "%d年%d月%d日 %d:%02d", dateRoom.year, dateRoom.month,dateRoom.day,
    dateRoom.hour, dateRoom.minute)
}
    
    
func showDayAndHour(date: Date?) -> String?{
    guard let date = date else {
        return nil
    }
    
    let dateRoom = DateInRegion.init(date, region: GlobalConfig.regionRome)
    
    if dateRoom.compare(.isThisYear){
        return String.init(format: "%d月%d日 %d:%02d", dateRoom.month, dateRoom.day, dateRoom.hour, dateRoom.minute)

    }else{
        return String.init(format: "%d年%d月%d日 %d:%02d", dateRoom.year, dateRoom.month, dateRoom.day, dateRoom.hour, dateRoom.minute)
    }
    
}
