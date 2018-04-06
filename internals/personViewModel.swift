//
//  personViewModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


class  personModelManager {
    
    
    static let shared: personModelManager = personModelManager()
    
    open var  mode:ResumeMode?
    
    //test
    var initialFirst = false
    private init(){}
    
    
    open func initialData(){
        // 1
        let basicinfo = personBasicInfo(JSON: ["tx":"chrome","name":"lk","gender":"男",
                                               "city":"北京","degree":"专科","phone":"13718754627",
                                               "email":"dqwd@163.com","birthday":"1990-01"])
        if initialFirst == false{
            mode = ResumeMode(JSON: ["basicinfo":basicinfo?.toJSON(),"educationInfo":[],"internInfo":[],"skills":[],
                                 "estimate":""])
        //print(mode?.toJSON(),mode?.educationInfo.count)
        }
        initialFirst = true 
        
    }
    
    open func getCountBy(type: resumeViewType) -> Int{
        switch type {
        case .education:
            return mode?.educationInfo.count ?? 0
        case .intern:
            return mode?.internInfo.count ?? 0
        case .skill:
            return mode?.skills.count ?? 0
        default:
            return 0
        }
    }
    
    open func sortByEndTime(type: resumeViewType){
        switch type {
        case .education:
            guard var items = mode?.educationInfo else { return }
            items.sort { (p1, p2) -> Bool in
               return p1.endTime > p2.endTime
            }
            mode?.educationInfo = items
        case .intern:
            guard var items = mode?.internInfo else { return }
            items.sort { (p1, p2) -> Bool in
              return  p1.endTime > p2.endTime
            }
            
            mode?.internInfo = items
        default:
            break
        }
    }
}
