//
//  ConfigDropItemView.swift
//  internals
//
//  Created by ke.liang on 2018/4/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import YNDropDownMenu


public func configDropMenu(items: [YNDropDownView], titles:[String], height:CGFloat, originY:CGFloat = 0 ) -> YNDropDownMenu{
    
    
    let items:[YNDropDownView] = items
    
    
    let dropDownMenu = YNDropDownMenu(frame: CGRect(x:0,y:originY,width:GlobalConfig.ScreenW,height:height) , dropDownViews: items, dropDownViewTitles: titles)
    
    var images:[UIImage] = []
    titles.forEach { (t) in
        images.append(#imageLiteral(resourceName: "arrow_nor"))
    }
    //dropDownMenu.isHidden = true
     // 被选中iamge 方向向下，程序会自动翻转iamge
    dropDownMenu.setImageWhens(normal: images, selectedTintColor: UIColor.blue, disabledTintColor: UIColor.gray)
    dropDownMenu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
    dropDownMenu.setLabelFontWhen(normal: .systemFont(ofSize: 12), selected: .boldSystemFont(ofSize: 12), disabled: .systemFont(ofSize: 12))

    // 禁止回弹效果
    dropDownMenu.hideMenuSpringWithDamping = 1
    dropDownMenu.showMenuSpringWithDamping = 1

    dropDownMenu.backgroundBlurEnabled = true
    dropDownMenu.bottomLine.isHidden = false
    dropDownMenu.blurEffectViewAlpha = 0.7

    dropDownMenu.addSwipeGestureToBlurView()
    
    return dropDownMenu
    
    
}
