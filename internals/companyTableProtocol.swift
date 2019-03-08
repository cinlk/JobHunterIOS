//
//  companyTableProtocol.swift
//  internals
//
//  Created by ke.liang on 2018/4/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation

protocol CompanySubTableScrollDelegate: class {
    
    func scrollUp(view:UITableView,height:CGFloat)
}
