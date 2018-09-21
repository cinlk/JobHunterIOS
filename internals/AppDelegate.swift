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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var shareInBox:String = "Inbox"
    
    var fileManager = FileManager.default
    
    // 地理位置
    var locateManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        
        // 初始viewController
        let enter = EnterAppViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = enter
        
        
        loadLoacation()
        
        // load contacts
       // Contactlist.shared.removeAll()
    
        //Contactlist.shared.removeAll()
       //localData.shared.clearSubscribeData()
        //TODO 服务器获取greeting数据, 并与本地存储的数据来判断(最新的时间)
        
        // 数据库信息
        //let _ = SqliteManager.shared
        
        // 从服务器获取打招呼语句
        GreetingMsg = "默认第一条"
        // root controller
        
        
        // 友盟初始化 测试
        
        UMConfigure.initWithAppkey("5ac6ed8bb27b0a7ba6000059", channel: nil)
        // ****用的别人测试账号 *****
        // 微信好友
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wxd795d58c78ac222b", appSecret: "779c58188ca57046f76353ea1e84412c", redirectURL: "http://mobile.umeng.com/social")

        // 微信朋友圈
        UMSocialManager.default().setPlaform(.wechatTimeLine, appKey: "wxd795d58c78ac222b", appSecret: "779c58188ca57046f76353ea1e84412c", redirectURL: "http://mobile.umeng.com/social")
        // 自己的账号
        UMSocialManager.default().setPlaform(.sina, appKey: "879467986", appSecret: "a426356a2f770cba1c2fd88564635206", redirectURL: "https://api.weibo.com/oauth2/default.html")


        // qq 是自己的账号
        UMSocialManager.default().setPlaform(.QQ, appKey: "1106824184", appSecret: "V0zSNqtNlo2wPIo7", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(.qzone, appKey: "1106824184", appSecret: "V0zSNqtNlo2wPIo7", redirectURL: "http://mobile.umeng.com/social")
        
        
        // test  user-agent
        // testUserAgent()
        
        //
        getLocalApps()
        
        // kingfisher ssl 配置
        let config = URLSessionConfiguration.default
        let imgManager = ImageDownloader.default
        imgManager.sessionConfiguration = config
        // 信任证书签名的ip地址
        imgManager.trustedHosts = Set(["127.0.0.1"])
        KingfisherManager.shared.downloader = imgManager
        
        // 设置TabBaritem 颜色
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        
        return true
    }

    // 系统回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 简历文档 获取
        // 判断用户权限
        if url.scheme == "file"{
        
            let targetVC = PreShowPDFVC()
            targetVC.fileURL = URL.init(fileURLWithPath: url.path) 
            print(url)
            
            if let vc =  self.getResumePageVC(){
                vc.hidesBottomBarWhenPushed = true
                vc.navigationController?.pushViewController(targetVC, animated: true)
            }
            return true
        }
        
        // 第三方登录
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
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // 删除文件
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let inbox = url.last?.appendingPathComponent(shareInBox) else {
            return
        }
        
        do{
            if fileManager.fileExists(atPath: inbox.path){
                try fileManager.removeItem(at: inbox)
            }
            
        }catch{
            
        }
        
    }
    
    

}


// 文件共享
extension AppDelegate{
    
    private func getResumePageVC() -> UIViewController?{
        let root = UIApplication.shared.keyWindow?.rootViewController
        
        let currentVC = findTarget(rootVC: root!)
        
        
        return currentVC
    }
    
    private func findTarget(rootVC:  UIViewController) -> UIViewController?{
        var tmp = rootVC
        
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
    
    private func getLocalApps(){
        
        let weixin = UIApplication.shared.canOpenURL(URL.init(string: "weixin://")!)
        let weibo = UIApplication.shared.canOpenURL(URL.init(string: "sinaweibo://")!)
        let qq = UIApplication.shared.canOpenURL(URL.init(string: "mqqapi://")!)
        // 暂时不用
        let alipay = UIApplication.shared.canOpenURL(URL.init(string: "alipay://")!)
        if weixin{
            shareItems.append(ShareItem.init(name: "微信好友", image: "wechat",type:UMSocialPlatformType.wechatSession,bubbles: nil))
            shareItems.append( ShareItem.init(name: "微信朋友圈", image: "friendCircle", type: UMSocialPlatformType.wechatTimeLine, bubbles: nil))
        }
        if weibo{
            shareItems.append( ShareItem.init(name: "sina", image: "sina", type: UMSocialPlatformType.sina, bubbles: nil))
        }
        if qq{
            shareItems.append( ShareItem.init(name: "QQ空间", image: "qqZone", type: UMSocialPlatformType.qzone, bubbles: nil))
            shareItems.append(        ShareItem.init(name: "QQ", image: "qqCircle",type: UMSocialPlatformType.QQ,  bubbles: nil))
        }
        shareItems.append(  ShareItem.init(name: "复制链接", image: "copyIcon", type: UMSocialPlatformType.copyLink, bubbles: nil))
        shareItems.append( ShareItem.init(name: "更多", image: "moreShare", type: UMSocialPlatformType.more, bubbles: nil))
        if shareItems.count <= 4{
            shareViewH -= 87.5
        }
    }
}

//  获取地理位置

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





extension AppDelegate{
    func testUserAgent(){
        
        if let url = URL.init(string: "https://192.168.199.113:9090/jobs"){
            httpsGET(request: NSMutableURLRequest.init(url: url))
        }
        
       
    }
    
    func httpsGET(request:  NSMutableURLRequest){
        request.setValue("ios+android", forHTTPHeaderField: "User-Agent")
        let config = URLSessionConfiguration.default
        
        let session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request as URLRequest) { (data, res, error) in
            if error != nil{
                print(error)
            }else{
                let str = String.init(data: data!, encoding: String.Encoding.utf8)
                print(str)
            }
            
        }
        task.resume()
        
    }
}

extension AppDelegate: URLSessionDelegate{
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // 服务端验证
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust{
            let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
            let ceritificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
            let remoteCertificateData = CFBridgingRetain(SecCertificateCopyData(ceritificate!))
            
            // 获取证书
            let cerpath = Bundle.main.path(forResource: "server", ofType: "cert")
            if let cerData = try? Data.init(contentsOf: URL.init(fileURLWithPath: cerpath!)){
                if remoteCertificateData?.isEqual(cerData) == true {
                     let credential = URLCredential.init(trust: serverTrust)
                     challenge.sender?.use(credential, for: challenge)
                    completionHandler(.useCredential,credential)
                    
                }else{
                    completionHandler(.cancelAuthenticationChallenge,nil)
                }
                
            }
            
        }else{
            completionHandler(.cancelAuthenticationChallenge,nil)
        }
        
    }
}



