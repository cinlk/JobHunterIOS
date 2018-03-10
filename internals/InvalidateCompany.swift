//
//  InvalidateCompany.swift
//  internals
//
//  Created by ke.liang on 2018/2/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


class  privacyInfo{
    
    
    static let shared:privacyInfo =  privacyInfo.init()
    
    private var coms:[String]  = []
    private init() {
        coms.append("吊袜带挖")
        coms.append("dwd")
        coms.append("带我去的群无多")
    }
    
    open func  getCompanys()->[String]{
        return coms
    }
    
    open func addCompany(name:String){
        coms.append(name)
    }
    
    open func deleteCompany(index:Int){
        coms.remove(at: index)
    }
    
}
