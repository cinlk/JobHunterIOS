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
        datas = ["健康医疗","生活服务","旅游","金融","信息安全","网络招聘","互联网","IT软件","媒体","公共会展","机械制造","游戏","教育培训","其他"]
   
        
    }
}
