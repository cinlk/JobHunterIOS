//
//  localData.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//


import UIKit

fileprivate let campus = "campus"
fileprivate let intern = "intern"

class localData: NSObject {
    var pref: UserDefaults!
    
    open static let shared: localData = localData()
    
    public override init() {
        pref = UserDefaults.standard
        
    }
    
    // 实习 或社招订阅 数据
    /*
     *   {"社招":[],"实习":[]}
    */
    open func  setsubscribe(value: Dictionary<String,[Dictionary<String,String>]>){
        pref.set(value, forKey: "subscrible")
    }
    open func clearSubscribeData(){
        pref.removeObject(forKey: "subscrible")
    }
    
    open func getSubscribeByType(type:String)->[Dictionary<String,String>]?{
        
        guard let con =  pref.object(forKey: "subscrible") as? Dictionary<String,[Dictionary<String,String>]>  else {
            return nil
        }
        return con[type]
        
    }
    
    open func deleteSubscribeByIndex(type:String,_ index:Int){
        guard var con =  pref.object(forKey: "subscrible") as?  Dictionary<String,[Dictionary<String,String>]> else {
            return
        }
        con[type]?.remove(at: index)
        pref.set(con, forKey: "subscrible")
    }
    
    open func appendSubscribe(type:String, value: Dictionary<String,String>){
        
        var tmp:Dictionary<String,[Dictionary<String,String>]>  = [campus:[],intern:[]]
        
        if let   con =  pref.object(forKey: "subscrible") as?  Dictionary<String,[Dictionary<String,String>]>{
            print(con)
            tmp = con
        }
       
        
        tmp[type]?.append(value)
        pref.set(tmp, forKey: "subscrible")
       

    }
    open func updateSubscribe(type:String, value:Dictionary<String,String>,index:Int){
        
        guard var con =  pref.object(forKey: "subscrible") as?  Dictionary<String,[Dictionary<String,String>]> else {
            return
        }
      
        con[type]?.remove(at: index)
        con[type]?.insert(value, at: index)
        pref.set(con, forKey: "subscrible")
        
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
    open func deleteSearcHistories(item: String){
         guard var histories = pref.object(forKey: "histories") as? [String] else { return }
         if let index = histories.index(of: item){
            histories.remove(at: index)
            pref.set(histories, forKey: "histories")
        }
        
        
    }
    open func removeAllHistory(){
        guard var histories = pref.object(forKey: "histories") as? [String] else { return }
        histories.removeAll()
        pref.set(histories, forKey: "histories")
    }
    open func appendSearchHistories(value: String) {
        var histories = [String]()
        if let _histories = pref.object(forKey: "histories") as? [String] {
            histories = _histories
        }
        if !histories.contains(value){
            histories.append(value)
        }
        
        pref.set(histories, forKey: "histories")
    }
    
    open func getSearchHistories() -> [String]? {
        guard let histories = pref.object(forKey: "histories") as? [String] else { return nil }
        return histories
        
    }
    
    
}




