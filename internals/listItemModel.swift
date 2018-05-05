//
//  listItemModel.swift
//  internals
//
//  Created by ke.liang on 2018/5/3.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import ObjectMapper

struct ShareItem {
    
    var name:String?
    var image:String?
    
    var type:UMSocialPlatformType?
    var bubbles:Int?
    
    init(name:String?,image:String?, type:UMSocialPlatformType? = nil, bubbles:Int? = nil) {
        self.name = name
        self.image = image
        self.type = type
        self.bubbles = bubbles
    }
    
    
}



