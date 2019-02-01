//
//  extension+uidevice.swift
//  internals
//
//  Created by ke.liang on 2019/1/20.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation


extension UIDevice{
    

    public func isX() -> Bool{
        if UIScreen.main.bounds.height == 812{
            return true
            
        }
        return false 
    }
}
