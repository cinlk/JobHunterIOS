//
//  dropMenu.swift
//  internals
//
//  Created by ke.liang on 2017/9/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu



class internshipCondtion: YNDropDownView {
    
    var cond:internCondition!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
    }
    
    override func dropDownViewClosed() {
        print("closed")
    }
    
    override func dropDownViewOpened() {
        print("opened")
    }
    
    
    func initViews() {
        cond = internCondition(frame: self.frame)
        self.addSubview(cond)
        
    }
    
}





class  jobCatagory: YNDropDownView{
    
    
    var job:JobClasses?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func dropDownViewClosed() {
        print("\(self) closed")
    }
    
    override func dropDownViewOpened() {
        print("\(self)opened")
    }
    
    func initView(){
        job = JobClasses(frame: self.frame)
        self.addSubview(job!)
        
    }
}




class Citys : YNDropDownView{
    
    
    var view:CitysView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func dropDownViewClosed() {
        print("closed")
        
    }
    
    override func dropDownViewOpened() {
        print("opened")
    }
    
    func initView(){
        view = CitysView(frame: self.frame)
        // customer
        view.dataSource = ["热门城市":["全国","北京","上海","深圳","广州","杭州","成都","南京","武汉","西安","厦门","长沙","苏州","天津"],
                           "ABCDEF":["鞍山","沣轱","保定","北京","长春","成都","重庆","长沙","常熟","朝阳","常州","东莞","大连","东营","德州","佛州","福州"],
                           "GHIJ":["桂林","贵阳","广州","哈尔滨","合肥","呼和浩特","海口","杭州","惠州","湖州","金华","江门","济南","济宁",
                                   "嘉兴","江阴"],
                           "KLMN":["昆明","昆山","聊城","廊坊","丽水","洛阳","临泽","龙岩","连云港","兰州","柳州","绵阳","宁波","南昌","南京","南宁","南通"],
                           "OPQR":["青岛","秦皇岛","泉州","日照"],
                           "STUV":["上海","石家庄","汕头","绍兴","沈阳","三亚","深圳","苏州","天津","唐山","太原","台州"],
                           "WXYZ":["淮坊","武汉","芜湖","威海","乌木鲁齐","无锡","温州","西安","香港","厦门","西宁","邢台","徐州","银川","盐城","烟台","扬州","珠海","张家界","肇庆","中山","郑州"]
        ]
        
        view.indexs = ["热门城市","ABCDEF","GHIJ","KLMN","OPQR","STUV","WXYZ"]
        
        self.addSubview(view)
        
        
    }
    
}

