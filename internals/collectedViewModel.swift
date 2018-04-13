//
//  collectedViewModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation



class JobManager{
    
    enum jobType {
        case compus
        case intern
        case company
        case none
    }
    
    static let shared:JobManager = JobManager.init()
    private init(){}
    
    
    //TODO  合并 实习和社招被收藏的job 条目 ？？
    private var collectedJobs:[CompuseRecruiteJobs] = []
    private var collectedInternJobs:[InternshipJobs] = []
    
    // 收藏的公司信息
    private var collectedCompanys:[comapnyInfo] = []
    
    open func  addCollectedItem(item:CompuseRecruiteJobs){
        if collectedJobs.contains(item){
            return
        }
        
        collectedJobs.append(item)
    }
    
    open func clearAll(){
        self.collectedJobs.removeAll()
        self.collectedInternJobs.removeAll()
        self.collectedCompanys.removeAll()
        
    }
    open func removeCollectedByIndex(type:jobType,row:[Int]){
        switch type {
        case .compus:
            
            self.collectedJobs.remove(indexes: row)
        case .company:
            self.collectedCompanys.remove(indexes: row)
        default:
            break
        }
    }
    
    open func removeCollectedItem(item:CompuseRecruiteJobs){
        if let index =   collectedJobs.index(of: item){
            collectedJobs.remove(at: index)
        }
    }
    
    open func addCompanyItem(item: comapnyInfo){
        if collectedCompanys.contains(item){
            return
        }
        
        collectedCompanys.append(item)
    }
    
    open func removeCollectedCompany(item: comapnyInfo){
        if let index = collectedCompanys.index(of: item){
            collectedCompanys.remove(at: index)
        }
        
    }
    
    open func getCollections(type:jobType)->[Any]{
        switch type {
            
        case .compus:
            return collectedJobs
        case .intern:
            return collectedInternJobs
        case .company:
            return collectedCompanys
        default:
            return [Int]()
        }
    }
    
}
