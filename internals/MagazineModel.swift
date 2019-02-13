//
//  MagazineModel.swift
//  internals
//
//  Created by ke.liang on 2018/5/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper
import RxDataSources

class MagazineModel: NSObject, Mappable {

    
    var title:String?
    var author:String?
    var time:Date?
    var timeStr:String{
        get{
            guard let time = self.time else { return "" }
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateFormat = "yyyy-MM-dd"
            
            let str = dateFormat.string(from: time)
            return str
        }
    }
    var icon:String = "default"
    
    // 文章web链接
    var link:String?
    
    
    required init?(map: Map) {
//        if map.JSON["title"] == nil || map.JSON["author"] == nil || map.JSON["time"] == nil{
//            return nil
//        }
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        author <- map["author"]
        time <- (map["time"], DateTransform())
        icon <- map["icon"]
        link <- map["link"]
        
        
    }
}


//

struct  MagazineModelSection {
    
    var items: [Item]
    
    
}

extension MagazineModelSection: SectionModelType{
    
    
        
    typealias Item = MagazineModel
    
    init(original: MagazineModelSection, items: [Item]) {
        self = original
        self.items = items
    }
}
