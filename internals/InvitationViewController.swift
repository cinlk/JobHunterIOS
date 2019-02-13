//
//  InvitationViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let ViewTitle:String = "我的邀约"
fileprivate let pageTitleH:CGFloat = 45
fileprivate let subItems:[String] = ["宣讲会邀请","职位邀请"]


class InvitationViewController: UIViewController {

    
    
    // 子栏目
    private lazy var pageTitle:PagetitleView = { [unowned self] in
        let titles = PagetitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: pageTitleH) ,titles: subItems, itemWidth: 120)
        titles.delegate = self
        return titles
    }()
    
    
    private lazy var ChildVC:[UIViewController] = []
    
    private lazy var pageContent:PageContentView = {  [unowned self] in
        let carrerTalk = CareerTalkInviteViewController()
        ChildVC.append(carrerTalk)
      
        //
        let jobInvite = JobInviteViewController()
        ChildVC.append(jobInvite)
            
        
        let content = PageContentView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH + pageTitleH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - (GlobalConfig.NavH + pageTitleH)), childVCs: ChildVC, pVC: self)
        content.delegate = self
        
        return content
    }()
    
    
    //
    private lazy var btn:UIButton = {
        let btn = UIButton(frame: CGRect.zero)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("设置", for: .normal)
        
        btn.addTarget(self, action: #selector(setting(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
      
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)

     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     }

    
    private func setViews() {
        
        self.title = ViewTitle
        self.view.backgroundColor = UIColor.white
        
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.delegate = self
        
        
        self.view.addSubview(pageTitle)
        self.view.addSubview(pageContent)
        
        navigationItem()
        
    }
    
    
    
    
}

extension InvitationViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController.isKind(of: PersonViewController.self) || viewController.isKind(of: OnlineApplyShowViewController.self){
            self.navigationController?.removeCustomerView()
            
            
        }
    }
}



// 设置navigation item
extension InvitationViewController{
    private func navigationItem(){
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
    }
    
    @objc private func setting(_ btn:UIButton){
        let set = invitationSettingViewController()
        self.navigationController?.pushViewController(set, animated: true)
    }
}


extension InvitationViewController: pagetitleViewDelegate{
    
    func ScrollContentAtIndex(index: Int) {
        self.pageContent.moveToIndex(index)
    }
    
    
}


extension InvitationViewController: PageContentViewScrollDelegate{
    
    func pageContenScroll(_ contentView: PageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int){
        self.pageTitle.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    
    }
    
    
}
