//
//  DropCompanyPropertyView.swift
//  internals
//
//  Created by ke.liang on 2018/4/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class DropCompanyPropertyView: BaseSingleItemDropView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

extension DropCompanyPropertyView{
    private func loadData(){
        // 从网络获取数据
        //
        if SingletoneClass.shared.selectedCompanyType.isEmpty{
            // TODO
            return
        }
        datas =   SingletoneClass.shared.selectedCompanyType
        
    }
}
