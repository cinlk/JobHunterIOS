//
//  PopularSectionVC.swift
//  internals
//
//  Created by ke.liang on 2018/6/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



class PopularSectionVC: BasePostItemsViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.type = .hottest
        //self.loadData()
        // Do any additional setup after loading the view.
    }


    

    deinit {
        print("deinit PopularSectionViewController \(self)")
    }
}

//extension PopularSectionVC{
//
//    private func loadData(){
//
//        // 获取热门的帖子
//        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
//            Thread.sleep(forTimeInterval: 3)
//
//            for _ in 0..<5{
//                if let data = PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"dqwddqwdd","authorName":"我的名字","colleage":"北京大学","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind": ForumType.interview.rawValue,"thumbUP":12,"reply":33]){
//                    data.showTag =  self?.type == .none ? true : false
//                    self?.modes.append(data)
//                }
//            }
//
//            for _ in 0..<5{
//                if let data = PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"123456","authorName":"当前为多群","colleage":"北京大学","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":ForumType.interview.rawValue,"thumbUP":16,"reply":8]){
//                    data.showTag =  self?.type == .none ? true : false
//                    self?.modes.append(data)
//                }
//            }
//
//            DispatchQueue.main.async {
//                self?.didFinishloadData()
//            }
//        }
//
//    }
//
//
//}
