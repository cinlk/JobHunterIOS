//
//  MainTabBarViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    
    var info:Dictionary<String,String>?
    
    
    func getTabBarImages() -> [UIImage]{
        let size = CGSize(width: 27, height: 26)
        let offset = CGPoint(x: 0, y: 0)
        var image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        var speech = UIImage(named: "message")?.withRenderingMode(.alwaysOriginal)
        var person = UIImage(named: "person")?.withRenderingMode(.alwaysOriginal)
        
        image  = image?.barImage(size: size, offset: offset)
        speech = speech?.barImage(size: size, offset: offset)
        person  = person?.barImage(size: size, offset: offset)
        return [image!,speech!,person!]
        
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    // 这里加载bar icon 图标
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = self.tabBar.items {
            let tabBarImages = getTabBarImages() // tabBarImages: [UIImage]
            for i in 0..<items.count {
                let tabBarItem = items[i]
                let tabBarImage = tabBarImages[i]
                tabBarItem.image = tabBarImage.withRenderingMode(.alwaysOriginal)
                tabBarItem.selectedImage = tabBarImage
            }
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
