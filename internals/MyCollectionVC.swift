//
//  MyCollectionVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


fileprivate let viewTitle:String = "收藏"
fileprivate let pagetTitleH:CGFloat = 40
fileprivate let titles:[String] = ["校招", "实习","公司", "宣讲会", "网申"]

class MyCollectionVC: UIViewController {

    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    
    
    private var currentSelect:Int = 0
    
    // 记录状态
    private var isEdit:Bool = false
    private var isAll:Bool = false
    
//    private var childVC:[UIViewController] = []

    //private let titles:[String] = ["职位","公司", "宣讲会", "帖子"]

    // 注意顺序！！
   // private let observerName:[String] = ["campusjobCollectedVC","internJobCollectedVC","companyCollectedVC","meetingCollectedVC","onlineApplyCollectedVC"]
 
    private lazy var pageTitle:PagetitleView = { [unowned self ] in
        let pageTitle:PagetitleView = PagetitleView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: pagetTitleH), titles: titles, lineCenter: true )
    
        pageTitle.delegate = self
        return pageTitle
        
    }()
    
    
    
    private lazy var rightBarBtn:UIBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: nil, action: nil)
    // 底部按钮
    
    private lazy var  chooseAll:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("全选", for: .normal)
        btn.setTitle("取消", for: .selected)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.red, for: .selected)
        //btn.addTarget(self, action: #selector(all), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var delete:UIButton = {
        
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        //btn.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return btn
        
    }()
    
    
    private lazy var bottomBar:UIToolbar = { [unowned self] in
        let bar = UIToolbar.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH - GlobalConfig.toolBarH, width: GlobalConfig.ScreenW, height: GlobalConfig.toolBarH))
        bar.isHidden = true
        bar.barStyle = .default
        bar.isTranslucent = true
        
        let middleSpace =  UIBarButtonItem(barButtonSystemItem:.flexibleSpace,target:nil, action:nil)
        
        bar.setItems([UIBarButtonItem.init(customView: chooseAll),middleSpace,UIBarButtonItem.init(customView: delete)], animated: false)

        return bar
    }()
    private lazy var pageContent:PageContentView = { [unowned self] in
        
        var childVC:[UIViewController] = []
        
        let campusJob = CampusJobCollectedVC()
        childVC.append(campusJob)
        
        let internJob = InternJobCollectedVC()
        childVC.append(internJob)
        
        let companyJob = CompanyCollectedVC()
        childVC.append(companyJob)

        let meeting = MeetingCollectedVC()
        childVC.append(meeting)
        
        let apply = OnlineApplyCollectedVC()
        //let post = PostCollectedViewController()
        childVC.append(apply)
        
        let v:PageContentView = PageContentView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH + pagetTitleH , width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH - pagetTitleH), childVCs: childVC, pVC: self)
        v.delegate = self
        return v
        
        
    }()
    
   

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)

        
    }
    
    
    deinit {
        print("deinit myCollectedVC \(self)")
    }
    



}

extension MyCollectionVC{
    
    private func setView(){
        
        self.title = viewTitle
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(pageTitle)
        self.view.addSubview(pageContent)
        self.view.addSubview(bottomBar)
        //self.navigationController?.delegate = self
        //addDeleteItem()
        navigationItem.rightBarButtonItem = rightBarBtn
        
       // addToobarItem()
    }
    
    
    private func setViewModel(){
        self.rightBarBtn.rx.tap.asDriver().drive(onNext: { [weak self] in
            //self?.edit()
            guard let `self` = self else {
                return
            }
            
            self.isEdit = !self.isEdit
            if self.isEdit{
                NotificationCenter.default.post(name: NotificationName.collecteItem[self.currentSelect], object: nil, userInfo: ["action":"edit"])
                self.navigationItem.rightBarButtonItem?.title = "取消"
                self.bottomBar.isHidden = false
            }else{
                NotificationCenter.default.post(name: NotificationName.collecteItem[self.currentSelect], object: nil, userInfo: ["action":"cancel"])
                self.navigationItem.rightBarButtonItem?.title = "编辑"
                self.bottomBar.isHidden = true
                
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.chooseAll.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.isAll = !self.isAll
            if self.isAll{
                NotificationCenter.default.post(name: NotificationName.collecteItem[self.currentSelect], object: nil, userInfo: ["action":"selectAll"])
                self.chooseAll.isSelected = true
            }else{
                NotificationCenter.default.post(name: NotificationName.collecteItem[self.currentSelect], object: nil, userInfo: ["action":"unselect"])
                self.chooseAll.isSelected = false
            }
            
            
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.delete.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            
             NotificationCenter.default.post(name: NotificationName.collecteItem[self.currentSelect], object: nil, userInfo: ["action":"delete"])
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
    
    
    
//    private func addToobarItem(){
//        self.view.addSubview(bottomBar)
//
//    }
    
 
    
    
}


//extension MyCollectionVC: UINavigationControllerDelegate{
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if viewController.isKind(of: PersonViewController.self){
//            navigationController.removeCustomerView()
//        }
//    }
//}

extension MyCollectionVC: pagetitleViewDelegate{
    func ScrollContentAtIndex(index: Int) {
        NotificationCenter.default.post(name: NotificationName.collecteItem[self.currentSelect], object: nil, userInfo: ["action":"cancel"])
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
        NotificationCenter.default.post(name: NotificationName.collecteItem[self.currentSelect], object: nil, userInfo: ["action":"cancel"])
        navigationItem.rightBarButtonItem?.title = "编辑"
        chooseAll.isSelected = false
        bottomBar.isHidden = true
        currentSelect = targetIndex
    }
    
    
}

