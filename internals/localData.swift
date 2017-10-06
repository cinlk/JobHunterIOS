//
//  localData.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//


import UIKit

class localData: NSObject {
    var pref: UserDefaults!
    
    open static let shared: localData = localData()
    
    public override init() {
        pref = UserDefaults.standard
        
    }
    
    // 实习条件 数据
    open func  setshixiCondtion(value: [Dictionary<String,String>]){
        pref.set(value, forKey: "shixicondition")
    }
    
    open func getshixiCondtion()->[Dictionary<String,String>]?{
        guard let con =  pref.object(forKey: "shixicondition") as? [Dictionary<String,String>]  else {
            return nil
        }
        return con
    }
    
    open func deleteShixiCondition(index:Int){
        guard var con =  pref.object(forKey: "shixicondition") as?  [Dictionary<String,String>] else {
            return
        }
        con.remove(at: index)
        pref.set(con, forKey: "shixicondition")
    }
    
    open func appendShixiCondition(value: Dictionary<String,String>){
        var condtion = [Dictionary<String,String>]()
        if let con =  pref.object(forKey: "shixicondition") as?  [Dictionary<String,String>]{
            condtion  = con
        }
        condtion.append(value)
        pref.set(condtion, forKey: "shixicondition")

    }
    open func updateShixiCondition(value:Dictionary<String,String>,index:Int){
        var con  = pref.object(forKey: "shixicondition") as! [Dictionary<String,String>]
        con.remove(at: index)
        con.insert(value, at: index)
        pref.set(con, forKey: "shixicondition")
        
    }
    
    // 社招条件 数据
    
    open func  setshezhaoCondtion(value: [Dictionary<String,String>]){
        pref.set(value, forKey: "shezhaocondition")
    }
    
    open func getshezhaoCondtion()->[Dictionary<String,String>]?{
        guard let con =  pref.object(forKey: "shezhaocondition") as? [Dictionary<String,String>]  else {
            return nil
        }
        return con
    }
    
    open func deleteshezhaoCondition(index:Int){
        guard var con =  pref.object(forKey: "shezhaocondition") as?  [Dictionary<String,String>] else {
            return
        }
        con.remove(at: index)
        pref.set(con, forKey: "shezhaocondition")
    }
    
    open func appendshezhaoCondition(value: Dictionary<String,String>){
        var condtion = [Dictionary<String,String>]()
        if let con =  pref.object(forKey: "shezhaocondition") as?  [Dictionary<String,String>]{
            condtion  = con
        }
        condtion.append(value)
        pref.set(condtion, forKey: "shezhaocondition")
        
    }
    
    open func updateshezhaoCondition(value:Dictionary<String,String>,index:Int){
        var con  = pref.object(forKey: "shezhaocondition") as! [Dictionary<String,String>]
        con.remove(at: index)
        con.insert(value, at: index)
        pref.set(con, forKey: "shezhaocondition")
        
    }
    
    
    ///
    open func setCategories(value: [String]) {
        pref.set(value, forKey: "categories")
    }
    
    open func getCategories() -> [String]? {
        guard let categories = pref.object(forKey: "categories") as? [String] else { return nil }
        return categories
    }
    
    open func setSearchHistories(value: [String]) {
        pref.set(value, forKey: "histories")
    }
    
    open func deleteSearchHistories(index: Int) {
        guard var histories = pref.object(forKey: "histories") as? [String] else { return }
        histories.remove(at: index)
        
        pref.set(histories, forKey: "histories")
    }
    
    open func appendSearchHistories(value: String) {
        var histories = [String]()
        if let _histories = pref.object(forKey: "histories") as? [String] {
            histories = _histories
        }
        histories.append(value)
        
        pref.set(histories, forKey: "histories")
    }
    
    open func getSearchHistories() -> [String]? {
        guard let histories = pref.object(forKey: "histories") as? [String] else { return nil }
        return histories
    }
    
    
}



