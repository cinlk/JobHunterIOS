//
//  AppDelegate.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
        
        // load contacts
       // Contactlist.shared.removeAll()
        // load search keywords
        _ = InitailData.shareInstance
        //Contactlist.shared.removeAll()
       //localData.shared.clearSubscribeData()
        //TODO 服务器获取greeting数据, 并与本地存储的数据来判断(最新的时间)
        
        // 数据库信息
        let sqlite = SqliteManager.shared
        
        GreetingMsg = localData.shared.getGreetingMSG()!["msg"] as! String
        // root controller
        // 友盟初始化
        
        UMConfigure.initWithAppkey("5ac6ed8bb27b0a7ba6000059", channel: nil)
        // ****用的别人测试账号 *****
        // 微信好友
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wxd795d58c78ac222b", appSecret: "779c58188ca57046f76353ea1e84412c", redirectURL: "http://mobile.umeng.com/social")
        
        // 微信朋友圈
        UMSocialManager.default().setPlaform(.wechatTimeLine, appKey: "wxd795d58c78ac222b", appSecret: "779c58188ca57046f76353ea1e84412c", redirectURL: "http://mobile.umeng.com/social")
        // 自己的账号
        UMSocialManager.default().setPlaform(.sina, appKey: "879467986", appSecret: "a426356a2f770cba1c2fd88564635206", redirectURL: "https://api.weibo.com/oauth2/default.html")
        
        //UMSocialManager.default().setPlaform(.sms, appKey: nil, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        //UMSocialManager.default().setPlaform(.email, appKey: nil, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        // qq 是自己的账号
        UMSocialManager.default().setPlaform(.QQ, appKey: "1106824184", appSecret: "V0zSNqtNlo2wPIo7", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(.qzone, appKey: "1106824184", appSecret: "V0zSNqtNlo2wPIo7", redirectURL: "http://mobile.umeng.com/social")
        
        
        
        return true
    }

    // 系统回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        let urlKey: String = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String

        if !result{
            print(urlKey)
        }
        
        
        return result
    }
    // 新浪微博的H5网页登录回调需要实现这个方法，页面分享后，会崩溃？？
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // 这里的URL Schemes是配置在 info -> URL types中, 添加的新浪微博的URL schemes
        // 例如: 你的新浪微博的AppKey为: 123456789, 那么这个值就是: wb123456789
        if url.scheme == "URL Schemes" {
            // 新浪微博 的回调
            print("-----")
            
            return true
        }
        
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

