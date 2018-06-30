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
    
    let dateFormat = DateFormatter()
    //dateFormat.locale = Locale.current
    // 今天起始时间
    let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    
    
    var timeStr = ""
    
    let elapsedTimeSeconds = time.timeIntervalSince(startDate!)
    
    dateFormat.pmSymbol = "下午"
    dateFormat.amSymbol = "上午"

    dateFormat.weekdaySymbols = ["周天","周一","周二","周三","周四","周五","周六"]
    let secondInDays:TimeInterval = 60 * 60 * 24
    
    // 明天
    if  elapsedTimeSeconds > secondInDays && elapsedTimeSeconds < 2*secondInDays{
       
        
        dateFormat.dateFormat = "HH:mm"
        timeStr = "明天 " +  dateFormat.string(from: time)
    }else if elapsedTimeSeconds > 2*secondInDays && elapsedTimeSeconds < 7*secondInDays{
        dateFormat.dateFormat = "EEEE HH:mm"
        timeStr = dateFormat.string(from: time)
        
    }else if elapsedTimeSeconds >= 7*secondInDays{
        
        dateFormat.dateFormat =   time.year  ==  startDate!.year ? "MM-dd HH:mm" : "yy-MM-dd HH:mm"
        timeStr = dateFormat.string(from: time)
    }
    else if elapsedTimeSeconds < secondInDays && elapsedTimeSeconds >= 0{
        dateFormat.dateFormat = "HH:mm"
        timeStr = "今天 " + dateFormat.string(from: time)
    }else if elapsedTimeSeconds < 0{
        dateFormat.dateFormat =   time.year  ==  startDate!.year ? "MM-dd HH:mm" : "yy-MM-dd HH:mm"
        timeStr = "已经过期 " + dateFormat.string(from: time)
    }
    
    //print(time.timeIntervalSince1970,elapsedTimeSeconds)
    var postStr = ""
    if time.hour >= 0 && time.hour < 12{
        postStr = " 上午"
    } else if time.hour >= 12 && time.hour < 18{
        postStr = " 下午"
    }else{
        postStr = " 晚上"
    }
    return timeStr + postStr
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
    let dateInRome = DateInRegion(absoluteDate: date)
    
    
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
    
    let now = DateInRegion()
    let dateRoom = DateInRegion(absoluteDate: date)
    let year = now.year - dateRoom.year
    if year != 0{
        return String.init(format: "%d年%d月%d日", dateRoom.year, dateRoom.month,dateRoom.day)
        
    }else{
        return String.init(format: "%d月%d日", dateRoom.month, dateRoom.day)
    }
    
}
    
    
func forumArticleDate(date: Date?) -> String?{
    guard let date = date else {
        return nil
    }
    
    let now = DateInRegion()
    let dateRoom = DateInRegion(absoluteDate: date)
    
    let year = now.year - dateRoom.year
    if year != 0 {
        return String.init(format: "%d年%d月%d日 %d:%02d", dateRoom.year, dateRoom.month, dateRoom.day, dateRoom.hour,
                                        dateRoom.minute)
    }else{
        return String.init(format: "%d月%d日 %d:%02d", dateRoom.month, dateRoom.day, dateRoom.hour, dateRoom.minute)
    }
    
}
