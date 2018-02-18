//
//  MyCollectionVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let viewTitle:String = "收藏"

class MyCollectionVC: UIViewController, UIScrollViewDelegate {

    private var childVC:[UIViewController] = []
    // 当前tableview
    private var currentTableView:UITableView?
    
    private var jobType:JobManager.jobType = .none
    
    private var currentContent:Int? {
        didSet{
            // 切换tableview时，取消编辑状态
            currentTableView =  (childVC[currentContent!]  as! UITableViewController).tableView
            currentTableView?.setEditing(false, animated: false)
            bottomBar.isHidden = true
            editBtn.isSelected = false
            selectedAllBtn.isSelected = false
            selectedAllBtn.backgroundColor = UIColor.clear
            switch currentContent!{
            case 0:
                jobType = JobManager.jobType.compus
            case 1:
                jobType = JobManager.jobType.company
            default:
                break
            }
        }
    }
    private let titles:[String] = ["职位收藏","公司收藏"]
    
    // 界面下方toolbar显示
    private lazy var bottomBar:UIToolbar = {
        let tool = UIToolbar.init(frame: CGRect.init(x: 0, y: ScreenH - 60, width: ScreenW, height: 60))
        tool.isHidden = true
        tool.barStyle = .default
        tool.isTranslucent = true
        tool.tintColor = UIColor.blue
         return tool
    }()
    
    private lazy var pageTitleView:pagetitleView = { [unowned self ] in
        let pageTitle:pagetitleView = pagetitleView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: 40), titles: self.titles)
        pageTitle.delegate = self
        return pageTitle
        
    }()
    
    private lazy var pageContent:pageContentView = { [unowned self] in
        
        for (_, title) in self.titles.enumerated(){
            if title == "职位收藏"{
                let vc = jobCollectedVC()
                childVC.append(vc)
            }else if title == "公司收藏"{
                let vc = CompanyCollectedVC()
                childVC.append(vc)
            }
            
        }
        let v:pageContentView = pageContentView.init(frame: CGRect.init(x: 0, y: NavH + 40 , width: ScreenW, height: ScreenH - NavH - 40), childVCs: childVC, pVC: self)
        v.delegate = self
        return v
        
        
    }()
    
    // 编辑按钮
    private lazy var editBtn:UIButton = { [unowned self] in
        
        let editBtn = UIButton.init(type: .custom)
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitleColor(UIColor.blue, for: .normal)
        editBtn.setTitleColor(UIColor.blue, for: .selected)
        editBtn.setTitle("取消", for: .selected)
        editBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        editBtn.addTarget(self, action: #selector(editCell(btn:)), for: .touchUpInside)
        
        return editBtn
    }()
    // toolbar 里的全选按钮
    private lazy var  selectedAllBtn:UIButton = { [unowned self] in
        let selectedAllBtn = UIButton.init(type: .custom)
        selectedAllBtn.setTitleColor(UIColor.blue, for: .normal)
        selectedAllBtn.setTitleColor(UIColor.white, for: .selected)
        selectedAllBtn.addTarget(self, action: #selector(selectedAll(btn:)), for: .touchUpInside)
        selectedAllBtn.setTitle("全选", for: .normal)
        selectedAllBtn.setTitle("取消", for: .selected)
        return selectedAllBtn
    }()
    
    // toolbar 里的删除按钮
    private lazy var deletedBtn:UIButton = { [unowned self] in
        let deletedBtn = UIButton.init(type: .custom)
        deletedBtn.setTitleColor(UIColor.blue, for: .normal)
        deletedBtn.addTarget(self, action: #selector(deleted(btn:)), for: .touchUpInside)
        deletedBtn.setTitle("删除", for: .normal)
        return deletedBtn
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        //self.  contentInsetAdjustmentBehavior = .never
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(pageTitleView)
        self.view.addSubview(pageContent)
       
        
        setNavigationBtn()
        bottomToolBar()
        // 默认第一个tableview
        currentContent = 0
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = viewTitle
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }

    
    private func setNavigationBtn(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editBtn)
        
    }
    
    private func bottomToolBar(){
        self.view.addSubview(bottomBar)
    
        //let preSpace =  UIBarButtonItem(barButtonSystemItem:.flexibleSpace,
        //                                target:nil, action:nil)
        
        let middleSpace =  UIBarButtonItem(barButtonSystemItem:.flexibleSpace,
                                           target:nil, action:nil)
        
        //let postSpace =  UIBarButtonItem(barButtonSystemItem:.flexibleSpace,
        //                                 target:nil, action:nil);
        
        bottomBar.setItems([UIBarButtonItem.init(customView: selectedAllBtn),middleSpace,UIBarButtonItem.init(customView: deletedBtn)], animated: false)
        
        
    }

}

extension MyCollectionVC{
    @objc func editCell(btn:UIButton){
        
        if btn.isSelected{
            // 取消
            bottomBar.isHidden = true
            currentTableView?.setEditing(false, animated: false)
            selectedAllBtn.isSelected = false
            selectedAllBtn.backgroundColor = UIColor.clear

        }else{
            // 编辑
            bottomBar.isHidden = false
            currentTableView?.setEditing(true, animated: false)
            
            
        }
        
        btn.isSelected = !btn.isSelected
        
     }
    
    // 全选
    @objc func selectedAll(btn:UIButton){
        
        if btn.isSelected{
            // 取消
            currentTableView?.reloadData()
            btn.backgroundColor = UIColor.clear
        }else{
            
            // 全选
            for index in 0..<jobManageRoot.getCollections(type: jobType).count{
                currentTableView?.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .top)
                
            }
            btn.backgroundColor = UIColor.blue
        }
        btn.isSelected = !btn.isSelected
       
    }
    
    // 删除
    @objc func deleted(btn:UIButton){
        
        var selectedRow = [Int]()
        
        if let selectedItem = currentTableView?.indexPathsForSelectedRows{
            for indexPath in selectedItem{
                selectedRow.append(indexPath.row)
            }
            // 删除多个记录
            jobManageRoot.removeCollectedByIndex(type: jobType, row: selectedRow)
            currentTableView?.reloadData()
            
        }
        // 取消编辑状态
        currentTableView?.setEditing(false, animated: true)
        editBtn.isSelected = false
        selectedAllBtn.isSelected = false
        selectedAllBtn.backgroundColor = UIColor.clear
        bottomBar.isHidden = true
    }
    
}

extension MyCollectionVC: pagetitleViewDelegate{
    
    func ScrollContentAtIndex(index: Int, _ titleView: pagetitleView) {
        self.currentContent = index
        self.pageContent.moveToIndex(index)
    }
}

extension MyCollectionVC: PageContentViewScrollDelegate{
    
    func pageContenScroll(_ contentView: pageContentView, progress: CGFloat, sourcIndex: Int, targetIndex: Int) {
        self.currentContent = targetIndex
         self.pageTitleView.changeTitleWithProgress(progress, sourceIndex: sourcIndex, targetIndex: targetIndex)
    }
}
