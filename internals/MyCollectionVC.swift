//
//  MyCollectionVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let viewTitle:String = "收藏"
fileprivate let pagetTitleH:CGFloat = 40

class MyCollectionVC: UIViewController {

    private var currentSelect:Int = 0
    
    // 记录状态
    private var isEdit:Bool = false
    private var isAll:Bool = false
    
    private var childVC:[UIViewController] = []

    private let titles:[String] = ["职位","公司", "宣讲会", "帖子"]

    // 注意顺序！！
    private let observerName:[String] = ["jobCollectedVC","CompanyCollectedVC","MeetingCollectedVC","PostCollectedViewController"]
 
    private lazy var pageTitle:PagetitleView = { [unowned self ] in
        let pageTitle:PagetitleView = PagetitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: pagetTitleH), titles: self.titles, lineCenter: true )
    
        pageTitle.delegate = self
        return pageTitle
        
    }()
    
    
    // 底部按钮
    
    private lazy var  chooseAll:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("全选", for: .normal)
        btn.setTitle("取消", for: .selected)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.red, for: .selected)
        btn.addTarget(self, action: #selector(all), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var delete:UIButton = {
        
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return btn
        
    }()
    
    
    private lazy var bottomBar:UIToolbar = {
        let bar = UIToolbar.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH - 44, width: GlobalConfig.ScreenW, height: 44))
        bar.isHidden = true
        bar.barStyle = .default
        bar.isTranslucent = true
        return bar
    }()
    private lazy var pageContent:PageContentView = { [unowned self] in
        
        
        let vc = jobCollectedVC()
        childVC.append(vc)
        
        let vc2 = CompanyCollectedVC()
        childVC.append(vc2)

        let meeting = MeetingCollectedVC()
        childVC.append(meeting)
        
        let post = PostCollectedViewController()
        childVC.append(post)
        
        let v:PageContentView = PageContentView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH + pagetTitleH , width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - pagetTitleH), childVCs: childVC, pVC: self)
        v.delegate = self
        return v
        
        
    }()
    
   

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewTitle
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(pageTitle)
        self.view.addSubview(pageContent)
        self.navigationController?.delegate = self
        addDeleteItem()
        addToobarItem()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)

        
    }
    



}

extension MyCollectionVC{
    private func addDeleteItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(edit))
    }
    
    
    private func addToobarItem(){
        self.view.addSubview(bottomBar)
        let middleSpace =  UIBarButtonItem(barButtonSystemItem:.flexibleSpace,target:nil, action:nil)
        
        bottomBar.setItems([UIBarButtonItem.init(customView: chooseAll),middleSpace,UIBarButtonItem.init(customView: delete)], animated: false)

    }
    
    @objc private func edit(){
        isEdit = !isEdit
        if isEdit{
            NotificationCenter.default.post(name: NSNotification.Name.init(observerName[currentSelect]), object: nil, userInfo: ["action":"edit"])
            navigationItem.rightBarButtonItem?.title = "取消"
            bottomBar.isHidden = false
        }else{
            NotificationCenter.default.post(name: NSNotification.Name.init(observerName[currentSelect]), object: nil, userInfo: ["action":"cancel"])
            navigationItem.rightBarButtonItem?.title = "编辑"
            bottomBar.isHidden = true

        }
    }
    
    @objc private func all(){
        isAll = !isAll
        if isAll{
            NotificationCenter.default.post(name: NSNotification.Name.init(observerName[currentSelect]), object: nil, userInfo: ["action":"selectAll"])
            chooseAll.isSelected = true
        }else{
            NotificationCenter.default.post(name: NSNotification.Name.init(observerName[currentSelect]), object: nil, userInfo: ["action":"unselect"])
            chooseAll.isSelected = false
        }
    }
    
    
    @objc private func deleteItem(){
        NotificationCenter.default.post(name: NSNotification.Name.init(observerName[currentSelect]), object: nil, userInfo: ["action":"delete"])
    }
    
    
}


extension MyCollectionVC: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: PersonViewController.self){
            navigationController.removeCustomerView()
        }
    }
}

extension MyCollectionVC: pagetitleViewDelegate{
    func ScrollContentAtIndex(index: Int) {
        NotificationCenter.default.post(name: NSNotification.Name.init(observerName[currentSelect]), object: nil, userInfo: ["action":"cancel"])
        navigationItem.rightBarButtonItem?.title = "编辑"
        chooseAll.isSelected = false
        bottomBar.isHidden = true

        self.pageContent.moveToIndex(index)
        
        currentSelect = index
    }
    
    
}



extension MyCollectionVC: PageContentViewScrollDelegate{
    func pageContenScroll(_ contentView: PageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.pageTitle.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
        NotificationCenter.default.post(name: NSNotification.Name.init(observerName[currentSelect]), object: nil, userInfo: ["action":"cancel"])
        navigationItem.rightBarButtonItem?.title = "编辑"
        chooseAll.isSelected = false
        bottomBar.isHidden = true


        
        currentSelect = targetIndex
    }
    
    
}

