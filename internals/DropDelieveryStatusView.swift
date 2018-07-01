//
//  DropDelieveryStatusView.swift
//  internals
//
//  Created by ke.liang on 2018/5/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class DropDelieveryStatusView: BaseSingleItemDropView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}

extension DropDelieveryStatusView{
    private func loadData(){
        datas =  [ResumeDeliveryStatus.all.describe, ResumeDeliveryStatus.delivery.describe, ResumeDeliveryStatus.read.describe,ResumeDeliveryStatus.test.describe, ResumeDeliveryStatus.interview.describe,ResumeDeliveryStatus.offer.describe, ResumeDeliveryStatus.reject.describe]
        
    }

}
