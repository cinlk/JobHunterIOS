//
//  MainTabBarViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import UserNotifications


private struct TabBarItemImages {
    var normalImg:UIImage
    var selectedImg:UIImage
}

class MainTabBarViewController: UITabBarController {

    private var TabImages:[TabBarItemImages] = []
   
    private func getTabBarImages(images:[(UIImage,UIImage)]){
        
        for  (_, img) in images.enumerated(){
              let item = TabBarItemImages.init(normalImg: img.0.changesize(size: BarImg_Size),
                                               selectedImg: img.1.changesize(size: BarImg_Size))
              TabImages.append(item)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // 加载bar icon 图标
    override func viewDidLoad() {
        super.viewDidLoad()
        getTabBarImages(images:TabItemImages)
        
        if let items = self.tabBar.items {
            let newitems = zip(items.enumerated(), TabImages)
            newitems.forEach { (barItme, images) in
                if barItme.offset == 0 {
                    barItme.element.title = "主页"
                }
                barItme.element.image = images.normalImg
                barItme.element.selectedImage = images.selectedImg
            }
        }
        
    }

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    
    }
    
    

}
