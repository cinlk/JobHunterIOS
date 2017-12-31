//
//  extension+uiview.swift
//  internals
//
//  Created by ke.liang on 2017/12/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

extension UIView{
    
    
    // 一行3个元素，进行排列
    class func RecordHeaderView(tags:[String]) -> UIView{
        
        let view = UIView.init()
        view.backgroundColor = UIColor.lightGray
        var height = 0
        let tag = UILabel.init()
        tag.text = "热门搜索"
        tag.textColor = UIColor.gray
        tag.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(tag)
        _  = tag.sd_layout().leftSpaceToView(view,10)?.topSpaceToView(view,10)?.widthIs(100)?.heightIs(30)
        
        let sub = UIView.init()
        sub.tag = 1 
        view.addSubview(sub)
        _ = sub.sd_layout().topSpaceToView(tag,0)?.leftSpaceToView(view,10)?.rightSpaceToView(view,10)?.bottomSpaceToView(view,10)
        
        let n1 = tags.count / 3
        var res = tags.count % 3
        var row = 0
        height = (n1+res) * 50
        var x = 0
        var y = 0
        for (index, item) in tags.enumerated(){
            
            if (index %  3 == 0  && index != 0) {
                row += 1
            }
            let btn = UIButton.init(type: .custom)
            btn.setTitle(item, for: .normal)
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(UIColor.blue, for: .normal)
            //btn.addTarget(self, action: #selector(chooseTag), for: .touchUpInside)
            res = index  % 3
            switch res{
            case 0:
                x = 20
                
            case 1:
                x = 130
                
            case 2:
                x = 240
                
            default:
                break
            }
            y = row*35 + 5
            
            btn.frame = CGRect.init(x: x, y: y, width: 100, height: 30)
            
            sub.addSubview(btn)
        }
        
        view.frame = CGRect.init(x: 0, y: 0, width: Int(ScreenW), height:  height + 10)
        return view
        
    }
}
