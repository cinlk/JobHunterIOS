//
//  searchJobModel.swift
//  internals
//
//  Created by ke.liang on 2017/12/16.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxDataSources

struct searchJobSection {
     var items: [Item]
}

extension searchJobSection:SectionModelType {
    
    typealias Item =  CompuseRecruiteJobs
    
     init(original: searchJobSection, items: [searchJobSection.Item]) {
        self = original
        self.items = items
        
    }
    


    
}
