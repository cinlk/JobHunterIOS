//
//  AddEventInCalender.swift
//  internals
//
//  Created by ke.liang on 2018/5/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import EventKit



public func  AddEventToCalendar(title: String, locate:String, description: String? = "", url:URL? ,startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
    DispatchQueue.global(qos: .background).async { () -> Void in
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                
                event.title = title
                event.location = locate
                event.url = url
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                
                let alarm = EKAlarm()
                // 提前2小时通知
                alarm.relativeOffset = -60.0*60*2
                event.addAlarm(alarm)
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
}
