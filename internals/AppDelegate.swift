//
//  AppDelegate.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher
import UserNotifications

//import AMapFoundationKit

fileprivate var shareBox:String = ""


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        
        // 获取的初始化数据？
        SingletoneClass.shared.getInitialData { [weak self] (b) in
            
            let enter = EnterAppViewController()
            self?.window = UIWindow(frame: UIScreen.main.bounds)
            self?.window?.makeKeyAndVisible()
            self?.window?.rootViewController = enter
        
        }
        //  获取地理位置
        if  UserLocationManager.shared.getLocation() == false {
            print("地理位置不可用")
        }
        
        // 初始化数据库
        //_ = SqliteManager.shared
        // 友盟第三方接口
        UMengInitial()
        
        SingletoneClass.shared.setSharedApps(condition: nil)
        
        //im sdk
        AVOSCloud.setApplicationId(GlobalConfig.LeanCloudApp.AppId, clientKey: GlobalConfig.LeanCloudApp.AppKey)
        
    
        AVOSCloud.setAllLogsEnabled(true)
        
        
        
        UNUserNotificationCenter.current().delegate = self
        // 开启远程通知
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            if settings.authorizationStatus == .authorized  {
                // 订阅系统通知频道
                print("subscribe systemNotify Channel")
                let av = AVInstallation.default()
                av.addUniqueObject("systemNotify", forKey: "channels")
                //av.remove("systemNotify", forKey: "channel")
                 
                av.saveInBackground()
                return
                
            }
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (success, error) in
                if !success{
                    print("用户不允许消息通知")
                }
            })
            //UIApplication.shared.registerForRemoteNotifications()
        }
        
        // 向apns 请求token
        UIApplication.shared.registerForRemoteNotifications()
        
        // 主动拉取离线未读消息
        AVIMClient.setUnreadNotificationEnabled(true)
        
        // 从消息进入app？
//        if launchOptions != nil{
//            self.window?.rootViewController?.view.showToast(title: "lauch options \n \(String.init(describing: launchOptions))", customImage: nil, mode: .text)
//
//            AVAnalytics.trackAppOpened(launchOptions: launchOptions)
//        }
//
        // 注册自定义消息
        //myim.registerSubclass()
        
        
        //GlobalUserInfo.shared.baseInfo(role: UserRole.role.anonymous, token: "token", account: "" , pwd: "")
        
    
        
//        var testObj:AVObject = AVObject.init(className: "demo")
//        testObj["demo"] = 123
//        
//        testObj.save()
        // 高德地图配置
//        AMapServices.shared()?.apiKey = "4afc428898376c1810581289501ec549"
//        AMapServices.shared()?.enableHTTPS = false
        
        // kingfisher ssl 配置
//        let config = URLSessionConfiguration.default
//        let imgManager = ImageDownloader.default
//        imgManager.sessionConfiguration = config
//        // 信任证书签名的ip地址
//        imgManager.trustedHosts = Set(["127.0.0.1"])
//        KingfisherManager.shared.downloader = imgManager
//
     
        
        
        return true
    }

    // 系统回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 简历文档 获取
        // 判断用户权限
        if url.scheme == "file"{
            let targetVC = PreShowPDFVC()
            targetVC.fileURL = URL.init(fileURLWithPath: url.path) 
            //print(url)
            // 切换到 简历板块界面
            // 判断用户是否已经登录 TODO
            
            if let vc =  self.getResumePageVC(){
                vc.hidesBottomBarWhenPushed = true
                vc.navigationController?.pushViewController(targetVC, animated: true)
                return true
            }
            return false
        }
        
        // 第三方登录 回调
        let result = UMSocialManager.default().handleOpen(url)
        let urlKey: String = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String

        if !result{
            print(urlKey)
        }
        return result
    }
    
    // IOS 9
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
        
        UIApplication.shared.applicationIconBadgeNumber = DBFactory.shared.getConversationDB().getAllUnreadCount()
        

    }
    // 获取deviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("获取deviceToken \(deviceToken.toHexString())")
//        let av =  AVInstallation.default()
//        av.setDeviceTokenFrom(deviceToken)
//        av.saveInBackground()
        AVOSCloud.handleRemoteNotifications(withDeviceToken: deviceToken)
        
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("注册 远程通知失败 \(String.init(describing: error))")
    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // 转换为本地通知 显示通知栏  或弹出消息框?
//        print("userinfo", userInfo)
//
//
//    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // 未读的消息 个数
        UIApplication.shared.applicationIconBadgeNumber = DBFactory.shared.getConversationDB().getAllUnreadCount()
        // 清楚avcloud install 里的bages 个数
        let at = AVInstallation.default()
        at.badge = UIApplication.shared.applicationIconBadgeNumber
        at.saveInBackground()
        
        // 清理其他badge 数据
        
        
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // 用户退出
        
       // self.performSelector(onMainThread: #selector(self.logout), with: nil, waitUntilDone: true)
        // moya  是异步的 主线程已经退出，来不及执行完请求 ????
        //Thread.sleep(forTimeInterval: 10)
        
        // 删除文件  TODO
        let url = SingletoneClass.fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let inbox = url.last?.appendingPathComponent(shareBox) else {
            return
        }
        
        do{
            if  SingletoneClass.fileManager.fileExists(atPath: inbox.path){
                try  SingletoneClass.fileManager.removeItem(at: inbox)
            }
            
        }catch{
            
        }
        
    }
    
    
//    @objc func logout(){
//        if GlobalUserInfo.shared.isLogin{
//            SingletoneClass.shared.logout{ (b) in
//                print(b)
//            }
//        }
//    }
    

}

// test  消息通知


// 文件共享
extension AppDelegate{
    // 只有用户登录后， 才能找vc TODO
    private func getResumePageVC() -> UIViewController?{
        
        let root = UIApplication.shared.keyWindow?.rootViewController
        
        let currentVC = findTarget(rootVC: root!)
        
        
        return currentVC
    }
    
    private func findTarget(rootVC:  UIViewController) -> UIViewController?{
        var tmp = rootVC
        // 找到 uitabbarcontroller
        
        // 切换到个人简历板块
        var currentVC:UIViewController?
        if tmp.presentedViewController != nil {
            tmp = tmp.presentedViewController!
        }
        
        if let tab = tmp as? UITabBarController{
            tab.selectedIndex = 4
            let nav  = (tab.selectedViewController as? UINavigationController)
            if let visibelVC = nav?.visibleViewController, visibelVC.isKind(of: ResumePageViewController.self){
                return nav?.visibleViewController
            }
            nav?.popToRootViewController(animated: true)
            currentVC = ResumePageViewController()
            nav?.pushViewController(currentVC!, animated: false)
            
        }
        
        return currentVC
    }
    
    
}






//   获取手机安装的 app(用于第三方登录 和 分享)
extension AppDelegate{
    

    private func UMengInitial(){
        
        UMConfigure.initWithAppkey(ConfigUMConfig.umKey, channel: nil)
        // ****用的别人测试账号 *****
        // 微信好友
        UMSocialManager.default().setPlaform(.wechatSession, appKey: ConfigUMConfig.wechat.wechatAppKey, appSecret: ConfigUMConfig.wechat.wechatAppSecret, redirectURL: ConfigUMConfig.wechat.redirectURL)
        // 微信朋友圈
        UMSocialManager.default().setPlaform(.wechatTimeLine, appKey: ConfigUMConfig.wechat.wechatAppKey, appSecret: ConfigUMConfig.wechat.wechatAppSecret, redirectURL: ConfigUMConfig.wechat.redirectURL)
        // 自己的账号
        UMSocialManager.default().setPlaform(.sina, appKey: ConfigUMConfig.sina.sinaAppKey, appSecret: ConfigUMConfig.sina.sinaAppSecret, redirectURL: ConfigUMConfig.sina.redirectURL)
        // qq 是自己的账号
        UMSocialManager.default().setPlaform(.QQ, appKey: ConfigUMConfig.qq.qqAppKey, appSecret: ConfigUMConfig.qq.qqAppSecret, redirectURL: ConfigUMConfig.qq.redirectURL)
        UMSocialManager.default().setPlaform(.qzone, appKey: ConfigUMConfig.qq.qqAppKey, appSecret: ConfigUMConfig.qq.qqAppSecret, redirectURL: ConfigUMConfig.qq.redirectURL)
        
    }
    
    
    
}


extension AppDelegate: UNUserNotificationCenterDelegate{
    
    // 程序在后台点击通知触发 接受远程 或本地通知内容
    // 判断通知类型 跳转到不同界面
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //response.notification.request.content.
        print("+++>", response)
        // 更新badge ？？
        // 更新界面 ？？
        if let trigger = response.notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self){
           print(response.notification.request.content.userInfo)
            // 检查用户是否登录
            // 如果登录 则跳转到消息聊天界面
            
            if GlobalUserInfo.shared.isLogin == true {
                // 判断当前的vc
                var vc = UIApplication.shared.keyWindow?.rootViewController
                if vc?.presentedViewController != nil {
                    vc = vc?.presentedViewController
                }
               
                if let tabVc = vc as? MainTabBarViewController{
                    
                    let nav  = (tabVc.selectedViewController as? UINavigationController)
                    
                    if let visibelVC = nav?.visibleViewController, visibelVC.isKind(of: MessageMainController.self){
                        //return nav?.visibleViewController
                        //return visibelVC
                        return
                    }else{
                        // 职位板块 进入某个vc   直接poptoroot出栈 有内存泄露？？
                        nav?.popToRootViewController(animated: false)
                        tabVc.selectedIndex = 2
                        
                    }
                    
                }
                
                return
            }else{
                print("用户未登录 不能跳转到对应的vc")
            }
            
            
            
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        //print(notification?.request.auth)
    }
    
    // 程序在前台, 显示通知
    // 如果点击了通知 触发 didReceive 方法, 不点击什么也不做
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 更新badge TODO
        // 更新界面 TODO
        
        print("---->", notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
        
    }
}




