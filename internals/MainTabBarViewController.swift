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
        
        let offset = CGPoint(x: 0, y: 0)
        let home = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Home_Img)
        let selectHome = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Select_Home_Img)
        let jobs = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Job_Img)
        let selectJobs = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Select_Job_Img)
        
        let message = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Message_Img)
        let selectMessage = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Select_Message_Img)
        
        let person  =  UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Person_Img)
        
        let selectPerson = UIImage.barImage(size: BarImg_Size, offset: offset, renderMode: .alwaysOriginal, name: Select_Person_Img)
        
        
        return [(home, selectHome),(jobs, selectJobs),(message,selectMessage),(person,selectPerson)]
    
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
        
        
        let forum = ForumViewController()
        let forumNavigate = UINavigationController(rootViewController: forum)
        
        forumNavigate.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        forumNavigate.tabBarItem.image = UIImage.barImage(size: BarImg_Size, offset: CGPoint.zero, renderMode: .automatic, name: "forum")
        
        forumNavigate.tabBarItem.title = "论坛"
        
        addChildViewController(forumNavigate)
        
        
        // #TODO 被通知加载 显示圆点
//        self.tabBar.items![1].pp.addBadge(text: "···")
//        self.tabBar.items![1].pp.setBadgeLabel(attributes: { (lable) in
//            lable.font = UIFont.systemFont(ofSize: 10)
//            lable.textColor = UIColor.white
//        })
        
        //self.tabBar.items![2].pp.addDot(color: UIColor.red)
        //self.tabBar.items![2].pp.hiddenBadge()
    }

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    
    }
    
    

}
