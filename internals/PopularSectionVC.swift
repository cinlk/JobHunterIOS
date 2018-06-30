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
        self.type = .none
        self.loadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func reload() {
        super.reload()
        self.loadData()
    }

}

extension PopularSectionVC{
    
    private func loadData(){
        
        // 获取热门的帖子
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
            for _ in 0..<10{
                if let data = PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"dqwddqwdd","authorName":"我的名字","colleage":"北京大学","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":forumType.interview.rawValue,"thumbUP":2303,"reply":101]){
                    data.showTag =  self?.type == .none ? true : false
                    self?.modes.append(data)
                }
            }
            
            DispatchQueue.main.async {
                self?.didFinishloadData()
            }
        }
        
    }
    
    
}
