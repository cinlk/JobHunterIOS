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
        let basicinfo = personalBasicalInfo(JSON: ["tx":"chrome","name":"lk","gender":"男",
                                               "city":"北京","degree":"专科","phone":"13718754627",
                                               "email":"dqwd@163.com","birthday":"1990-01"])
        if initialFirst == false{
            mode = ResumeMode(JSON: ["basicinfo":basicinfo?.toJSON(),"educationInfo":[],"internInfo":[],"skills":[],"projectInfo":[],
                                     "studentWorkInfo":[],"practiceInfo":[],"resumeOtherInfo":[],"estimate":selfEstimateModel(JSON: [:])?.toJSON()])
        //print(mode?.toJSON(),mode?.educationInfo.count)
        }
        initialFirst = true 
        
    }
    
    open func getCountBy(type: ResumeSubItems) -> Int{
        switch type {
        case .education:
            return mode?.educationInfo.count ?? 0
        case .works:
            return mode?.internInfo.count ?? 0
        case .skills:
            return mode?.skills.count ?? 0
        case .project:
            return mode?.projectInfo.count ?? 0
        case .schoolWork:
            return mode?.studentWorkInfo.count ?? 0
        case .practice:
            return mode?.practiceInfo.count ?? 0
        case .other:
            return mode?.resumeOtherInfo.count ?? 0
            
        default:
            return 0
        }
    }
    
    open func sortByEndTime(type: ResumeSubItems){
        
        let timeFormat = "yyyy-MM"
        guard  let mode = mode  else {
            return
        }
        switch type {
        case .education:
            guard  mode.educationInfo.count > 1  else { return }
            mode.educationInfo.sort { (p1, p2) -> Bool in
            
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
            }
        case .works:
            guard   mode.internInfo.count > 1 else { return }
            mode.internInfo.sort { (p1, p2) -> Bool in
            
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)

            }
            
        case .project:
            guard  mode.projectInfo.count > 1 else { return }
            mode.projectInfo.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
        
        case .schoolWork:
            guard mode.studentWorkInfo.count > 1 else { return }
            mode.studentWorkInfo.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
        case .practice:
            guard  mode.practiceInfo.count > 1 else { return }
            mode.practiceInfo.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
        default:
            break
        }
    }
    
    
}
