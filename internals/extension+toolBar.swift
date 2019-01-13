//
//  extension+toolBar.swift
//  internals
//
//  Created by ke.liang on 2018/3/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


extension UIToolbar{
    
    // keyboard toolbar
    class func NumberkeyBoardDone(title:String,view:UIView?, selector:Selector)->UIToolbar{
        
        let toolBar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 35))
        toolBar.backgroundColor = UIColor.gray
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtn = UIBarButtonItem(title: title, style: .plain, target: view, action: selector)
        toolBar.items = [spaceBtn, barBtn]
        toolBar.sizeToFit()
        return toolBar
    }
    
    class func NumberkeyBoardDone(title:String,vc:UIViewController, selector:Selector)->UIToolbar{
        
        let toolBar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 35))
        toolBar.backgroundColor = UIColor.gray
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtn = UIBarButtonItem(title: title, style: .plain, target: vc, action: selector)
        toolBar.items = [spaceBtn, barBtn]
        toolBar.sizeToFit()
        return toolBar
    }
  

}
