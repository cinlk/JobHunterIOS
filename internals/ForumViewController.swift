//
//  ForumViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/11.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ForumViewController: BaseViewController {

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        // Do any additional setup after loading the view.
    }

  
    
    
    override func setViews() {
        self.view.backgroundColor = UIColor.white
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
    }
    
    override func reload() {
        super.reload()
    }


}


extension ForumViewController{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
}
