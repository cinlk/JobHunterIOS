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
