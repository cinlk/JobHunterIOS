//
//  searchResultController.swift
//  internals
//
//  Created by ke.liang on 2017/12/16.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import YNDropDownMenu
import RxDataSources
import MJRefresh


protocol SearchControllerDeletgate: class {
    
    func searchData(word:String)
    
    func resetCondition()
    
}


class searchResultController: BaseViewController {

    private var searchChildVC:[UIViewController] = []
    
    internal lazy var searchFildContent:pageContentView = { [unowned self] in
        
        let os = OnlineApplySearchVC.init()
        let cs = CampusSearchVC.init()
        let ins = InternSearchVC.init()
        let css = CareerTalkSearchVC.init()
        let coms = CompanySearchVC()
        searchChildVC.append(contentsOf: [os, cs, ins, css, coms])
        let content = pageContentView.init(frame: self.view.frame, childVCs: searchChildVC, pVC: self)
        content.collectionView.isScrollEnabled = false
        return content
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _ = searchFildContent.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
  
    override func setViews() {
    
        self.view.addSubview(searchFildContent)
        self.handleViews.append(searchFildContent)
        super.setViews()
    }
    
    override func showError() {
        super.showError()
    }
    
    override func reload() {
        super.reload()

    }
    
    override func didFinishloadData() {
        // 不让hub 从view 中移除
        super.didFinishloadData()
    }
    
}


extension searchResultController{
    
    
    
    // 父vc 跳转过来
    open func startSearchData(type: searchItem,word: String){
        
        
        switch type {
            
        case .onlineApply:
            self.searchFildContent.moveToIndex(0)
            
            if let vc =  self.childViewControllers[0] as? SearchControllerDeletgate{
                // 清空搜索条件
                vc.resetCondition()
                vc.searchData(word:word)
            }
            
        case .graduate:
             self.searchFildContent.moveToIndex(1)
             if let vc = self.childViewControllers[1] as? SearchControllerDeletgate{
                vc.resetCondition()
                vc.searchData(word: word)
             }
        case .intern:
            self.searchFildContent.moveToIndex(2)
            if let vc = self.childViewControllers[2] as? SearchControllerDeletgate{
                vc.resetCondition()
                vc.searchData(word: word)
            }
        case .meeting:
            self.searchFildContent.moveToIndex(3)
            if let vc = self.childViewControllers[3] as? SearchControllerDeletgate{
                vc.resetCondition()
                vc.searchData(word: word)
            }

        case .company:
            self.searchFildContent.moveToIndex(4)
            if let vc = self.childViewControllers[4] as? SearchControllerDeletgate{
                vc.resetCondition()
                vc.searchData(word: word)
            }
        
        default:
            break
        }
        
        self.didFinishloadData()
        
    }
}
