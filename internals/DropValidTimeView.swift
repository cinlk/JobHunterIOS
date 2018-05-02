//
//  DropValidTimeView.swift
//  internals
//
//  Created by ke.liang on 2018/4/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class DropValidTimeView: BaseSingleItemDropView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


extension DropValidTimeView{
    private func loadData(){
        // 从网络获取数据
        //
        datas =   ["过期","未过期"]
        
        
    }
}
