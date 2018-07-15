//
//  MainTabBarViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import UserNotifications


class MainTabBarViewController: UITabBarController {

    
     // 自定义tabbarimg
     private func getTabBarImages() -> [(UIImage,UIImage)]{
        
    
        let home = UIImage.init(named: Home_Img)!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
        
        
        let selectHome = UIImage.init(named: Select_Home_Img)!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
      
        let jobs =  UIImage.init(named: Job_Img)!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
      
        let selectJobs = UIImage.init(named: Select_Job_Img)!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
        
        let message = UIImage.init(named: Message_Img)!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
        
        let selectMessage = UIImage.init(named: Select_Message_Img)!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
        
        let forum = UIImage.init(named: "forum")!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
        let selectForum = UIImage.init(named: "forum")!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)

        let person = UIImage.init(named: Person_Img)!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
        
        
        let selectPerson = UIImage.init(named: Select_Person_Img)!.changesize(size: BarImg_Size).withRenderingMode(.alwaysTemplate)
        
        
        
        
        return [(home, selectHome),(jobs, selectJobs),(message,selectMessage),(forum, selectForum), (person,selectPerson)]
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    // 加载bar icon 图标
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.clear
        
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

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    
    }
    
    

}
