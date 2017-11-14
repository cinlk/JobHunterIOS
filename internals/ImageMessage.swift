//
//  ImageMessage.swift
//  internals
//
//  Created by ke.liang on 2017/10/29.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation

class ImageBody:NSCoder{
    
    var image:NSData?
    var avatar:String?
    
    init(image:NSData, avatar:String){
        self.image = image
        self.avatar = avatar
    }
    
    
}
