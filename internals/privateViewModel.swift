//
//  privateViewModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation



class privateViewMode{
    
    
    
    var mode:privateMode?
    
    static let shared = privateViewMode()

    private init(){}
    
    open func addCompany(name:String){
        if let res = mode?.backListComp?.contains(name), res == false{
            mode?.backListComp?.append(name)
        }
        return
    }
    
    open func removeCompanyBy(name:String){
        
        if  let index = mode?.backListComp?.index(of: name){
            mode?.backListComp?.remove(at: index)
        }
        
    }
    open func removeCompanyBy(index:Int){
        mode?.backListComp?.remove(at: index)
    }
    
    open func getCompanys() -> [String]{
        return mode?.backListComp ?? []
        
    }
    
    open func getCompanyCounts() -> Int{
        return mode?.backListComp?.count ?? 0
    }
    
    
    
    
}
