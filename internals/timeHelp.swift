//
//  timeHelp.swift
//  internals
//
//  Created by ke.liang on 2018/5/28.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation

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
        dateFormat.dateFormat = "h:mm a"
        timeStr = "明天 " +  dateFormat.string(from: time)
    }else if elapsedTimeSeconds > 2*secondInDays && elapsedTimeSeconds < 7*secondInDays{
        dateFormat.dateFormat = "EEEE h:mm a"
        timeStr = dateFormat.string(from: time)
        
    }else if elapsedTimeSeconds >= 7*secondInDays{
        dateFormat.dateFormat = "yyy-MM-dd"
        timeStr = dateFormat.string(from: time)
    }
    else if elapsedTimeSeconds < secondInDays && elapsedTimeSeconds >= 0{
        dateFormat.dateFormat = "h:mm:a"
        timeStr = "今天 " + dateFormat.string(from: time)
    }else if elapsedTimeSeconds < 0{
        dateFormat.dateFormat = "yyy-MM-dd"
        timeStr = "已经过期 " + dateFormat.string(from: time)
    }
    
    //print(time.timeIntervalSince1970,elapsedTimeSeconds)
    
    return timeStr
}


