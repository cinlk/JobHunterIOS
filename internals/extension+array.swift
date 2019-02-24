//
//  extension+array.swift
//  internals
//
//  Created by ke.liang on 2018/2/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation

// 批量删除元素，从尾部开始逐渐删除
extension Array where Element: Equatable{
    
    mutating func remove(indexes:[Int]){
        var newindex = indexes.sorted { (x, y) -> Bool in
            return x > y
        }
        
        newindex.forEach { (i) in
            self.remove(at: i)
        }
        newindex.removeAll()
    }
}

 

