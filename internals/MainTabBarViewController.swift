//
//  MainTabBarViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    
     // 自定义tabbarimg
     private func getTabBarImages() -> [(UIImage,UIImage)]{
        
        let offset = CGPoint(x: 0, y: 0)
        let home = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Home_Img)
        let selectHome = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Select_Home_Img)
        let message = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Message_Img)
        let selectMessage = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Select_Message_Img)
        
        let person  =  UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Person_Img)
        
        let selectPerson = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Select_Person_Img)
        
        
        return [(home, selectHome),(message,selectMessage),(person,selectPerson)]
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    // 加载bar icon 图标
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = self.tabBar.items {
            let tabBarImages = getTabBarImages()
            for (index,tabitem) in items.enumerated(){
                let tabBarImage = tabBarImages[index]
                // storyboard 设置主页 title 无效，这里设置
                if index == 0 {
                    tabitem.title = "主页"
                }
                tabitem.image = tabBarImage.0
                tabitem.selectedImage = tabBarImage.1
            }
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
