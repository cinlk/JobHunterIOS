//
//  MyPostViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class MyPostViewController: BasePostItemsViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.type  = .mypost
        // Do any additional setup after loading the view.
        self.loadData()
        self.title = "我的帖子"
        self.navigationController?.delegate = self
    }
    
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    

}

extension MyPostViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: PersonViewController.self){
            navigationController.removeCustomerView()
        }
    }
}


extension MyPostViewController{
    private func loadData(){
        
        // 获取我要提问的帖子
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
            for _ in 0..<10{
                if let data = PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"dqwddqwdd","authorName":"我的名字","colleage":"北京大学","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":self?.type?.rawValue,"thumbUP":2303,"reply":101]){
                    
                    self?.modes.append(data)
                }
            }
            
            DispatchQueue.main.async {
                self?.didFinishloadData()
            }
        }
        
    }

}




