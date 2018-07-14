//
//  Extension+UIViewController.swift
//  internals
//
//  Created by ke.liang on 2018/6/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation





extension UIViewController{
    
    // 分享内容函数
    
    func copyToPasteBoard(text:String){
        
        let paste = UIPasteboard.general
        paste.string = text
        showOnlyTextHub(message: "复制成功", view: self.view)
    }
    
    
    func openMore(text:String, site:Any? = nil , image:Any? = nil){
        
        var items:[Any] = []
        items.append(text)
        if site != nil{
            items.append(site!)
        }
        if image != nil{
            items.append(image!)
        }
        
        let activityVC = UIActivityViewController.init(activityItems: items, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView =  self.view
        present(activityVC, animated: true, completion: nil)
    }
    
    func shareToApp(type:UMSocialPlatformType, view:UIView, title:String = "", des:String = "", url:String? = nil, image:UIImage? = nil ){
        
        let mesObj = UMSocialMessageObject.init()
        
        let sharedObj = UMShareWebpageObject.init()
        
        sharedObj.title = title
        sharedObj.descr = des
        // 如果用url 图片地址（可能网络连接特别慢）
        sharedObj.thumbImage = image
        sharedObj.webpageUrl = url
        mesObj.shareObject = sharedObj
        
        
        UMSocialManager.default().share(to: type, messageObject: mesObj, currentViewController: self) { (data, error) in
            if error != nil{
                if (error as! NSError).code == 2009{
                    print("操作取消")
                    return
                }
                
                //                    showOnlyTextHub(message: "请先安装应用", view: view)
                //                    print("出现错误\(error)")
            }else{
                print(data)
            }
        }
    }
    
}
