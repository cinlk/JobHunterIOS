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
fileprivate let subItems:[String] = ["宣讲会邀请","职位邀请","HR邀约"]


class InvitationViewController: UIViewController {

    
    
    // 子栏目
    private lazy var pageTitle:pagetitleView = { [unowned self] in
        let titles = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: pageTitleH), titles: subItems)
        titles.delegate = self
        return titles
    }()
    
    
    private lazy var ChildVC:[UIViewController] = []
    
    private lazy var pageContent:pageContentView = {  [unowned self] in
        let carrerTalk = CareerTalkInviteViewController()
        ChildVC.append(carrerTalk)
      
        //
        let jobInvite = JobInviteViewController()
        ChildVC.append(jobInvite)
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.randomeColor()
        ChildVC.append(vc)
            
        
        let content = pageContentView.init(frame: CGRect.init(x: 0, y: NavH + pageTitleH, width: ScreenW, height: ScreenH - (NavH + pageTitleH)), childVCs: ChildVC, pVC: self)
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
        self.title = ViewTitle
        self.navigationController?.insertCustomerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
    }

    
    private func setViews() {
        self.view.addSubview(pageTitle)
        self.view.addSubview(pageContent)
        navigationItem()
        
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
    
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        self.pageContent.moveToIndex(index)
    }
    
    
}


extension InvitationViewController: PageContentViewScrollDelegate{
    
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int){
        self.pageTitle.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    
    }
    
    
}
