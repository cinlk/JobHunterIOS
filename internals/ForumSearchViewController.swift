//
//  ForumSearchViewController.swift
//  internals
//
//  Created by ke.liang on 2019/5/13.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ForumSearchViewController: UISearchController {

    internal var searchField: UITextField!
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private var currentSearchWord:String = ""
    
    
    
    
    private lazy var toolBar:UIToolbar = { [unowned self] in
        let t = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.toolBarH))
        t.backgroundColor = UIColor.white
    
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let keyboard = UIBarButtonItem.init(title: "收起键盘", style: .plain, target: self, action: #selector(hiddenKeyBoard))
        t.items = [space, keyboard]
        
        return t
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setViewModel()
        // Do any additional setup after loading the view.
    }
    

   
    
    
    
    deinit {
        print("deinit forumSearchViewController \(self)")
    }

}



extension ForumSearchViewController{
    private func setView(){
        self.view.backgroundColor = UIColor.white
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        //self.searchBar.layer.cornerRadius = 15
    
        self.searchField =  (self.searchBar.value(forKey: "searchField") as! UITextField)
        //self.searchField.rightViewMode = .whileEditing
        self.searchField.clearButtonMode = .whileEditing
        
        self.searchField.layer.borderColor = UIColor.white.cgColor
        self.searchField.layer.borderWidth = 1
        self.searchField.layer.backgroundColor  = UIColor.white.cgColor
        self.searchField.backgroundColor = UIColor.clear
        //        searchField.layer.cornerRadius = search_bar_height/2
        
        //self.searchField.borderStyle  = .none
        self.searchField.textColor = UIColor.darkGray
        // 设置了cornerRaduis 需要设置mask，图形才正确
        self.searchField.layer.masksToBounds = true
        // 键盘上方的view
        self.searchField.inputAccessoryView = toolBar
        
        _ = self.searchField.sd_layout()?.topEqualToView(self.searchBar)?.bottomEqualToView(self.searchBar)
        //self.searchField.layer.cornerRadius =  GlobalConfig.searchBarH / 2
        
    }
    
    private func setViewModel(){
        
        
        
        
        self.searchBar.rx.text.orEmpty.asDriver().drive(onNext: { [weak self] (word) in
            
            if self?.currentSearchWord != word {
                print("search word \(word)")
                self?.currentSearchWord = word
                NotificationCenter.default.post(name: NotificationName.forumSearchWord, object: nil, userInfo: ["word": word])
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
//        self.searchBar.rx.searchButtonClicked.asDriver().drive(onNext: { [weak self] in
//            print("start search \(self?.searchField.text)")
//        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
//
    }
}


extension ForumSearchViewController{
    @objc private func hiddenKeyBoard(){
        self.searchField.resignFirstResponder()
        //self.view.endEditing(true)
        // 开始搜索
        //self.searchBar.rx.text.onNext(self.searchField.text)
        
    }
}
