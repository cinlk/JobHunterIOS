//
//  DropItemIndustrySectorView.swift
//  internals
//
//  Created by ke.liang on 2018/4/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

import YNDropDownMenu


class DropItemIndustrySectorView: BaseSingleItemDropView {


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

extension DropItemIndustrySectorView{
    private func loadData(){
        // 从服务器获取数据 MARK
        if SingletoneClass.shared.selectedBusinessField.isEmpty{
            // TODO  获取数据
            
            return
        }
        datas =  SingletoneClass.shared.selectedBusinessField
        
        
        
    }
}
