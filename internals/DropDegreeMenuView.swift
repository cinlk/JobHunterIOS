//
//  DropDegreeMenuView.swift
//  internals
//
//  Created by ke.liang on 2018/6/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class DropDegreeMenuView: BaseSingleItemDropView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    

}

extension DropDegreeMenuView{
    
    private func loadData(){
        datas = ["不限","大专","本科","硕士","博士"]
    }
}
