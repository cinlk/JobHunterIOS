//
//  tableModel.swift
//  internals
//
//  Created by ke.liang on 2018/3/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


import SQLite

// version 0.1
struct UserTable{
    
    static let user = Table("user")
    static let id = Expression<Int64>("id")
    static let account = Expression<String>("account")
    static let password = Expression<String>("password")
    // 开启自动登录
    static let auto = Expression<Bool>("auto")
    
    
    
    
}
