//
//  enum.swift
//  internals
//
//  Created by ke.liang on 2019/2/9.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation


// 刷新状态
enum PageRefreshStatus{
    case none
    case beginHeaderRefrsh
    case endHeaderRefresh
    case beginFooterRefresh
    case endFooterRefresh
    case NoMoreData
    case end
    // MARK 需要细化错误类型？
    case error(err:Error)
    
}

