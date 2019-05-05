//
//  OfferSectionVC.swift
//  internals
//
//  Created by ke.liang on 2018/6/26.
//  Copyright © 2018年 lk. All rights reserved.
//


import UIKit

class OfferSectionVC: BasePostItemsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.type = .offers
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: Notification.Name.init(self.type.rawValue), object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        //NotificationCenter.default.removeObserver(self, name: Notification.Name.init(self.type!.rawValue), object: nil)
    }
    
}


extension OfferSectionVC{
    
    @objc private func updateTable(_ sender: Notification){
        if let info = sender.userInfo as? [String:PostArticleModel], let mode = info["mode"] {
            self.modes.insert(mode, at: 0)
            self.table.reloadData()
        }
        
    }
}

//
//extension OfferSectionVC{
//    
//    private func loadData(){
//        
//        // 获取offer 比较的帖子
//        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
//            Thread.sleep(forTimeInterval: 3)
//            
//            for _ in 0..<10{
//                if let data = PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"dqwddqwdd","authorName":"我的名字","colleage":"北京大学","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":self?.type.rawValue ?? "none","thumbUP":2303,"reply":101]){
//                    
//                    self?.modes.append(data)
//                }
//            }
//            
//            DispatchQueue.main.async {
//                self?.didFinishloadData()
//            }
//        }
//    }
//    
//    
//}



