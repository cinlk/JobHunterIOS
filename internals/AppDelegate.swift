//
//  AppDelegate.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // 地理位置
    var locateManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        
        // 初始viewController
        let enter = EnterAppViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = enter
        
        
        loadLoacation()
        
        // load contacts
       // Contactlist.shared.removeAll()
        // load search keywords
        _ = InitailData.shareInstance
        //Contactlist.shared.removeAll()
       //localData.shared.clearSubscribeData()
        //TODO 服务器获取greeting数据, 并与本地存储的数据来判断(最新的时间)
        
        // 数据库信息
        //let _ = SqliteManager.shared
        
        // 从服务器获取打招呼语句
        GreetingMsg = "默认第一条"
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
            return UMSocialManager.default().handleOpen(url)
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

extension AppDelegate: CLLocationManagerDelegate{
    
    
    private func loadLoacation(){
        locateManager.delegate = self
        locateManager.desiredAccuracy = kCLLocationAccuracyBest
        locateManager.distanceFilter = kCLLocationAccuracyKilometer
        if   #available(iOS 8.0, *){
            locateManager.requestAlwaysAuthorization()
            locateManager.requestWhenInUseAuthorization()
        }
        
        locateManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location:CLLocation = locations.last, location.horizontalAccuracy > 0{
            print("纬度\(location.coordinate.latitude)")
            print("经度\(location.coordinate.longitude)")
            getCity(location: location)
            locateManager.stopUpdatingLocation()
        }
        
    }
    
    
    private func getCity(location: CLLocation){
        let geocoder:CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if  error == nil{
                if let place = placemarks?.first{
                    print("地址\(place.name)")
                    print("城市\(place.locality)")
                    print("区\(place.subLocality)")
                }else{
                    print("获取不到位置")
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        switch (error as NSError).code {
        case 0:
            print("位置不可用")
        case 1:
            print("用户关闭")
        default:
            break
        }
        print(error)
        
    }
    
    
    
}




