//
//  messageMain.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let CollectionCellID = "cell"

class messageMain: UIViewController {

    
    private var currentItem:Int?{
        didSet{
              self.showCurrentView()
        }
    }
    private var chidVCs:[UIViewController] = []
    
    
    private lazy var collections:UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
    
        let collv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellID)
        collv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collv.showsVerticalScrollIndicator = false
        collv.showsHorizontalScrollIndicator = false
        collv.isPagingEnabled = true
        
        collv.isScrollEnabled  = false
        collv.bounces = false
        collv.dataSource = self
        collv.delegate = self
        collv.scrollsToTop = false
        
        
        return collv
    }()
    
    // 切换菜单
    private lazy var segeMentView:UISegmentedControl = {
        let sg = UISegmentedControl.init()
        sg.backgroundColor = UIColor.white
        
        sg.insertSegment(withTitle: "聊天", at: 0, animated: false)
        sg.insertSegment(withTitle: "看过我", at: 1, animated: false)
        sg.insertSegment(withTitle: "论坛", at: 2, animated: false)
        sg.selectedSegmentIndex = 0
        sg.backgroundColor = UIColor.orange
        sg.tintColor = UIColor.white
        
        sg.addTarget(self, action: #selector(switchItem(_:)), for: .valueChanged)
        return sg
        
    }()
    
    
    // 聊天vc
    private lazy var chatVC:ChatListViewController =  ChatListViewController()
    
    // 看过我vc
    private lazy var visitorVC:MyVisitor = MyVisitor()
    
    // 论坛消息
    private lazy var forume:ForumMessageVC = ForumMessageVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        self.navigationController?.navigationBar.settranslucent(true)
        
        
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)
        
        
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
        
    }
    
    

}


extension messageMain{
    
    @objc private func switchItem(_ sender:UISegmentedControl){
        
        currentItem =  sender.selectedSegmentIndex
        
        // TEST 测试
        if let target =  sender.titleForSegment(at: currentItem!){
            sender.subviews[currentItem!].subviews.forEach { view in
                if let lb = view as? UILabel, lb.text == "聊天"{
                    view.pp.addDot(color: UIColor.red)
                    view.pp.moveBadge(x: 2, y: 0)
                    view.pp.setBadge(height: 5)
                }
            }
            
            
        }
    }
}

extension messageMain {
    
    private func setViews(){
        
        
        chidVCs.append(chatVC)
        chidVCs.append(visitorVC)
        chidVCs.append(forume)
        chidVCs.forEach{
            self.addChild($0)
            $0.didMove(toParent: self)
        }
        self.view.addSubview(collections)
        collections.frame = CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH)
        
        self.navigationItem.titleView = segeMentView
        self.navigationController?.view.backgroundColor = UIColor.white

        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        currentItem = 0
        
    
    }
    

}


extension messageMain: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chidVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID, for: indexPath)
        
        cell.contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        // 把子vc 的view 放入cell
        let cVC = chidVCs[indexPath.row]
        cVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(cVC.view)
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH)
    }
    
    
}


extension messageMain{
    private func showCurrentView(){
        guard let index = currentItem  else { return  }
        let offsetX = CGFloat(index)*collections.frame.width
        collections.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: false)
    }
}



