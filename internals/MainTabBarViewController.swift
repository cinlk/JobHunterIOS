//
//  MainTabBarViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


class MainTabBarViewController: UITabBarController {

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUnreadMessages()
        
        // 监听baged 变化消息 TODO
        _ = NotificationCenter.default.rx.notification(NotificationName.messageBadge, object: nil).takeUntil(self.rx.deallocated).subscribe(onNext: {  [weak self] (notify) in
            
            self?.setUnreadMessages()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        for  (index, item) in TabBarItems.items.enumerated(){
            self.tabBar.items?[index].title = item.title
            self.tabBar.items?[index].image =
                item.normalImg.changesize(size: TabBarItems.imageSize,renderMode:  .alwaysOriginal)
            self.tabBar.items?[index].selectedImage =
                item.selectedImg.changesize(size: TabBarItems.imageSize, renderMode: .alwaysOriginal)
            
            self.tabBar.items?[index].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ConfigColor.TabBarItemColor.normalColor], for: .normal)
            
            self.tabBar.items?[index].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ConfigColor.TabBarItemColor.SelectedColor], for: .selected)
            
            
        }
     
        
        
        self.tabBar.clipsToBounds = true
        self.tabBar.itemSpacing = 5
        
        
    
     }
    
    
    deinit {
        print("deinit maintab")
    }
    

    
    
    
}

extension MainTabBarViewController{
    private func setUnreadMessages(){
      
        let total =  DBFactory.shared.getConversationDB().getAllUnreadCount()
        if total > 0{
            self.tabBar.items?[2].badgeValue = "\(total)"
            self.tabBar.items?[2].badgeColor = UIColor.red
        }else{
            self.tabBar.items?[2].badgeValue = nil
            self.tabBar.items?[2].badgeColor = nil
        }
    }
}
