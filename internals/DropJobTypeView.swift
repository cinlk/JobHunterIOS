//
//  DropJobTypeView.swift
//  internals
//
//  Created by ke.liang on 2018/5/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class DropJobTypeView: BaseSingleItemDropView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}

extension DropJobTypeView{
    private func loadData(){
        datas =   [jobType.all.describe, jobType.graduate.describe, jobType.intern.describe, jobType.onlineApply.describe]
        
    }

}
