//
//  shareView.swift
//  internals
//
//  Created by ke.liang on 2017/9/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate var ROWNUMBERS = 1
fileprivate let COLUME = 4

class shareView: UIView {


    var images:[String] = ["qq","sina","wechat","link","chrome","car","",""]
    private var showItems:[showitem] = [showitem.init(name: "qq", image: "qq", bubbles: nil),
                                        showitem.init(name: "sina", image: "sina", bubbles: nil),
                                        showitem.init(name: "wechat", image: "wechat", bubbles: nil),
                                        showitem.init(name: "link", image: "link", bubbles: nil),
                                        showitem.init(name: "chrome", image: "chrome", bubbles: nil),
                                        showitem.init(name: "car", image: "car", bubbles: nil),
                                        showitem.init(name: "", image: "", bubbles: nil),
                                        showitem.init(name: "", image: "", bubbles: nil)]
    //
    var sharedata:String?
    
    
    lazy var stackview:UIStackView = {
       let sk = UIStackView.init()
        sk.axis = .vertical
        sk.alignment = UIStackViewAlignment.fill
        sk.distribution = .fillEqually
        sk.spacing = 10
        return sk
    }()
    
    // 存储分享的btn
    var  itemButtons:[UIButton]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        itemButtons = []
        self.backgroundColor = UIColor.white
        self.addSubview(stackview)
        // MARK  替换 collectionView
        //buildStackItemView(items: showItems, ItemRowNumbers: COLUME, mainStack: stackview, itemButtons: &itemButtons)
        _ = stackview.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.topEqualToView(self)
        

    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


