//
//  BaseTableView.swift
//  internals
//
//  Created by ke.liang on 2018/7/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



//extension BaseCellprotocal{
//     func identity()->String{
//        return
//    }
//}


class BaseTableView<M>: UITableView {

    
    
    internal var mode:M!
    
  
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        isScrollEnabled = false
        tableFooterView = UIView.init()
        backgroundColor = UIColor.viewBackColor()
        //delegate = self
        //dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setHeaderView(data:Any?){
    
    }
    
    internal func setDelegate(){
        fatalError("not implement")
    }
    
}


extension BaseTableView{
    
   
    
}



